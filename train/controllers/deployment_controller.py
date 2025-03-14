import ast
from train.models import Dataset, TrainedModel, Dataset_IMG
from django.urls import reverse
from django.http.response import HttpResponse
from django.contrib.auth.decorators import login_required, permission_required
from django.shortcuts import get_object_or_404, HttpResponse
from django.db import transaction
from common.utils import util
import pandas as pd
import joblib
from django.shortcuts import get_object_or_404
from train.services.DatasetImgService import DatasetImgService
from train.services.TrainingJobService import TrainingJobService
import tensorflow as tf
import numpy as np
from PIL import Image
import ast
import json
from common.utils.pandautil import  encode_categorical_columns

import csv


@login_required
@permission_required('train.enduser_basic')
def index(request): 
    current_user=request.user
    print(current_user)
    data ={"current_user":current_user}
    return util.myrender(request, 'models/index.html', data)



@login_required 
@permission_required('train.enduser_basic')
def list_deployed_models(request):
    data = {}
    data ["section_heading"]='Deployed Models'
    data['model_list'] = get_deployed_models(request)
    data['default_model_id'] = -1
    data['model_list_count'] = 0
    
    if data['model_list'].exists():
        data['model_list_count'] = data['model_list'].count()
        data['default_model_id'] = data["model_list"][0].id
         
    return util.myrender(request, 'models/model_list.html', data)
@login_required 
@permission_required('train.enduser_basic')
def list_all_datasets(request):
    data = {}
    
    data['dataset_count']=0
     

    if request.user.is_authenticated:
        username = request.user
        datasets_csv = Dataset.objects.filter(user_id=username.id)
        data['dataset_csv_list'] = datasets_csv
        if datasets_csv.exists():
            data['dataset_count']=datasets_csv.count()

    
        data['dataset_images_list']  = DatasetImgService.list(request.user.id)  # Adjusted to use the service layer
        
        if data['dataset_images_list'].exists() and data['dataset_count'] == 0:
            data['dataset_count']=data['dataset_images_list'].count()
     



    return util.myrender(request, 'models/list_all_datasets.html', data)


@login_required
@permission_required('datasource.delete_dataset')
def download_csv_template(request, pk):
    # Convert the string to a list
    username = request.user
    model = fetch_model_by_id(pk=pk, username=username)
    header_string=""
    model_name=""
    class_label =""
    if model:
        header_string = model.key_attributes
        model_name = model.description
        #class_label =str(model.class_label)

    headers = ast.literal_eval(header_string)
    # Append the class_label to the headers list
    #headers.append(class_label)
    
    # Create the HttpResponse object with the appropriate CSV header.
    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="'+str(pk)+ ' '+ model_name+  ' template.csv"'
    
    # Create a CSV writer using the response object as the file-like object
    writer = csv.writer(response)
    
    # Write the header row
    writer.writerow(headers)
    
    # You can add an optional sample row if needed
    # writer.writerow(["Sample Data"] * len(headers))
    
    return response
    

@login_required 
@permission_required('train.enduser_basic')
def delete_model(request, pk):
    # Retrieve the trained model object
    trained_model = get_object_or_404(TrainedModel, id=pk)
    
    jsonResponse = {}

    # Check ownership
    if trained_model.user != request.user:
        jsonResponse['status'] = 'success'
        jsonResponse['message'] = 'Your not authorized to use this object';
        
        return HttpResponse(util.tojson(jsonResponse))
        
    

    try:
        with transaction.atomic():
            
            TrainedModel.objects.filter(
                id=pk
            ).delete()


            if trained_model.dataset_img:
                TrainingJobService.delete_by_dataset_img_id(trained_model.dataset_img.id)

        jsonResponse['status'] = 'success'
        jsonResponse['message'] = "Model deleted successfully";
        
    
    except Exception as e:
        
        jsonResponse['status'] = 'error'
        jsonResponse['status_code'] = 500
        jsonResponse['message'] = "Error while deleting : "+str(e)+"";
        print(f"Error while deleting: {str(e)}")
        
        return HttpResponse(util.tojson(jsonResponse))
    
    jsonResponse['status_code'] = 200
    jsonResponse["redirectURL"] = reverse('model_welcome')
    
    return HttpResponse(util.tojson(jsonResponse))
    #return util.redirect("model_welcome")


@login_required 
@permission_required('train.enduser_basic')
def predict_csv_trained_model(request):
    data = {}

    if request.method == 'POST':
        # Retrieve form and file data
        form_data = {key.replace("__key_attrib_",""): value for key, value in request.POST.items() if key != 'csrfmiddlewaretoken' and key.startswith("__key_attrib_")}
        
        file_data = request.FILES.get('supply_dataset')
        model_id = int(request.POST.get('model_id', -1))

        if model_id > 0:
            # Disable GPU if TensorFlow is inadvertently imported
            try:
                import tensorflow as tf
                with tf.device('/CPU:0'):  # Force TensorFlow to use the CPU if it is involved
                    # Fetch the trained model
                    trained_model = get_object_or_404(TrainedModel, id=model_id)
                    model_path = trained_model.model_file.path

                    # Load the scikit-learn model
                    model = joblib.load(model_path)

                    if file_data:
                        # Handle the uploaded CSV file
                        if file_data.name.endswith('.csv'):
                            df = pd.read_csv(file_data)
                        elif file_data.name.endswith(('.xls', '.xlsx')):
                            df = pd.read_excel(file_data)
                    else:
                        # Handle single record from form data
                        df = pd.DataFrame([form_data])

                    # Ensure the dataframe columns match the model’s expected features
                    expected_features = model.get_params().get('feature_names_in_', None)
                    if expected_features:
                        df = df[expected_features]

                    # Handle categorical features here (this step is likely missing in your original code)
                    # This assumes that you used some form of categorical encoding during training
                    # For example, using LabelEncoder or OneHotEncoder
                    df = encode_categorical_columns(df)  # This function should match the one used during training
                     # Handle NaN and infinite values
                    df.replace([np.inf, -np.inf], np.nan, inplace=True)  # Replace infinite values with NaN
                    df.fillna(0, inplace=True)  # Replace NaN values with 0, or you could fill with the mean/median

                    # Make predictions
                    predictions = model.predict(df)
                    columns = ast.literal_eval(trained_model.key_attributes)
                    class_label = str(trained_model.class_label)
                    columns.append(class_label)

                    # Create a DataFrame with the key attributes from the original df
                    predictions_df = df[columns[:-1]].copy()  # All columns except the class label

                    # Add the predictions as a new column
                    predictions_df[class_label] = predictions

                    # Iterate over the DataFrame to prepare the output
                    predictions_list = []
                    for index, row in predictions_df.iterrows():
                        row_data = {}
                        for col in columns:
                            if col != class_label:
                                row_data[col] = row[col]
                        row_data[class_label] = row[class_label]
                        predictions_list.append(row_data)

                    data['predictions'] = predictions_list
                    data["class_label"] = class_label

            except ImportError:
                # If TensorFlow isn't installed, just proceed as normal
                # Fetch the trained model and load without TensorFlow
                trained_model = get_object_or_404(TrainedModel, id=model_id)
                model_path = trained_model.model_file.path
                model = joblib.load(model_path)

                if file_data:
                    # Handle the uploaded CSV file
                    if file_data.name.endswith('.csv'):
                        df = pd.read_csv(file_data)
                    elif file_data.name.endswith(('.xls', '.xlsx')):
                        df = pd.read_excel(file_data)
                else:
                    df = pd.DataFrame([form_data])

                expected_features = model.get_params().get('feature_names_in_', None)
                if expected_features:
                    df = df[expected_features]

                # Handle categorical features here (this step is likely missing in your original code)
                # This assumes that you used some form of categorical encoding during training
                # For example, using LabelEncoder or OneHotEncoder
                df = encode_categorical_columns(df)  # Ensure this matches what was done in training
                
                predictions = model.predict(df)
                columns = ast.literal_eval(trained_model.key_attributes)
                class_label = str(trained_model.class_label)
                columns.append(class_label)

                predictions_df = df[columns[:-1]].copy()
                predictions_df[class_label] = predictions

                predictions_list = []
                for index, row in predictions_df.iterrows():
                    row_data = {}
                    for col in columns:
                        if col != class_label:
                            row_data[col] = row[col]
                    row_data[class_label] = row[class_label]
                    predictions_list.append(row_data)

                data['predictions'] = predictions_list
                data["class_label"] = class_label

    return util.myrender(request, 'models/result_template.html', data)



from tensorflow.keras.preprocessing.image import img_to_array
def preprocess_image(image, model):
    # Convert image to RGB if not already
    if image.mode != 'RGB':
        image = image.convert('RGB')

    # Get the input size directly from the model
    input_shape = model.input_shape  # Get input shape from the model
    
    # If the input shape includes a batch size (None), we ignore it
    target_size = (input_shape[1], input_shape[2])  # Get the target height and width

    # Resize image according to the model's input size
    image = image.resize(target_size)

    # Convert image to array
    image_array = img_to_array(image)

    # Normalize the image (optional: depends on your model, you can adjust accordingly)
    image_array = image_array / 255.0

    # Expand dimensions to match model input
    image_array = np.expand_dims(image_array, axis=0)
    
    return image_array

@permission_required('train.enduser_basic')
def predict_img_trained_model(request):
    data = {}
    data["prediction_result"] = "Result will come here"

    if request.method == 'POST':
        # Retrieve the uploaded image and model ID
        file_data = request.FILES.get('image')
        model_id = int(request.POST.get('model_id', -1))

        if model_id > 0:
            # Disable GPU for single image prediction
            import tensorflow as tf
            with tf.device('/CPU:0'):  # Force TensorFlow to use CPU
                # Fetch the pre-trained model from the database
                trained_model = get_object_or_404(TrainedModel, id=model_id)
                model_path = trained_model.model_file.path
                
                # Load the Keras model
                model = tf.keras.models.load_model(model_path)

                if file_data:
                    # Pre-process the uploaded image for prediction
                    image = Image.open(file_data)
                    image_array = preprocess_image(image, model)

                    # Make a prediction
                    prediction = model.predict(image_array)

                    # Fetch class labels (assumes trained_model stores them as JSON or list)
                    class_labels = ast.literal_eval(trained_model.class_label)  # Expecting a list of class labels
                     
                    if len(class_labels) > 2:
                        # For N-class (multi-class) predictions
                        predicted_class_index = np.argmax(prediction[0])  # Get the index of the highest probability class
                        predicted_class = class_labels[predicted_class_index]  # Get the class label
                    else:
                        # For binary classification
                        predicted_class = class_labels[1] if prediction[0][0] > 0.5 else class_labels[0]
                        print (prediction[0][0])
                    # Prepare the prediction result to display
                    data['prediction_result'] = predicted_class
        
    return util.myrender(request, 'models/result_template.html', data)

@login_required 
@permission_required('train.enduser_basic')
def get_model_by_id(request, pk):
    data = {}
    data['deployed_model'] = {}
    data['columns'] ={}
    if request.user.is_authenticated:
        username = request.user
        model = fetch_model_by_id(pk=pk, username=username)
        if model:
            data['deployed_model']= model
            if model.dataset:
                data['deployed_model'].key_attributes = ast.literal_eval(data['deployed_model'].key_attributes)
            

            #print(data['deployed_model'].dataset.metainfo)
    return util.myrender(request, 'models/form_template.html', data)

def fetch_model_by_id(pk, username):
    models = TrainedModel.objects.filter(user_id=username.id, id=pk)
    if models.exists():
        return models[0]
    return None



@login_required
def get_deployed_models(request):
     
    models=[]
    if request.user.is_authenticated:
        username = request.user
        models = TrainedModel.objects.filter(user_id=username.id, status='Deployed')
    return models






@login_required
@permission_required('train.enduser_basic')
def deploy_trained_img_model(request, trained_model_id):
    """
    Handle the deployment of a trained model.
    
    :param request: HTTP request containing the trained model ID.
    :param trained_model_id: ID of the trained model to deploy.
    :return: HTTP response indicating the result of the operation.
    """
    # Retrieve the trained model object
    trained_model = get_object_or_404(TrainedModel, id=trained_model_id)
    
    jsonResponse = {}

    # Check ownership
    if trained_model.user != request.user:
        jsonResponse['status'] = 'success'
        jsonResponse['message'] = 'Your not authorized to use this object';
        
        return HttpResponse(util.tojson(jsonResponse))

    try:
        with transaction.atomic():
            # Update the status of the current trained model to 'Deployed'
            trained_model.status = 'Deployed'
            trained_model.save()
            
            # Get the dataset associated with the trained model
            dataset_img = Dataset_IMG.objects.get(id=trained_model.dataset_img_id)
            
            # Delete other trained models with the same dataset but not 'Deployed'
            TrainedModel.objects.filter(
                dataset_img_id=dataset_img.id
            ).exclude(
                id=trained_model_id
            ).delete()
        jsonResponse['status'] = 'success'
        jsonResponse['message'] = "Model deployed successfully";
        
    
    except Exception as e:
        
        jsonResponse['status'] = 'error'
        jsonResponse['status_code'] = 500
        jsonResponse['message'] = "Error during deployment: "+str(e)+"";
        print(f"Error during deployment: {str(e)}")
        
        return HttpResponse(util.tojson(jsonResponse))
    
    jsonResponse['status_code'] = 200
    jsonResponse["redirectURL"] = reverse('model_welcome')
    
    return HttpResponse(util.tojson(jsonResponse))
    #return util.redirect("model_welcome")




@login_required
@permission_required('train.enduser_basic')
def deploy_trained_csv_model(request, trained_model_id):
    """
    Handle the deployment of a trained model.
    
    :param request: HTTP request containing the trained model ID.
    :param trained_model_id: ID of the trained model to deploy.
    :return: HTTP response indicating the result of the operation.
    """
    # Retrieve the trained model object
    trained_model = get_object_or_404(TrainedModel, id=trained_model_id)
    
    jsonResponse = {}

    # Check ownership
    if trained_model.user != request.user:
        jsonResponse['status'] = 'success'
        jsonResponse['message'] = 'Your not authorized to use this object';
        
        return HttpResponse(util.tojson(jsonResponse))
        
    

    try:
        with transaction.atomic():
            # Update the status of the current trained model to 'Deployed'
            trained_model.status = 'Deployed'
            trained_model.save()
            
            # Get the dataset associated with the trained model
            dataset = Dataset.objects.get(id=trained_model.dataset_id)
            
            # Delete other trained models with the same dataset but not 'Deployed'
            TrainedModel.objects.filter(
                dataset_id=dataset.id
            ).exclude(
                id=trained_model_id
            ).delete()
        jsonResponse['status'] = 'success'
        jsonResponse['message'] = "Model deployed successfully";
        
    
    except Exception as e:
        
        jsonResponse['status'] = 'error'
        jsonResponse['status_code'] = 500
        jsonResponse['message'] = "Error during deployment: "+str(e)+"";
        print(f"Error during deployment: {str(e)}")
        
        return HttpResponse(util.tojson(jsonResponse))
    
    jsonResponse['status_code'] = 200
    jsonResponse["redirectURL"] = reverse('model_welcome')
    
    return HttpResponse(util.tojson(jsonResponse))
    #return util.redirect("model_welcome")




