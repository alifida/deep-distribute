from django.http import HttpResponse
from django.shortcuts import redirect
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from train.forms.forms import TrainingJobForm
from train.services.TrainingJobService import TrainingJobService
from common.utils import util
from train.utils.JobStatus import JobStatus

@login_required
def list(request):
    jobs = TrainingJobService.list()
    return util.render(request, 'training/list.html', {'jobs': jobs, 'status_running': JobStatus.RUNNING.value})



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
    return util.render(request, 'training/start.html', context)

@login_required
def delete(request, job_id):
    if request.method == 'POST':
        TrainingJobService.delete(job_id)   
        messages.success(request, "Training Job Deleted successfully.")
        return util.redirect('training_job_list')
    else:
        return HttpResponse("Method Not Allowed", status=405)
    

@login_required
def start_training(request, dataset_id):
     
    TrainingJobService.startTraining(dataset_id,  request.user)   
    messages.success(request, "Training Job Started successfully.")
    return util.redirect('training_job_list')

@login_required
def stop_training(request, job_id):
     
    TrainingJobService.stopTraining(job_id)   
    messages.success(request, "Stopping the Training.")
    return util.redirect('training_job_list')
     


