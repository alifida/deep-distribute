
### Training Job Service (`train/services/TrainingJobService.py`)


from train.dao.TrainingJobDAO import TrainingJobDAO
from train.services.TrainingService import TrainingService
#from train.services.TrainingService_without_parameter_server import TrainingService
from train.services.DatasetImgService import DatasetImgService
from common.utils.util import get_unique_string, get_current_time
from train.utils.JobStatus import JobStatus
from datetime import datetime


class TrainingJobService:

    @staticmethod
    def create(dataset_id, user):


        
        dataset = DatasetImgService.get(dataset_id, True)
        
        return TrainingJobDAO.create(
            job_name=dataset.data_name +"  "+ get_unique_string(),
            dataset_img = dataset, 
            status=JobStatus.RUNNING.value,
            started_at = datetime.now(),
            ended_at=None,
            algo="ResNet",
            user=user)
        
        
         
    

        

    @staticmethod
    def get(job_id):
        return TrainingJobDAO.get(job_id)

    @staticmethod
    def update(job_id, **kwargs):
        TrainingJobDAO.update(job_id, **kwargs)


    @staticmethod
    def startTraining(dataset_id, user):
       
       # save job 
       trainingJob = TrainingJobService.create(dataset_id=dataset_id, user=user)
       
       print (trainingJob.id)
       
       # get job_id and start training
       #trainingJob = TrainingJobService.get(job_id)
       #TrainingService.start_training_thread(trainingJob)
       TrainingService.start_training(trainingJob);
        

    @staticmethod
    def delete(job_id):
        TrainingJobDAO.delete(job_id)

    @staticmethod
    def stopTraining(job_id):
        TrainingJobDAO.update(job_id, status=JobStatus.CANCEL.value)

    @staticmethod
    def list():
        return TrainingJobDAO.list()
