
from django.db import models
from django.core.validators import FileExtensionValidator
from django.conf import settings
import json

# Create your models here.

class Dataset_IMG (models.Model):
    data_name = models.CharField(max_length=300)
    data_path = models.FileField(max_length=300)
    extracted_path = models.TextField(blank=True)
    metainfo = models.TextField(blank=True)
    processed_at = models.DateTimeField(auto_now_add=True)
    delete_at = models.DateTimeField(null=True)
    status=models.CharField(max_length=300)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.RESTRICT)
    
    def __str__(self):
        return self.data_name 




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