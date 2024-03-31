from django.http import HttpResponse
from django.conf import settings
from django.contrib.auth.decorators import login_required
from train.forms.forms import DatasetImgForm
from train.services.DatasetImgService import DatasetImgService
from common.utils import util
from django.contrib import messages

@login_required
def list(request):
    datasets = DatasetImgService.list()  # Adjusted to use the service layer

    return util.render(request, 'dataset/list.html', {'datasets': datasets})

@login_required
def create(request):
    if request.method == "POST":
        form = DatasetImgForm(request.POST, request.FILES)
        if form.is_valid():
            # Extract form data
            data_name = form.cleaned_data['data_name']
            data_path = form.cleaned_data['data_path']
            metainfo = form.cleaned_data['metainfo']
            status = form.cleaned_data['status']
            user = request.user
            # Use service layer to create a new dataset
            DatasetImgService.create(data_name=data_name, data_path=data_path, metainfo=metainfo, status=status, user=user)
            messages.success(request, "Dataset Saved successfully.")
            
            return util.redirect('list_dataset')
    else:
        form = DatasetImgForm()
    return util.render(request, 'dataset/create.html', {'form': form})

@login_required
def edit(request, dataset_id):
    dataset = DatasetImgService.get(dataset_id)  # Use service to fetch the dataset
    if request.method == 'POST':
        form = DatasetImgForm(request.POST, request.FILES, instance=dataset)
        if form.is_valid():
            # Use service layer to update, passing cleaned form data as kwargs
            DatasetImgService.update(dataset_id, **form.cleaned_data)
            messages.success(request, "Dataset Saved successfully.")
            return util.redirect('list_dataset')
    else:
        form = DatasetImgForm(instance=dataset)
    return util.render(request, 'dataset/create.html', {'form': form, 'dataset': dataset})

@login_required
def view(request, dataset_id):
    dataset = DatasetImgService.get(dataset_id)  # Use service to fetch the dataset
    form = DatasetImgForm(instance=dataset)  # Form for display purposes only
    return util.render(request, 'dataset/view.html', {'form': form, 'dataset': dataset})

@login_required 
def delete_confirm(request, dataset_id):
    dataset = DatasetImgService.get(dataset_id)  # Use service to fetch the dataset
    form = DatasetImgForm(instance=dataset)  # Form for display purposes only, if needed
    return util.render(request, 'dataset/delete.html', {'form': form, 'dataset': dataset})

@login_required
def delete(request, dataset_id):
    if request.method == 'POST':
        DatasetImgService.delete(dataset_id)  # Use service to delete the dataset
        messages.success(request, "Dataset Deleted successfully.")
        return util.redirect('list_dataset')
    else:
        return HttpResponse("Method Not Allowed", status=405)
