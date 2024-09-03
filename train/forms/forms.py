from django import forms
from train.models import Dataset, Dataset_IMG, Training_job



class ImageUploadForm(forms.Form):
    images = forms.FileField(widget=forms.ClearableFileInput(attrs={'multiple': True}))



class DatasetForm(forms.ModelForm):
    class Meta:
        model = Dataset
        fields = ['description', 'dataset']
        widgets = {
            'description': forms.TextInput(attrs={'class': 'form-control form-control-sm border-purple'}),
            'dataset': forms.FileInput(attrs={'class': 'form-control  form-control border-purple', 'accept': '.csv, .xlsx'}),
        }
        labels = {
            'description': 'Description',
            'dataset': 'Dataset'
        }
             
        
        
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Add Bootstrap class to form fields
        #for field in self.fields.values():
        #    field.widget.attrs.update({'class': 'form-control'})

class TestDatasetForm(forms.ModelForm):
    class Meta:
        model = Dataset
        fields = ['dataset_test']
        labels = {
            'dataset_test': 'Records to predict'  # Change this label to your desired text
        }
        widgets = {
            'dataset_test': forms.FileInput(attrs={'class': 'form-control border-purple', 'accept': '.csv, .xlsx'}),
        }


class DatasetImgForm(forms.ModelForm):
    class Meta:
        model = Dataset_IMG
        fields = ['data_name', 'data_path', 'data_path_test']
        widgets = {
            'data_name': forms.TextInput(attrs={'class': 'form-control'}),
            'data_path': forms.FileInput(attrs={'class': 'form-control'}),
            'data_path_test': forms.FileInput(attrs={'class': 'form-control'}),
            #'metapurple': forms.Textarea(attrs={'class': 'form-control'}),
            #'status': forms.TextInput(attrs={'class': 'form-control'}),
        }
        labels = {
            'data_name': 'Dataset Name',
            'data_path': 'Train Dataset',
            'data_path_test': 'Test Dataset',
        }
 


class TrainingJobForm(forms.ModelForm):
    class Meta:
        model = Training_job
        fields = ['job_name', 'status', 'started_at', 'ended_at', 'algo', 'dataset_img']
        widgets = {
            'job_name': forms.TextInput(attrs={'class': 'form-control'}),
            'status': forms.TextInput(attrs={'class': 'form-control'}),
            'started_at': forms.DateTimeInput(attrs={'type': 'datetime-local', 'class': 'form-control'}, format='%Y-%m-%dT%H:%M'),
            'ended_at': forms.DateTimeInput(attrs={'type': 'datetime-local', 'class': 'form-control'}, format='%Y-%m-%dT%H:%M'),
            'algo': forms.TextInput(attrs={'class': 'form-control'}),
            'dataset_img': forms.Select(attrs={'class': 'form-control'}),
            # Assuming 'user' is handled in the view or model and thus not included in fields
        }
        exclude = ['user']  # Exclude the user field if you're handling it automatically

    def __init__(self, *args, **kwargs):
        super(TrainingJobForm, self).__init__(*args, **kwargs)
        self.fields['started_at'].input_formats = ('%Y-%m-%dT%H:%M',)
        self.fields['ended_at'].input_formats = ('%Y-%m-%dT%H:%M',)
        # Customize the queryset for dataset_img if necessary
        # self.fields['dataset_img'].queryset = Dataset_IMG.objects.filter(some_criteria=True)

    # Optional: Add custom clean methods for field validation
