# train/services/ClusterNodeService.py

from train.dao.ClusterNodeDAO import ClusterNodeDAO

class ClusterNodeService:
    @staticmethod
    def create(node_type, ip_address, port):
        return ClusterNodeDAO.create(node_type=node_type, ip_address=ip_address, port=port)

    @staticmethod
    def get(node_id):
        return ClusterNodeDAO.get(node_id)

    @staticmethod
    def update(node_id, **kwargs):
        ClusterNodeDAO.update(node_id, **kwargs)

    @staticmethod
    def delete(node_id):
        ClusterNodeDAO.delete(node_id)

    @staticmethod
    def list():
        return ClusterNodeDAO.list()
