
from django.contrib import admin
from train import models
from django.contrib.admin.options import ModelAdmin
# Register your models here.
class Dataset_IMGAdmin(ModelAdmin):

    list_display=["status", "data_name", "user"]
    search_fields=["status", "data_name", "user"]
    list_filter=["status", "data_name", "user"]


 
admin.site.register(models.Dataset_IMG)
 