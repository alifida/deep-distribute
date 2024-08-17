
### Training Job Service (`train/services/TrainingJobService.py`)


from train.dao.TrainingJobDAO import TrainingJobDAO
from train.services.TrainingServicePS import TrainingServicePS
from train.services.TrainingServiceSingle import TrainingServiceSingle
#from train.services.TrainingService_without_parameter_server import TrainingService
from train.services.DatasetImgService import DatasetImgService
from common.utils.util import get_unique_string, get_current_time
from train.utils.JobStatus import JobStatus
 
from django.utils import timezone


class TrainingJobService:

    @staticmethod
    def create(dataset_id, user, algo_name):


        
        dataset = DatasetImgService.get(dataset_id, True)
        
        return TrainingJobDAO.create(
            job_name=dataset.data_name +"  "+ get_unique_string(),
            dataset_img = dataset, 
            status=JobStatus.RUNNING.value,
            started_at = timezone.now(),
            ended_at=None,
            algo=algo_name,
            user=user)
        
        
         
    

        

    @staticmethod
    def get(job_id):
        return TrainingJobDAO.get(job_id, True)

    @staticmethod
    def update(job_id, **kwargs):
        TrainingJobDAO.update(job_id, **kwargs)


    @staticmethod
    def startTraining(dataset_id, user, strategy, algo_name='ResNet50'):
       
       # save job 
       trainingJob = TrainingJobService.create(dataset_id=dataset_id, user=user, algo_name=algo_name)
       
       print (trainingJob.id)
       
       # get job_id and start training
       #trainingJob = TrainingJobService.get(job_id)
       #TrainingService.start_training_process(trainingJob.id)
       if strategy == 1 or strategy=='Single GPU':
            TrainingServiceSingle.start_training_process(trainingJob, algo_name)
       elif strategy == 2 or  strategy=='GPU Cluster Parameter Server':
            TrainingServicePS.start_training(trainingJob, algo_name)
       elif strategy == 3 or  strategy=='GPU Cluster Custom':
            #TrainingServiceCustom.start_training(trainingJob, model)
            pass
       else:
            # Handle any other cases if needed
            pass  # or do something else
        

    @staticmethod
    def delete(job_id):
        TrainingJobDAO.delete(job_id)

    @staticmethod
    def stopTraining(job_id):
        TrainingJobDAO.update(job_id, status=JobStatus.CANCEL.value)

    @staticmethod
    def list():
        return TrainingJobDAO.list()
    
    @staticmethod
    def list_by_dataset(dataset_id):
        return TrainingJobDAO.list_by_dataset(dataset_id=dataset_id)
