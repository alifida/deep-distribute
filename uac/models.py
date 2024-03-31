from django.db import models

# Create your models here.
class Group_config (models.Model):
    
    welcome_url = models.CharField(max_length=150, blank=True, null=True)
    group = models.ForeignKey('auth.Group', on_delete=models.CASCADE, blank=True, null=True)
    
    def __str__(self):
        return self.welcome_url 

 
    