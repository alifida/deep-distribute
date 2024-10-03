from train.models import Training_job

class TrainingJobDAO:


    @staticmethod
    def create(job_name, dataset_img, status,started_at,ended_at,algo, user, parameter_settings):
        return Training_job.objects.create(
            job_name = job_name,
            dataset_img = dataset_img,
            status = status,
            started_at = started_at,
            ended_at = ended_at,
            algo = algo,
            user = user,
            parameter_settings= parameter_settings
        )

    @staticmethod
    def get(job_id):
         
         
        print('TrainingJOBDAO get '+str(job_id) )
        print("******************************")
        print("******************************")
        return Training_job.objects.get(id=job_id)

    @staticmethod
    def update(job_id, **kwargs):
        print('updating training job '+str(job_id) )
        print(kwargs)
        print("====================================")
        print("====================================")
        print("====================================")
        Training_job.objects.filter(id=job_id).update(**kwargs)


    @staticmethod
    def getSingleByDataset(datasetId):
        jobs = Training_job.objects.filter(dataset_img_id=datasetId).exclude(status="COMPLETED")
        if jobs.exists():
            return jobs.first()  # Returns the first job in the queryset
        return None
    
    @staticmethod
    def getSingleByDatasetAndStatus(datasetId, status):
        jobs = Training_job.objects.filter(dataset_img_id=datasetId, status=status)
        if jobs.exists():
            return jobs.first()  # Returns the first job in the queryset
        return None


    @staticmethod
    def delete(job_id):
        job = Training_job.objects.get(id=job_id)
        job.delete()

    @staticmethod
    def list():
        return Training_job.objects.all()

    @staticmethod
    def list_by_dataset(dataset_id):
        return Training_job.objects.filter(dataset_img_id=dataset_id)

    @staticmethod
    def delete_by_dataset_img_id(dataset_img_id):
        try:
            Training_job.objects.filter(
                dataset_img_id=dataset_img_id
            ).delete()
 
            print(f"Training_job with dataset_img_id: {dataset_img_id} has been deleted.")
        except Training_job.DoesNotExist:
            print(f"No Training_job found with dataset_img_id: {dataset_img_id}")
    
    