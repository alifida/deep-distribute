import os
import json
import requests
import socket

from django.core.management.base import BaseCommand
from django.conf import settings


class Command(BaseCommand):
    help = 'Starts a TensorFlow server for distributed training'

    def get_cluster_config(self):
        url = settings.CLUSTER_DETAIL_URL
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            raise Exception(f"Failed to retrieve cluster configuration, status code {response.status_code}")

    def get_local_ip(self):
        try:
            # More reliable way to detect IP in distributed setup
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(('8.8.8.8', 80))
            ip = s.getsockname()[0]
            s.close()
            return ip
        except Exception:
            return socket.gethostbyname(socket.gethostname())

    def handle(self, *args, **options):
        local_ip = self.get_local_ip()
        print("----------------")
        print(f"Local IP: {local_ip}")

        cluster_config = self.get_cluster_config()
        print("----------------")
        print("Cluster config:", cluster_config)

        node_type = os.getenv('NODE_TYPE', 'worker')
        all_workers = cluster_config.get('worker', [])
        all_ps = cluster_config.get('ps', [])

        matched_indices = []
        if node_type == 'worker':
            matched_indices = [i for i, addr in enumerate(all_workers) if local_ip in addr]
        elif node_type == 'ps':
            matched_indices = [i for i, addr in enumerate(all_ps) if local_ip in addr]
        else:
            raise ValueError("Invalid NODE_TYPE specified. Use 'ps' or 'worker'.")

        if not matched_indices:
            raise ValueError(f"Could not match local IP {local_ip} with any node in cluster config for type '{node_type}'.")

        index = matched_indices[0]

        # Set TF_CONFIG
        tf_config = {
            "cluster": {
                "worker": all_workers,
                "ps": all_ps
            },
            "task": {
                "type": node_type,
                "index": index
            }
        }

        os.environ["TF_CONFIG"] = json.dumps(tf_config)
        print(f"TF_CONFIG set:\n{json.dumps(tf_config, indent=2)}")

        # NOW import TensorFlow — only after TF_CONFIG is set
        import tensorflow as tf

        # Optional: enable GPU memory growth
        gpus = tf.config.experimental.list_physical_devices('GPU')
        if gpus:
            try:
                for gpu in gpus:
                    tf.config.experimental.set_memory_growth(gpu, True)
            except RuntimeError as e:
                print(f"Error setting memory growth: {e}")
                return

        # Start the TF server
        self.start_server(node_type, index, cluster_config)

    def start_server(self, node_type, index, cluster_config):
        import tensorflow as tf

        cluster_spec = tf.train.ClusterSpec({
            "worker": cluster_config['worker'],
            "ps": cluster_config['ps']
        })

        server = tf.distribute.Server(
            cluster_spec,
            job_name=node_type,
            task_index=index,
            protocol="grpc"
        )

        self.stdout.write(self.style.SUCCESS(
            f"Started {node_type} server at {cluster_spec.as_dict()[node_type][index]}"
        ))

        server.join()
