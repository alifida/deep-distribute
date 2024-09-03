from train.models import Dataset

class DatasetCSVDAO:
    @staticmethod
    def create(description, dataset, user, dataset_test=None, source_dataset_id=None, process_details="", metainfo=""):
        return Dataset.objects.create(
            description=description,
            dataset=dataset,
            dataset_test=dataset_test,
            source_dataset_id=source_dataset_id,
            process_details=process_details,
            metainfo=metainfo,
            user=user
        )

    @staticmethod
    def get(dataset_id):
        print(dataset_id)
        return Dataset.objects.get(id=dataset_id)

    @staticmethod
    def update(dataset_id, **kwargs):
        Dataset.objects.filter(id=dataset_id).update(**kwargs)

    @staticmethod
    def delete(dataset_id):
        dataset = Dataset.objects.get(id=dataset_id)
        dataset.delete()

    @staticmethod
    def list(user_id):
        return Dataset.objects.filter(user_id=user_id)
    
    @staticmethod
    def list_by_user(user_id):
        return Dataset.objects.filter(user_id=user_id)
