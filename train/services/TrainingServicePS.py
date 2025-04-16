import os
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.losses import BinaryCrossentropy
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from train.utils.JobStatus import JobStatus
from train.dao.TrainingJobDAO import TrainingJobDAO
import logging
import os
import time
from django.conf import settings
import requests
import threading
from tensorflow.keras.backend import clear_session
from multiprocessing import Process
from django.utils import timezone
import json
from sklearn.metrics import accuracy_score, precision_score, recall_score, roc_auc_score, f1_score
from train.services.KerasCatalogService import KerasCatalogService


from tensorflow.keras.applications import ResNet50
from tensorflow.keras.layers import GlobalAveragePooling2D, Dense
from tensorflow.keras.models import Model



def worker_process(job_id):
    import django
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'deepdistribute.settings')
    django.setup()

    # Now import any Django-dependent modules
    from train.services import TrainingServicePS
    from train.models import Training_job

    job = Training_job.objects.get(id=job_id)
    TrainingServicePS.start_training(job)

class TrainingServicePS:

    @staticmethod
    def get_cluster_config():
        # URL of the Django API endpoint
        url = settings.CLUSTER_DETAIL_URL
        response = requests.get(url)
        print("*****************************************")
        print(response.json())
        print("*****************************************")
        if response.status_code == 200:
            return response.json()
        else:
            raise Exception(f"Failed to retrieve cluster configuration, status code {response.status_code}")

    @staticmethod
    def start_training_thread(job):
        clear_session() 
        thread = threading.Thread(target=TrainingServicePS.start_training, args=(job,))
        thread.start()

    @staticmethod
    def start_training_process(job_id):
        from multiprocessing import Process
        process = Process(target=worker_process, args=(job_id,))
        process.start()
        process.join()

    @staticmethod
    def start_training(training_params):

        TrainingServicePS.init_tf_config()


        print('Start training called...')
        job = training_params['training_job']
        # Define the cluster specification
       
        
        # Set up the cluster resolver and strategy
        
        
        tf_config = os.environ.get("TF_CONFIG")
        print("****************************")
        print(tf_config)
        print("****************************")
        if not tf_config:
            raise ValueError("TF_CONFIG environment variable is not set!")

        cluster_resolver = tf.distribute.cluster_resolver.TFConfigClusterResolver()
        strategy 
        cluster_resolver = tf.distribute.cluster_resolver.TFConfigClusterResolver()
        strategy = tf.distribute.experimental.ParameterServerStrategy(cluster_resolver)

        # Setup the coordinator
        coordinator = tf.distribute.experimental.coordinator.ClusterCoordinator(strategy)
        # Loss function with Reduction.NONE
        loss_object = BinaryCrossentropy(from_logits=True, reduction=tf.keras.losses.Reduction.NONE)

        # Define `global_batch_size` appropriately
        global_batch_size = 20  # Adjust based on your setup
        def load_base_dataset():
            data_dir = job.dataset_img.extracted_path
            raw_dataset = tf.keras.preprocessing.image_dataset_from_directory(
                data_dir,
                image_size=(150, 150),
                batch_size=global_batch_size,
                label_mode='categorical'  # changed from 'binary' to support multi-class
            )
            class_names = raw_dataset.class_names
            return raw_dataset.prefetch(tf.data.experimental.AUTOTUNE), len(class_names)

        def train_step_fn(images, labels):
            with tf.GradientTape() as tape:
                predictions = model(images, training=True)
                per_example_loss = loss_object(labels, predictions)
                loss = tf.reduce_sum(per_example_loss) * (1. / global_batch_size)
            grads = tape.gradient(loss, model.trainable_variables)
            optimizer.apply_gradients(zip(grads, model.trainable_variables))
            return loss

        @tf.function
        def per_worker_train_step(iterator):
            images, labels = next(iterator)
            return strategy.run(train_step_fn, args=(images, labels))

        def dataset_fn():
            data_dir = job.dataset_img.extracted_path
            batch_size = global_batch_size
            img_height = 150
            img_width = 150

            dataset = tf.keras.preprocessing.image_dataset_from_directory(
                data_dir,
                image_size=(img_height, img_width),
                batch_size=batch_size,
                label_mode='binary'
            ).prefetch(tf.data.experimental.AUTOTUNE)

            print("Dataset loaded successfully.", flush=True)
            return dataset
        
        dataset_prefetched, num_classes = load_base_dataset()
        # Create the model under the strategy scope
        with strategy.scope():
            '''model = Sequential([
                Conv2D(32, (3, 3), activation='relu', input_shape=(150, 150, 3)),
                MaxPooling2D(2, 2),
                Conv2D(64, (3, 3), activation='relu'),
                MaxPooling2D(2, 2),
                Flatten(),
                Dense(128, activation='relu'),
                Dense(1, activation='sigmoid')
            ])
            optimizer = Adam()
            model.compile(optimizer=optimizer, loss=loss_object, metrics=['accuracy', 'Precision', 'Recall', 'AUC'])
            '''
            #base_model = ResNet50(weights='imagenet', include_top=False, input_shape=(150, 150, 3))
            
             # Dynamically load the model based on model_name
            base_model = KerasCatalogService.get_model_object(training_params['algo_name'])

            for layer in base_model.layers:
                layer.trainable = False

            x = base_model.output
            x = GlobalAveragePooling2D()(x)
            x = Dense(1024, activation='relu')(x)
            predictions = Dense(1, activation='sigmoid')(x)

            model = Model(inputs=base_model.input, outputs=predictions)
            optimizer = Adam()
            model.compile(optimizer=optimizer, loss=loss_object, metrics=['accuracy', 'Precision', 'Recall', 'AUC'])
        
        # Create and distribute the dataset
        distributed_dataset = coordinator.create_per_worker_dataset(dataset_fn)
        distributed_iterator = iter(distributed_dataset)

        # Training loop
        for epoch in range(10):  # Number of epochs
            start_epoch = time.time()
            print(f"Starting epoch {epoch + 1}")
            batch_index = 0
            start_batch = time.time()
            try:
                coordinator.schedule(per_worker_train_step, args=(distributed_iterator,))
                print(f"Batch {batch_index} processed in {time.time() - start_batch} seconds.")
                batch_index += 1
            except tf.errors.OutOfRangeError:
                print("There are no more batches to process")
            coordinator.join()  # Wait for all tasks to complete
            print(f"Epoch {epoch + 1} completed in {time.time() - start_epoch} seconds.")

            distributed_iterator = iter(distributed_dataset)  # Reset iterator for the next epoch

        def eval_dataset_fn():
            data_dir = job.dataset_img.extracted_path
            batch_size = global_batch_size
            img_height = 150
            img_width = 150

            dataset = tf.keras.preprocessing.image_dataset_from_directory(
                data_dir,
                image_size=(img_height, img_width),
                batch_size=batch_size,
                label_mode='binary'
            ).prefetch(tf.data.experimental.AUTOTUNE)

            return dataset

        # Create and distribute the evaluation dataset
        eval_distributed_dataset = coordinator.create_per_worker_dataset(eval_dataset_fn)
        eval_distributed_iterator = iter(eval_distributed_dataset)

        @tf.function
        def per_worker_eval_step(iterator):
            def step_fn(inputs):
                images, labels = inputs
                predictions = model(images, training=False)
                accuracy_metric.update_state(labels, predictions)
                precision_metric.update_state(labels, predictions)
                recall_metric.update_state(labels, predictions)
                auc_metric.update_state(labels, predictions)
            return strategy.run(step_fn, args=(next(iterator),))

        # Evaluation loop
        accuracy_metric = tf.keras.metrics.BinaryAccuracy()
        precision_metric = tf.keras.metrics.Precision()
        recall_metric = tf.keras.metrics.Recall()
        auc_metric = tf.keras.metrics.AUC()
        
        while True:
            try:
                coordinator.schedule(per_worker_eval_step, args=(eval_distributed_iterator,))
            except tf.errors.OutOfRangeError:
                break
        coordinator.join()

        final_accuracy = accuracy_metric.result().numpy()
        final_precision = precision_metric.result().numpy()
        final_recall = recall_metric.result().numpy()
        final_auc = auc_metric.result().numpy()
        final_f1 = 2 * (final_precision * final_recall) / (final_precision + final_recall + 1e-7)

        ended_at = timezone.now()
        # Update job status and accuracy upon completion
        results = {
            'accuracy': float(final_accuracy),
            'precision': float(final_precision),
            'recall': float(final_recall),
            'auc': float(final_auc),
            'f1_score': float(final_f1)
        }
        results_json = json.dumps(results)
        TrainingJobDAO.update(job.id, status=JobStatus.COMPLETED.value, result=results_json, ended_at=ended_at)
        
        print(f'Training complete. Final accuracy: {final_accuracy}')

    @staticmethod
    def init_tf_config():
        import socket
        cluster_spec = TrainingServicePS.get_cluster_config()
        local_ip = socket.gethostbyname(socket.gethostname())
        node_type = os.getenv('NODE_TYPE', 'worker')  # or determine another way if needed

        all_workers = cluster_spec.get('worker', [])
        all_ps = cluster_spec.get('ps', [])

        if node_type == 'worker':
            matched_indices = [i for i, addr in enumerate(all_workers) if local_ip in addr]
        elif node_type == 'ps':
            matched_indices = [i for i, addr in enumerate(all_ps) if local_ip in addr]
        else:
            matched_indices = []  # Could be 'chief' or coordinator, and might not be in the list

        if matched_indices:
            index = matched_indices[0]
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
        else:
            print("This node is not part of worker/ps. Assuming chief/coordinator.")