 
from django.contrib import admin
from django.contrib.admin.options import ModelAdmin
from uac import models


 
class Group_configAdmin(ModelAdmin):
    list_display=["welcome_url", "group"  ]
    search_fields=["welcome_url", "group"]
     
admin.site.register(models.Group_config, Group_configAdmin)
