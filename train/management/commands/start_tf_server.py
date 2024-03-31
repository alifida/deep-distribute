import tensorflow as tf
from django.core.management.base import BaseCommand
import os
class Command(BaseCommand):
    help = 'Starts a TensorFlow server for distributed training'

    def handle(self, *args, **options):
        # Read node type and index from environment variables
        node_type = os.getenv('NODE_TYPE', 'worker')  # Default to 'worker' if not set
        index = int(os.getenv('NODE_INDEX', '0'))  # Default to 0 if not set

        # Define the cluster specification
        cluster_spec_dict = {
            "worker": ["localhost:2222"],
            "ps": ["ps0.example.com:2222", "ps1.example.com:2222"]
        }
        cluster_spec = tf.train.ClusterSpec(cluster_spec_dict)

        # Create a cluster resolver
        cluster_resolver = tf.distribute.cluster_resolver.SimpleClusterResolver(
            cluster_spec=cluster_spec,
            rpc_layer="grpc"
        )

        # Create and start a server
        server = tf.distribute.Server(
            cluster_resolver.cluster_spec(),
            job_name=node_type,
            task_index=index,
            protocol=cluster_resolver.rpc_layer
        )

        if node_type == "ps":
            self.stdout.write(self.style.SUCCESS('Starting parameter server...'))
            server.join()
        else:
            self.stdout.write(self.style.SUCCESS(f'Starting {node_type} node...'))

        # The worker node will continue with other processes, while PS joins indefinitely
