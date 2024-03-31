 
from django.urls import path
from django.urls.conf import include
from uac import views

urlpatterns = [
    path('accounts/', include('registration.backends.default.urls')),


    path('welcome', views.welcome, name='welcome'),
    path('welcome/', views.welcome, name='welcome'),
    
   

]
