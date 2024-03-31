# services.py
from train.dao.DatasetImgDAO import DatasetImgDAO
from common.utils import util

class DatasetImgService:
    @staticmethod
    def create(data_name, data_path, metainfo, status, user):
        return DatasetImgDAO.create(data_name, data_path, metainfo, status, user)

    @staticmethod
    def get(dataset_img_id,  ensureExtractedPath=False):
        dataset = DatasetImgDAO.get(dataset_img_id)
        if(ensureExtractedPath):
            if(not dataset.extracted_path or not util.path_exist(dataset.extracted_path)):
                extracted_path = util.extract_zip_to_temp(dataset.data_path.path);
                dataset.extracted_path = extracted_path
                DatasetImgService.update(dataset.id,  extracted_path=dataset.extracted_path)
        return dataset;

    @staticmethod
    def list():
        return DatasetImgDAO.list()

    @staticmethod
    def update(dataset_img_id, **kwargs):
        DatasetImgDAO.update(dataset_img_id, **kwargs)

    @staticmethod
    def delete(dataset_img_id):
        DatasetImgDAO.delete(dataset_img_id)


