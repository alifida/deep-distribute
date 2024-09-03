from train.dao.DatasetCSVDAO import DatasetCSVDAO

class DatasetService:
    @staticmethod
    def create_dataset(description, dataset, dataset_test, user, source_dataset_id=None):
        return DatasetCSVDAO.create(
            description=description,
            dataset=dataset,
            dataset_test=dataset_test,
            user=user,
            source_dataset_id=source_dataset_id
        )

    @staticmethod
    def get_dataset(dataset_id):
        return DatasetCSVDAO.get(dataset_id)

    @staticmethod
    def update_dataset(dataset_id, **kwargs):
        DatasetCSVDAO.update(dataset_id, **kwargs)

    @staticmethod
    def delete_dataset(dataset_id):
        DatasetCSVDAO.delete(dataset_id)

    @staticmethod
    def list_datasets(user_id):
        return DatasetCSVDAO.list(user_id)
    @staticmethod
    def list_datasets_by_user(user_id):
        return DatasetCSVDAO.list_by_user(user_id)