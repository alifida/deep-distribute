# train/dao/ClusterNodeDAO.py

from train.models import ClusterNode

class ClusterNodeDAO:
    @staticmethod
    def create(node_type, ip_address, port):
        return ClusterNode.objects.create(node_type=node_type, ip_address=ip_address, port=port)

    @staticmethod
    def get(node_id):
        return ClusterNode.objects.get(id=node_id)

    @staticmethod
    def update(node_id, **kwargs):
        ClusterNode.objects.filter(id=node_id).update(**kwargs)

    @staticmethod
    def delete(node_id):
        node = ClusterNode.objects.get(id=node_id)
        node.delete()

    @staticmethod
    def list():
        return ClusterNode.objects.all()
