from train.models import Training_job

class TrainingJobDAO:


    @staticmethod
    def create(job_name, dataset_img, status,started_at,ended_at,algo, user):
        return Training_job.objects.create(
            job_name = job_name,
            dataset_img = dataset_img,
            status = status,
            started_at = started_at,
            ended_at = ended_at,
            algo = algo,
            user = user
        )

    @staticmethod
    def get(job_id):
        return Training_job.objects.get(id=job_id)

    @staticmethod
    def update(job_id, **kwargs):
        Training_job.objects.filter(id=job_id).update(**kwargs)

    @staticmethod
    def delete(job_id):
        job = Training_job.objects.get(id=job_id)
        job.delete()

    @staticmethod
    def list():
        return Training_job.objects.all()
