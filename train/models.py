
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
                'total_classes': 0,
                'class_names': [],
                'classwise_details': [],
                'overall_total_examples': 0,
                'image_size': ''
            }
        
        class_directories = next(os.walk(self.extracted_path))[1]
        total_classes = len(class_directories)
        class_names = class_directories
        classwise_details = []

        overall_total_examples = 0
        image_size = None

        for class_dir in class_directories:
            class_path = os.path.join(self.extracted_path, class_dir)
            if os.path.isdir(class_path):
                image_files = os.listdir(class_path)
                if image_size is None:
                    image_size = self.get_image_resolutions(image_files, class_path)
                
                num_examples = len([f for f in image_files if os.path.isfile(os.path.join(class_path, f))])
                
                # Get preview images URLs
                preview_images = self.get_preview_images(self.id, class_dir)
                
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
    
    def get_preview_images(self, zip_id, class_name, num_images=5):
            # Construct the base URL for media files
            base_url = settings.MEDIA_URL
            
            # Construct the directory path where images are extracted
            extracted_path = os.path.join(settings.MEDIA_ROOT, str(zip_id), class_name)
            
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
                image_url = base_url + str(zip_id) + '/' + class_name + '/' + image_file
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