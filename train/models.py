
from django.db import models
from django.core.validators import FileExtensionValidator
from django.conf import settings
import json
import os
from PIL import Image
# Create your models here.

class Dataset_IMG(models.Model):
    data_name = models.CharField(max_length=300)
    data_path = models.FileField(max_length=300)
    extracted_path = models.TextField(blank=True)
    data_path_test = models.FileField(max_length=300, blank=True)
    extracted_path_test = models.TextField(blank=True)
    metainfo = models.TextField(blank=True)
    processed_at = models.DateTimeField(auto_now_add=True)
    delete_at = models.DateTimeField(null=True)
    status = models.CharField(max_length=300)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.RESTRICT)

    def __str__(self):
        return self.data_name 

    def gather_dataset_stats(self):
        if not self.extracted_path or not os.path.exists(self.extracted_path):
            return {
                    'train':
                            {
                                'total_classes': 0,
                                'class_names': [],
                                'classwise_details': [],
                                'overall_total_examples': 0,
                                'image_size': ''
                            },
                    'test':
                            {
                                'total_classes': 0,
                                'class_names': [],
                                'classwise_details': [],
                                'overall_total_examples': 0,
                                'image_size': ''
                            }
                    }
        
        train = self.get_dataset_details(self.extracted_path, 'train')
        test = {
                    'total_classes': 0,
                    'class_names': [],
                    'classwise_details': [],
                    'overall_total_examples': 0,
                    'image_size': ''
                }
        if self.extracted_path_test or not os.path.exists(self.extracted_path_test):
            test = self.get_dataset_details(self.extracted_path_test, 'test')

        return {
            'train': train,
            'test': test
        }            
    

    def get_dataset_details(self, extracted_path, ds_type):
        class_directories = next(os.walk(extracted_path))[1]
        total_classes = len(class_directories)
        class_names = class_directories
        classwise_details = []

        overall_total_examples = 0
        image_size = None

        for class_dir in class_directories:
            class_path = os.path.join(extracted_path, class_dir)
            if os.path.isdir(class_path):
                image_files = os.listdir(class_path)
                if image_size is None:
                    image_size = self.get_image_resolutions(image_files, class_path)
                
                num_examples = len([f for f in image_files if os.path.isfile(os.path.join(class_path, f))])
                
                # Get preview images URLs
                dataseturl = os.path.join(str(self.id), ds_type)
                preview_images = self.get_preview_images(dataseturl, class_dir)
                
                # Append class-wise details
                classwise_details.append({
                    'class_name': class_dir,
                    'total_examples': num_examples,
                    'preview_images': preview_images
                })

                overall_total_examples += num_examples

        return {
            'total_classes': total_classes,
            'class_names': class_names,
            'classwise_details': classwise_details,
            'overall_total_examples': overall_total_examples,
            'image_size': image_size
        }


    

    def get_preview_images(self, dir_path, class_name, num_images=5):
            # Construct the base URL for media files
            base_url = settings.MEDIA_URL + settings.TMP_DIR
            print("*************************************")
            print("*************************************")
            print(base_url)
            print("*************************************")
            print("*************************************")
            # Construct the directory path where images are extracted
            extracted_path = os.path.join(settings.MEDIA_ROOT , settings.TMP_DIR, str(dir_path), class_name)
            
            # Check if the directory exists
            if not os.path.isdir(extracted_path):
                return []
            
            # Get a list of image files in the directory
            image_files = os.listdir(extracted_path)
            
            # Prepare a list to store image URLs
            preview_images = []
            
            # Iterate through the list of image files and construct URLs
            for i in range(min(num_images, len(image_files))):
                image_file = image_files[i]
                # Construct the full URL for each image file
                image_url = base_url + str(dir_path) + '/' + class_name + '/' + image_file
                preview_images.append(image_url)
            
            return preview_images

    def get_image_resolutions(self, image_files, class_path):
         
        if image_files:
            first_image_path = os.path.join(class_path, image_files[0])
            try:
                img = Image.open(first_image_path)
                return img.size  # Returns width, height tuple
            except Exception as e:
                print(f"Error opening image {first_image_path}: {e}")
                return None
        pass



class Training_job (models.Model):
    job_name = models.CharField(max_length=300)
    dataset_img = models.ForeignKey(Dataset_IMG, on_delete=models.RESTRICT, related_name='training_jobs')
    status = models.CharField(max_length=300)
    started_at = models.DateTimeField(null=True)
    ended_at = models.DateTimeField(null=True)
    algo = models.CharField(max_length=300);
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.RESTRICT)
    parameter_settings = models.TextField(null=True)
    result = models.TextField(null=True)  # TextField to store metrics
    
    def __str__(self):
        return self.job_name 

    def set_result(self, result_dict):
        self.result = json.dumps(result_dict)

    def get_result(self):
        return json.loads(self.result) if self.result else None

class ClusterNode(models.Model):
    NODE_CHOICES = (
        ('worker', 'Worker'),
        ('ps', 'Parameter Server')
    )
    node_type = models.CharField(max_length=10, choices=NODE_CHOICES)
    ip_address = models.CharField(max_length=15)
    port = models.IntegerField()

    def __str__(self):
        return f"{self.node_type} - {self.ip_address}:{self.port}"
    


class Dataset (models.Model):
    description = models.CharField(max_length=300)
    dataset = models.FileField(upload_to='datasets/', validators=[FileExtensionValidator(allowed_extensions=['csv','xls','xlsx'])])
    dataset_test = models.FileField(upload_to='datasets/', validators=[FileExtensionValidator(allowed_extensions=['csv','xls','xlsx'])], blank = True, null=True)
    source_dataset_id = models.ForeignKey( 'self', on_delete=models.CASCADE, related_name="source_id", blank = True, null=True)
    process_details = models.TextField(blank = True)
    processed_at = models.DateTimeField(auto_now_add=True)
    metainfo = models.TextField(blank=True)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    
    
    
    def __str__(self):
        return self.description 
    
    def delete(self, *args, **kwargs):
        # Delete related trained models
        self.trained_models.all().delete()
        if self.dataset:
            if os.path.isfile(self.dataset.path):
                os.remove(self.dataset.path)
        # Call the parent class's delete method
        super().delete(*args, **kwargs)


class TrainedModel(models.Model):
    # The file field for storing the trained model file
    model_file = models.FileField(upload_to='trained_models/', blank=True, null=True)
    
    # Fields for additional details
    description = models.CharField(max_length=300, blank=True, null=True)
    status = models.CharField(max_length=100, choices=[('Temp', 'Temp'), ('Deployed', 'Deployed')], default='Temp')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    dataset = models.ForeignKey('Dataset', on_delete=models.CASCADE, related_name='trained_models')
    key_attributes = models.CharField(max_length=300, blank=True, null=True)
    class_label = models.TextField(blank=True)
    def __str__(self):
        return f"Model: {self.description or 'No description'} - Status: {self.status}"

    def delete(self, *args, **kwargs):
        # Delete the model file from the filesystem when the model instance is deleted
        if self.model_file:
            if os.path.isfile(self.model_file.path):
                os.remove(self.model_file.path)
        super().delete(*args, **kwargs)

class ChartType(models.Model):
    name = models.CharField(max_length=50, blank=True, null=True)
    type = models.CharField(max_length=50)
    status = models.CharField(max_length=20, blank=True, null=True)
    template = models.TextField()
    def __str__(self):
        if self.name==None:
            self.name=""
        return self.name +" ("+self.type+")" 
    
class Chart(models.Model):
    name = models.CharField(max_length=1000)
    type = models.ForeignKey('train.ChartType', on_delete=models.CASCADE, blank=True, null=True)
#    type = models.CharField(max_length=50)
    dataset = models.ForeignKey('train.Dataset', on_delete=models.CASCADE, blank=True, null=True)
    dataset_attribute = models.CharField(max_length=1000 , blank=True, null=True)
    data = models.TextField()
    def __str__(self):
        return self.name 
      