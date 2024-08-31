from django.http import HttpResponse
from django.conf import settings
from django.contrib.auth.decorators import login_required
from train.forms.forms import DatasetImgForm
from train.services.DatasetImgService import DatasetImgService
from train.services.KerasCatalogService import KerasCatalogService
from common.utils import util
from django.contrib import messages

@login_required
def list(request, dataset_id=None):
    datasets = DatasetImgService.list(request.user.id)  # Adjusted to use the service layer
    print("---------0-0-0-------------------");

    print("\nAvailable Keras layers:")
    print(KerasCatalogService.list_all_layers())

    print("\nAvailable Keras optimizers:")
    print(KerasCatalogService.list_all_optimizers())


    

    context = {
            'datasets': datasets,
            'dataset': {},
            'stats': {},
            
    }
    if len(datasets) > 0:
        if dataset_id ==None:
            dataset_id= datasets[0].id
        
         
        dataset = DatasetImgService.get(dataset_id, True)
        stats = dataset.gather_dataset_stats()
        context = {
            'datasets': datasets,
            'dataset': dataset,
            'stats': stats,
            
        }
        

    #context['models']= models.items()
    #context['strategies']= strategies



    return util.myrender(request, 'dataset_images/list.html', context)

@login_required
def create(request):
    if request.method == "POST":
        form = DatasetImgForm(request.POST, request.FILES)
        if form.is_valid():
            # Extract form data
            data_name = form.cleaned_data['data_name']
            data_path = form.cleaned_data['data_path']
            data_path_test = form.cleaned_data['data_path_test']
            #metainfo = form.cleaned_data['metainfo']
            #status = form.cleaned_data['status']
            user = request.user
            # Use service layer to create a new dataset
            DatasetImgService.create(data_name=data_name, data_path=data_path, data_path_test=data_path_test, user=user)
            messages.success(request, "Dataset Saved successfully.")
            
            return util.redirect('list_images_dataset')
    else:
        form = DatasetImgForm()
    return util.myrender(request, 'dataset_images/create.html', {'form': form})

@login_required
def edit(request, dataset_id):
    dataset = DatasetImgService.get(dataset_id)  # Use service to fetch the dataset
    if request.method == 'POST':
        form = DatasetImgForm(request.POST, request.FILES, instance=dataset)
        if form.is_valid():
            # Use service layer to update, passing cleaned form data as kwargs
            DatasetImgService.update(dataset_id, **form.cleaned_data)
            messages.success(request, "Dataset Saved successfully.")
            return util.redirect('list_images_dataset')
    else:
        form = DatasetImgForm(instance=dataset)
    return util.myrender(request, 'dataset_images/create.html', {'form': form, 'dataset': dataset})




@login_required
def view(request, dataset_id):
    dataset = DatasetImgService.get(dataset_id, True)
    stats = dataset.gather_dataset_stats()
    form = DatasetImgForm(instance=dataset)  # Form for display purposes only
    context = {
        'form': form,
        'dataset': dataset,
        'stats': stats,
    }
    return util.myrender(request, 'dataset_images/view.html', context)
 
@login_required 
def delete_confirm(request, dataset_id):
    dataset = DatasetImgService.get(dataset_id)  # Use service to fetch the dataset
    form = DatasetImgForm(instance=dataset)  # Form for display purposes only, if needed
    return util.myrender(request, 'dataset_images/delete.html', {'form': form, 'dataset': dataset})

@login_required
def delete(request, dataset_id):
    if request.method == 'POST':
        DatasetImgService.delete(dataset_id)  # Use service to delete the dataset
        messages.success(request, "Dataset Deleted successfully.")
        return util.redirect('list_images_dataset')
    else:
        return HttpResponse("Method Not Allowed", status=405)
