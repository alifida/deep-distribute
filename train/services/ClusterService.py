from train.dao.ClusterDAO import ClusterDAO

class ClusterService:
    @staticmethod
    def create(name, status):
        return ClusterDAO.create(name=name, status=status)

    @staticmethod
    def get(cluster_id):
        return ClusterDAO.get(cluster_id)

    @staticmethod
    def update(cluster_id, **kwargs):
        ClusterDAO.update(cluster_id, **kwargs)

    @staticmethod
    def delete(cluster_id):
        ClusterDAO.delete(cluster_id)

    @staticmethod
    def list():
        return ClusterDAO.list()
