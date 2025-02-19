import requests
from django.conf import settings
from django.forms.models import model_to_dict
import json
from train.dao.DatasetImgDAO import DatasetImgDAO
class TrainingServiceCustom:

    @staticmethod
    def start_training(training_params):
        # URL of the FastAPI endpoint to post the training params
        url = settings.CUSTOM_TRAINING_PS_URL   
        training_job = model_to_dict(training_params.get("training_job"))
        
        
        parameter_settings = training_job["parameter_settings"]
        try: 
            del parameter_settings["training_job"]
            del parameter_settings["user"]

        except:
            print ("unable to delete training_job key: del parameter_settings['training_job']")
           
        if isinstance(parameter_settings, str):
            parameter_settings= json.loads(parameter_settings)

        job_data = {
                "job_id": training_job['id'],
                "job_name": training_job['job_name'],
                "dataset_img": training_job["dataset_img"],
                "status": training_job["status"],
                "algo": training_job["algo"],
                "user": training_job["user"],  # Serialize ForeignKey as user ID
                "parameter_settings": parameter_settings,
                 
            }
                



        init_params ={}
        init_params["job_data"] = job_data
        init_params = set_dataset_details(training_job["dataset_img"], init_params)
        payload = {
            "init_params": init_params
        }
        
        try:
            url +="/"+str(training_job['id'])
            # Sending POST request to FastAPI
            response = requests.post(url, json=payload)
            
            # Check if the request was successful (status code 200)
            if response.status_code == 200:
                return response.json()  
            else:
                raise Exception(f"Error in training request: {response.text}")
        
        except Exception as e:
            print(f"Error during HTTP request to FastAPI: {str(e)}")
            return None



def set_dataset_details(dataset_id, init_params):
     
    dataset = DatasetImgDAO.get(dataset_id)
    init_params["dataset_details"] = dataset.gather_dataset_stats()
    init_params["dataset_details"]["host_url"] = settings.DATASET_HOST_URL
    return init_params
 



