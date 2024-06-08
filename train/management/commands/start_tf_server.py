import tensorflow as tf
import requests
import socket
import os
from django.core.management.base import BaseCommand
from django.conf import settings

class Command(BaseCommand):
    help = 'Starts a TensorFlow server for distributed training'

    def get_cluster_config(self):
        # URL of the Django API endpoint
        url = settings.CLUSTER_DETAIL_URL
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            raise Exception(f"Failed to retrieve cluster configuration, status code {response.status_code}")
    
    

    def handle(self, *args, **options):
        # Get local IP address to match against the cluster configuration
        local_ip = socket.gethostbyname(socket.gethostname())
        print("----------------") 
        print(local_ip)
        # Get cluster configuration from Django API
        cluster_config = self.get_cluster_config()
        print("----------------")
        print(cluster_config)
        # Determine if this machine is a PS or Worker
        ps_indices = [idx for idx, addr in enumerate(cluster_config['ps']) if local_ip in addr]
        worker_indices = [idx for idx, addr in enumerate(cluster_config['worker']) if local_ip in addr]

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
        if node_type=='ps':
            for idx in ps_indices:
                self.start_server('ps', idx, cluster_config)
        elif node_type == 'worker':
            for idx in worker_indices:
                self.start_server('worker', idx, cluster_config)
        else:
            raise ValueError("Invalid NODE_TYPE specified. Use 'ps' or 'worker'.")

    def start_server(self, node_type, index, cluster_config):
        cluster_spec = tf.train.ClusterSpec({
            "worker": cluster_config['worker'],
            "ps": cluster_config['ps']
        })
        server = tf.distribute.Server(
            cluster_spec,  # Pass the ClusterSpec object directly
            job_name=node_type,
            task_index=index,
            protocol="grpc"  # Directly set the protocol to 'grpc' if it's constant
        )

        self.stdout.write(self.style.SUCCESS(f'Started {node_type} server at {cluster_spec.as_dict()[node_type][index]}'))
        server.join()




















'''
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
'''