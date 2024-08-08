# services.py
from train.dao.DatasetImgDAO import DatasetImgDAO
from common.utils import util

class DatasetImgService:
    @staticmethod
    def create(data_name, data_path, data_path_test, user):
        return DatasetImgDAO.create(data_name, data_path, data_path_test, user)

    @staticmethod
    def get(dataset_img_id,  ensureExtractedPath=False):
        dataset = DatasetImgDAO.get(dataset_img_id)
        if(ensureExtractedPath):
            if(not dataset.extracted_path or not util.path_exist(dataset.extracted_path)):
                extracted_path = util.extract_zip_to_media_dir(dataset.data_path.path, dataset.id);
                dataset.extracted_path = extracted_path
                DatasetImgService.update(dataset.id,  extracted_path=dataset.extracted_path)
            if(dataset.data_path_test):
                if(not dataset.extracted_path_test or not util.path_exist(dataset.extracted_path_test)):
                    extracted_path_test = util.extract_zip_to_media_dir(dataset.data_path_test.path, dataset.id);
                    dataset.extracted_path_test = extracted_path_test
                    DatasetImgService.update(dataset.id,  extracted_path_test=dataset.extracted_path_test)
        
         
        
        return dataset;

    @staticmethod
    def list(user_id):
        return DatasetImgDAO.list(user_id)

    @staticmethod
    def update(dataset_img_id, **kwargs):
        DatasetImgDAO.update(dataset_img_id, **kwargs)

    @staticmethod
    def delete(dataset_img_id):
        DatasetImgDAO.delete(dataset_img_id)


