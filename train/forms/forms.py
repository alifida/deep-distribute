from django import forms
from train.models import Dataset_IMG, Training_job



class ImageUploadForm(forms.Form):
    images = forms.FileField(widget=forms.ClearableFileInput(attrs={'multiple': True}))




class DatasetImgForm(forms.ModelForm):
    class Meta:
        model = Dataset_IMG
        fields = ['data_name', 'data_path', 'metainfo', 'status']
        widgets = {
            'data_name': forms.TextInput(attrs={'class': 'form-control'}),
            'data_path': forms.FileInput(attrs={'class': 'form-control'}),
            'metainfo': forms.Textarea(attrs={'class': 'form-control'}),
            'status': forms.TextInput(attrs={'class': 'form-control'}),
        }
'''
class TrainingJobForm(forms.ModelForm):
    # Optional: Add custom validation, widgets, or fields if needed

    class Meta:
        model = Training_job
        fields = ['job_name', 'status', 'started_at', 'ended_at', 'algo', 'dataset_img', 'user']
        widgets = {
            'started_at': forms.DateTimeInput(attrs={'type': 'datetime-local'}, format='%Y-%m-%dT%H:%M'),
            'ended_at': forms.DateTimeInput(attrs={'type': 'datetime-local'}, format='%Y-%m-%dT%H:%M'),
            # If you want the user field to be auto-filled or hidden, you might not include it in the form or handle it differently
        }
        exclude = ['user']  # Exclude the user field if you're handling it automatically

    def __init__(self, *args, **kwargs):
        super(TrainingJobForm, self).__init__(*args, **kwargs)
        self.fields['started_at'].input_formats = ('%Y-%m-%dT%H:%M',)
        self.fields['ended_at'].input_formats = ('%Y-%m-%dT%H:%M',)

        # Example to set initial values or querysets for ForeignKey fields
        # self.fields['dataset_img'].queryset = Dataset_IMG.objects.filter(some_criteria=True)
'''        



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
