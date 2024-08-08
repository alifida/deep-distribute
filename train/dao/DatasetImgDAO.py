
from train.models import Dataset_IMG

class DatasetImgDAO:
    @staticmethod
    def create(data_name, data_path, data_path_test, user):
        return Dataset_IMG.objects.create(
            data_name=data_name,
            data_path=data_path,
            data_path_test = data_path_test,
            
            user=user
        )

    @staticmethod
    def get(dataset_img_id):
        print(dataset_img_id)
        
        return Dataset_IMG.objects.get(id=dataset_img_id)

    @staticmethod
    def update(dataset_img_id, **kwargs):
        Dataset_IMG.objects.filter(id=dataset_img_id).update(**kwargs)

    @staticmethod
    def delete(dataset_img_id):
        dataset_img = Dataset_IMG.objects.get(id=dataset_img_id)
        dataset_img.delete()
    
    @staticmethod
    def list(user_id):
        return Dataset_IMG.objects.filter(user_id = user_id);
