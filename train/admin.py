
from django.contrib import admin
from train import models
from django.contrib.admin.options import ModelAdmin
# Register your models here.
class Dataset_IMGAdmin(ModelAdmin):

    list_display=["status", "data_name", "user"]
    search_fields=["status", "data_name", "user"]
    list_filter=["status", "data_name", "user"]

class Training_jobAdmin (ModelAdmin):

    list_display=["job_name", "dataset_img.data_name", "status", "algo", "user"]
    search_fields=["job_name", "dataset_img.data_name", "status", "algo", "user"]
    list_filter=["job_name", "dataset_img.data_name", "status", "algo", "user"]
 
 
admin.site.register(models.Dataset_IMG)
admin.site.register(models.Training_job)
 