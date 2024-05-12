import tensorflow as tf
from django.core.management.base import BaseCommand
import os

class Command(BaseCommand):
    help = 'Starts a TensorFlow server for distributed training'

    
    def handle(self, *args, **options):

        # Configure TensorFlow GPU memory growth
        gpus = tf.config.experimental.list_physical_devices('GPU')
        if gpus:
            try:
                for gpu in gpus:
                    tf.config.experimental.set_memory_growth(gpu, True)
            except RuntimeError as e:
                print(f"Error setting memory growth: {e}")
                return

        node_type = os.getenv('NODE_TYPE', 'worker')
        index = int(os.getenv('NODE_INDEX', '0'))

        self.stdout.write(self.style.SUCCESS(f'Node type: {node_type}, Index: {index}'))

        cluster_spec = {
            "worker": ["192.168.100.109:2222"],
            "ps": ["192.168.100.109:2223"]
        }
        cluster_resolver = tf.distribute.cluster_resolver.SimpleClusterResolver(
            cluster_spec=tf.train.ClusterSpec(cluster_spec),
            rpc_layer="grpc"
        )

        server = tf.distribute.Server(
            cluster_resolver.cluster_spec(),
            job_name=node_type,
            task_index=index,
            protocol=cluster_resolver.rpc_layer
        )

        self.stdout.write(self.style.SUCCESS(f'Started {node_type} server at {cluster_spec[node_type][index]}'))
        server.join()
