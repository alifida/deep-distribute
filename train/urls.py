from django.urls import path
from .controllers import  api_controller, cluster_node_controller, dataset_csv_controller, dataset_images_controller, home_controller, training_controller
#from .controllers.DatasetController import create, save, list, delete
from .controllers import deployment_controller
from django.views.generic.base import RedirectView
from .views import welcome
 

     
urlpatterns = [
    path('', RedirectView.as_view(url="home", permanent=True)),
    path('welcome', welcome, name='welcome_'),
    path('welcome/', welcome, name='welcome'),
]


#Dataset Controller (Deals with CSV Dataset)
urlpatterns += [
    path('dataset/csv/list/', dataset_csv_controller.list_dataset, name='list_csv_dataset'),
    path('dataset/csv/save/', dataset_csv_controller.save_dataset, name='save_csv_dataset'),
    path('dataset/csv/delete/<int:pk>/', dataset_csv_controller.delete_dataset, name='delete_csv_dataset'),
    path('dataset/csv/preview/<int:pk>/', dataset_csv_controller.preview_dataset, name='preview_csv_dataset'),
    path('dataset/csv/algos/defaults', dataset_csv_controller.get_algos_defaults, name='csv_dataset_algos_defaults'),
    path('dataset/predict/', dataset_csv_controller.predict_dataset, name='predict_csv_dataset'),
    
]




#Dataset Controller (Deals on Images Dataset)
urlpatterns += [
    path('dataset/images/list', dataset_images_controller.list, name="list_images_dataset"),
    path('dataset/images/list/<int:dataset_id>/', dataset_images_controller.list, name="list_images_dataset_with_id"),
    path('dataset/images/new/', dataset_images_controller.create, name='save_images_dataset'),
    path('dataset/images/delete/<int:dataset_id>/', dataset_images_controller.delete, name="delete_images_dataset"),
    path('dataset/images/delete_confirm/<int:dataset_id>/', dataset_images_controller.delete_confirm, name="delete_images_dataset_confirm"),
    path('dataset/images/edit/<int:dataset_id>/', dataset_images_controller.edit, name='edit_images_dataset'),
    path('dataset/images/view/<int:dataset_id>/', dataset_images_controller.view, name='view_images_dataset'),
]

#TrainingController
urlpatterns += [
    path('training/jobs/', training_controller.list, name='training_job_list'),
    path('training/jobs/create/', training_controller.edit, name='training_job_create'),
    path('training/jobs/edit/<int:job_id>/', training_controller.edit, name='training_job_update'),
    path('training/jobs/start/', training_controller.start_training_post, name='start_training_post'),
    path('training/job/training/<int:dataset_id>/', training_controller.training, name="start_training"),
    path('training/jobs/stop/<int:job_id>/', training_controller.stop_training, name='stop_training'),

    #path('deep/jobs/delete_confirm/<int:dataset_id>/', TrainingController.delete_confirm, name="training_job_delete_confirm"),
    path('deep/jobs/delete/<int:job_id>/', training_controller.delete, name='training_job_delete'),

]

#DeploymentController
urlpatterns += [
    path('home', deployment_controller.index, name='model_welcome'),
    path('home', deployment_controller.index, name='home'),

    path('home/', deployment_controller.index, name='home_'),
    path('model/list/all-datasets/', deployment_controller.list_all_datasets, name='list_all_datasets'),

    path('model/deploy/model/<int:trained_model_id>', deployment_controller.deploy_trained_model, name='deploy_model_url'),
    path('model/deployed/', deployment_controller.list_deployed_models, name='list_deployed_models'),
    path('model/deployed/<int:pk>', deployment_controller.get_model_by_id, name='load_model_by_id'),
    path('model/deployed/predict', deployment_controller.predict_trained_model, name='predict_trained_model'),
    path('model/deployed/csv/template/<int:pk>', deployment_controller.download_csv_template, name='download_csv_template'),
    path('model/deployed/delete/<int:pk>', deployment_controller.delete_model, name='delete_model_by_id'),
]

   

#ClusterNodeController
urlpatterns += [
    path('cluster/list', cluster_node_controller.list, name="list_cluster_nodes"),
    path('cluster/create/', cluster_node_controller.create, name='create_cluster_node'),
    path('cluster/view/<int:node_id>/', cluster_node_controller.view, name='view_cluster_node'),
    path('cluster/edit/<int:node_id>/', cluster_node_controller.edit, name='edit_cluster_node'),
    path('cluster/delete_confirm/<int:node_id>/', cluster_node_controller.delete_confirm, name='delete_cluster_node_confirm'),
    path('cluster/delete/<int:node_id>/', cluster_node_controller.delete, name="delete_cluster_node"),
    path('api/cluster/detail', api_controller.cluster_nodes_json, name='cluster_nodes_json'),
]
    
