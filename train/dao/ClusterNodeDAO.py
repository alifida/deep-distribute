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
    def get_by_cluster_node_type(cluster_id, node_type):
        try:
            # Fetch the ClusterNodes by cluster_id and node_type
            nodes = ClusterNode.objects.filter(cluster_id=cluster_id, node_type=node_type)
            
            # Return the nodes if they exist, otherwise return None
            if nodes.exists():
                return nodes
            return None
        except Exception as e:
            # You can log the exception if necessary or handle other exceptions
            print(f"An error occurred: {e}")
            return None

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
