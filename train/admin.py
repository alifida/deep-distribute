from django.contrib import admin
from train import models
from django.contrib.admin.options import ModelAdmin

# Admin class for Dataset_IMG
class Dataset_IMGAdmin(ModelAdmin):
    list_display = ["status", "data_name", "user"]
    search_fields = ["status", "data_name", "user"]
    list_filter = ["status", "data_name", "user"]

# Admin class for Training_job
class Training_jobAdmin(ModelAdmin):
    list_display = ["job_name", "get_data_name", "status", "algo", "user"]
    search_fields = ["job_name", "get_data_name", "status", "algo", "user"]
    list_filter = ["status", "algo", "dataset_img__data_name"]  # Use double underscore for related field

    # Custom method to fetch the data_name from the related dataset_img
    def get_data_name(self, obj):
        return obj.dataset_img.data_name if obj.dataset_img else None
    get_data_name.admin_order_field = 'dataset_img__data_name'  # Allow sorting by data_name
    get_data_name.short_description = 'Data Name'  # Label in the admin interface

# Admin class for Cluster
class ClusterAdmin(ModelAdmin):
    list_display = ["name", "status"]
    search_fields = ["name", "status"]
    list_filter = ["name", "status"]



# Admin class for ClusterNode
class ClusterNodeAdmin(ModelAdmin):
    list_display = ["node_type", "cluster", "ip_address", "port"]
    search_fields = ["node_type", "ip_address", "port"]
    list_filter = ["node_type", "cluster"]  # Filters by node type and cluster



# Register the models with their respective admin classes
admin.site.register(models.Dataset_IMG, Dataset_IMGAdmin)
admin.site.register(models.Training_job, Training_jobAdmin)
admin.site.register(models.Cluster, ClusterAdmin)

admin.site.register(models.ClusterNode, ClusterNodeAdmin)