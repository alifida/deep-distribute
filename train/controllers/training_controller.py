
import json 
from django.http import HttpResponse
from django.shortcuts import redirect
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from train.forms.forms import TrainingJobForm
from train.services.TrainingJobService import TrainingJobService
from common.utils import util
from train.utils.JobStatus import JobStatus
from django.forms.models import model_to_dict


from train.forms.forms import DatasetImgForm
from train.services.DatasetImgService import DatasetImgService
from train.services.KerasCatalogService import KerasCatalogService

@login_required
def list(request):
    jobs = TrainingJobService.list()
    return util.myrender(request, 'training/list.html', {'jobs': jobs, 'status_running': JobStatus.RUNNING.value})



@login_required
def edit(request, job_id=None):
    job = None
    if job_id:  # Check if job_id is provided and valid
        job = TrainingJobService.get(job_id)  # Fetch the existing job

    if request.method == 'POST':
        form = TrainingJobForm(request.POST, request.FILES, instance=job)
        if form.is_valid():
            job = form.save(commit=False)  # Get the job object from form, don't save yet
            job.user = request.user  # Set the user or any other fields not included in the form
            job.save()  # Now save the job

            if job_id:
                messages.success(request, "Training Job Updated successfully.")
            else:
                messages.success(request, "Training Job Created successfully.")
            
            return util.redirect('training_job_list')
    else:
        form = TrainingJobForm(instance=job)

    context = {
        'form': form,
        'job': job
    }
    return util.myrender(request, 'training/start.html', context)

@login_required
def delete(request, job_id):
    TrainingJobService.delete(job_id)   
    messages.success(request, "Training Job Deleted successfully.")
    return util.redirect('training_job_list')
    '''if request.method == 'POST':
        TrainingJobService.delete(job_id)   
        messages.success(request, "Training Job Deleted successfully.")
        return util.redirect('training_job_list')
    else:
        return HttpResponse("Method Not Allowed", status=405)
    '''

@login_required
def start_training_post(request):
    if request.method == 'POST':
        # Extract data from the POST request
        dataset_id = request.POST.get('dataset_id')
        model = request.POST.get('model')
        strategy = request.POST.get('strategy')

        epochs = request.POST.get('epochs', 10)  # Default to 10 if not provided
        batch_size = request.POST.get('batch_size', 32)  # Default to 32 if not provided
        learning_rate = request.POST.get('learning_rate', 0.001)  # Default to 0.001 if not provided
        optimizer = request.POST.get('optimizer', 'adam')  # Default to 'adam' if not provided
        loss_function = request.POST.get('loss_function', 'binary_crossentropy')  # Default to binary_crossentropy
        validation_split = request.POST.get('validation_split', 0.2)  # Default to 0.2 if not provided
        early_stopping_patience = request.POST.get('early_stopping_patience', 10)  # Default to 10 if not provided
        dropout_rate = request.POST.get('dropout_rate', 0.5)
        augmentation = request.POST.get('augmentation', 'None')  # Default to 'None' if not provided
        class_weights = request.POST.get('class_weights', '{0:1.0, 1:1.0}')  # Default to '{0:1.0, 1:1.0}' if not provided
        random_seed = request.POST.get('random_seed', '42')  # Default to '42' if not provided

        training_params = {
            'dataset_id': dataset_id,
            'user': request.user, 
            'strategy': strategy, 
            'algo_name': model, 
            'epochs': epochs, 
            'batch_size' : batch_size, 
            'learning_rate' : learning_rate, 
            'optimizer' : optimizer, 
            'loss_function': loss_function, 
            'validation_split': validation_split, 
            'early_stopping_patience': early_stopping_patience, 
            'dropout_rate': dropout_rate, 
            'augmentation': augmentation, 
            'class_weights': class_weights, 
            'random_seed': random_seed
        }



        #delete other training objects by dataset to keep only one job per dataset
        TrainingJobService.delete_by_dataset_img_id(dataset_id)
        TrainingJobService.startTraining(training_params) 


       

        messages.success(request, "Training Job Started successfully.")
    else:
        messages.error(request, "Cannot strat training.")

    return util.redirect('start_training' , dataset_id)

from train.models import TrainedModel

@login_required
def get_training_result(request, dataset_id):
    res={}
    trainingJob = TrainingJobService.getSingleByDatasetAndStatus(dataset_id, "COMPLETED")
    if trainingJob and trainingJob.result:
        res["results"] = json.loads(trainingJob.result)
        model = TrainedModel.objects.filter(dataset_img_id=dataset_id).last()
        if model:
            res["model_id"] = model.id
        
    
    return util.myrender(request, 'training/results.html', res)





@login_required
def get_training_progress(request,dataset_id, job_id):
    
    res ={}
    res['job_status'] = ''
    if job_id == 0:
        trainingJob = TrainingJobService.getSingleByDataset(dataset_id)
        if trainingJob:
            res['log'] = trainingJob.training_log
            
    else:          
        trainingJob=TrainingJobService.get(job_id)
        res['log'] = trainingJob.training_log

    if res.get('log') :
        res['log'] = json.loads(trainingJob.training_log)
    else:
        res['log'] = ''
    if trainingJob:
        print(trainingJob.parameter_settings)
        print("--------------------------------------")
        parameter_settings = trainingJob.parameter_settings.replace("'", '"')
        parameter_settings = json.loads(parameter_settings)
        res['total_epochs'] = parameter_settings['epochs']; 
        res['job_status'] = trainingJob.status
    
    else:
        res['total_epochs'] = 0 
        res['job_status'] = ''
    res['status_code'] = 200

    return HttpResponse(util.tojson(res))



@login_required
def training(request, dataset_id=None):
    datasets = DatasetImgService.list(request.user.id)  # Adjusted to use the service layer
    
    models = KerasCatalogService.list_all_models()
    strategies = KerasCatalogService.list_all_strategies()
 
     
    print("\nAvailable Keras layers:")
    print(KerasCatalogService.list_all_layers())

    print("\nAvailable Keras optimizers:")
    print(KerasCatalogService.list_all_optimizers())


    

    context = {
            'datasets': datasets,
            'dataset': {},
            'stats': {},
            'trainings': {},
            
    }
    if len(datasets) > 0:
        if dataset_id ==None:
            dataset_id= datasets[0].id
        
         
        dataset = DatasetImgService.get(dataset_id, True)
        stats = dataset.gather_dataset_stats()
        trainings = TrainingJobService.list_by_dataset(dataset_id);
        context = {
            'datasets': datasets,
            'dataset': dataset,
            'stats': stats,
            'trainings': trainings,
        }
        

    context['models']= models.items()
    context['strategies']= strategies



    return util.myrender(request, 'training/start.html', context)






@login_required
def stop_training(request, job_id):
     
    TrainingJobService.stopTraining(job_id)   
    messages.success(request, "Stopping the Training.")
    return util.redirect('training_job_list')
     


'''
@login_required
def start_training(request, dataset_id, strategy):
     
    TrainingJobService.startTraining(dataset_id,  request.user, strategy)   
    messages.success(request, "Training Job Started successfully.")
    return util.redirect('training_job_list')

'''