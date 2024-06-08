from django.urls import path
from .controllers import  HomeController
#from .controllers.DatasetController import create, save, list, delete
from .controllers import DatasetController, TrainingController,ClusterNodeController, ApiController
from django.views.generic.base import RedirectView
from .views import welcome
 

urlpatterns = [
    path('deep/dataset/list', DatasetController.list, name="list_dataset"),
    path('deep/dataset/new/', DatasetController.create, name='create_dataset'),
   # path('train/dataset/save/', DatasetController.save, name="save_dataset"),
    path('deep/dataset/delete/<int:dataset_id>/', DatasetController.delete, name="delete_dataset"),
    path('deep/dataset/delete_confirm/<int:dataset_id>/', DatasetController.delete_confirm, name="delete_dataset_confirm"),
    
    path('deep/dataset/edit/<int:dataset_id>/', DatasetController.edit, name='edit_dataset'),
    path('deep/dataset/view/<int:dataset_id>/', DatasetController.view, name='view_dataset'),
    
    

    path('deep/jobs/', TrainingController.list, name='training_job_list'),
    path('deep/jobs/create/', TrainingController.edit, name='training_job_create'),
    path('deep/jobs/edit/<int:job_id>/', TrainingController.edit, name='training_job_update'),
    path('deep/jobs/start/<int:dataset_id>/', TrainingController.start_training, name='start_training'),
    path('deep/jobs/stop/<int:job_id>/', TrainingController.stop_training, name='stop_training'),
    
    #path('deep/jobs/delete_confirm/<int:dataset_id>/', TrainingController.delete_confirm, name="training_job_delete_confirm"),
    path('deep/jobs/delete/<int:job_id>/', TrainingController.delete, name='training_job_delete'),


    
    path('home', HomeController.home, name='home'),
    path('', RedirectView.as_view(url = "home")), 
    path('dashboard', HomeController.home, name='home'),
    path('dashboard/', HomeController.home, name='home'),
    path('welcome/', welcome, name='welcome'),
    
]



urlpatterns += [
    path('deep/cluster/list', ClusterNodeController.list, name="list_cluster_nodes"),
    path('deep/cluster/create/', ClusterNodeController.create, name='create_cluster_node'),
    path('deep/cluster/view/<int:node_id>/', ClusterNodeController.view, name='view_cluster_node'),
    path('deep/cluster/edit/<int:node_id>/', ClusterNodeController.edit, name='edit_cluster_node'),
    path('deep/cluster/delete_confirm/<int:node_id>/', ClusterNodeController.delete_confirm, name='delete_cluster_node_confirm'),
    path('deep/cluster/delete/<int:node_id>/', ClusterNodeController.delete, name="delete_cluster_node"),
    path('api/cluster/detail', ApiController.cluster_nodes_json, name='cluster_nodes_json'),
    
]
