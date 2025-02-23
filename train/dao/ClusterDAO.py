from train.models import Cluster

class ClusterDAO:
    @staticmethod
    def create(name, status):
        return Cluster.objects.create(name=name, status=status)

    @staticmethod
    def get(cluster_id):
        return Cluster.objects.get(id=cluster_id)

    @staticmethod
    def update(cluster_id, **kwargs):
        Cluster.objects.filter(id=cluster_id).update(**kwargs)

    @staticmethod
    def delete(cluster_id):
        cluster = Cluster.objects.get(id=cluster_id)
        cluster.delete()

    @staticmethod
    def list():
        return Cluster.objects.all()
