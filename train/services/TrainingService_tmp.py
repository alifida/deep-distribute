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
import django

def worker_process(job_id):
    import django
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'deepdistribute.settings')
    django.setup()

    # Now import any Django-dependent modules
    from train.services import TrainingService
    from train.models import Training_job

    job = Training_job.objects.get(id=job_id)
    TrainingService.start_training(job)

class TrainingService:

    @staticmethod
    def get_cluster_config():
        # URL of the Django API endpoint
        url = settings.CLUSTER_DETAIL_URL
        response = requests.get(url)
        print("*****************************************")
        print(response.json())
        print("*****************************************")
        if response.status_code == 200:
            #return '{"worker": ["192.168.10.92:2222"], "ps": ["192.168.10.92:2223"]}'
            return response.json()
        else:
            raise Exception(f"Failed to retrieve cluster configuration, status code {response.status_code}")

    '''
    '''
    @staticmethod
    def start_training_thread(job):
        clear_session() 


        thread = threading.Thread(target=TrainingService.start_training, args=(job,))
        thread.start()


    @staticmethod
    def start_training_process(job_id):
        from multiprocessing import Process
        process = Process(target=worker_process, args=(job_id,))
        process.start()
        process.join()

    @staticmethod
    def start_training(job):
        #logging.basicConfig(level=logging.DEBUG)

        #os.environ['TF_CPP_MIN_LOG_LEVEL'] = '0'  # Enable TF logging
        #tf.debugging.set_log_device_placement(True)  # Log device placement (operations on which devices)

        print('Start training called...')

        # Define the cluster specification
        # cluster_spec = {
        #     "worker": ["192.168.10.92:2222"],
        #     "ps": ["192.168.10.92:2223"]
        # }

        cluster_spec = TrainingService.get_cluster_config()
        # Set up the cluster resolver and strategy
        cluster_resolver = tf.distribute.cluster_resolver.SimpleClusterResolver(
            tf.train.ClusterSpec(cluster_spec), rpc_layer="grpc")
        strategy = tf.distribute.experimental.ParameterServerStrategy(cluster_resolver)

        # Setup the coordinator
        coordinator = tf.distribute.experimental.coordinator.ClusterCoordinator(strategy)

        # Loss function with Reduction.NONE
        loss_object = BinaryCrossentropy(from_logits=True, reduction=tf.keras.losses.Reduction.NONE)

        # Define `global_batch_size` appropriately
        global_batch_size = 2  # Adjust based on your setup

        # Training step function scoped correctly
         # Training step function scoped correctly
        def train_step_fn(images, labels):
            with tf.GradientTape() as tape:
                predictions = model(images, training=True)
                per_example_loss = loss_object(labels, predictions)
                loss = tf.reduce_sum(per_example_loss) * (1. / global_batch_size)
            grads = tape.gradient(loss, model.trainable_variables)
            optimizer.apply_gradients(zip(grads, model.trainable_variables))
            return loss

        # Define the per-worker training step
        @tf.function
        def per_worker_train_step(iterator):
            images, labels = next(iterator)
            return strategy.run(train_step_fn, args=(images, labels))

        # Define the dataset loading function
        def dataset_fn():
            data_dir = job.dataset_img.extracted_path
            print("**************8888888***************" + data_dir);
            #data_dir = 'E:/dataset/tb_dataset_tiny'
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
            #print(f"Number of batches: {dataset.cardinality().numpy()}", flush=True)
            return dataset

        # Create the model under the strategy scope
            with strategy.scope():
                model = Sequential([
                    Conv2D(32, (3, 3), activation='relu', input_shape=(150, 150, 3)),
                    MaxPooling2D(2, 2),
                    Conv2D(64, (3, 3), activation='relu'),
                    MaxPooling2D(2, 2),
                    Flatten(),
                    Dense(128, activation='relu'),
                    Dense(1, activation='sigmoid')
                ])
                optimizer = Adam()
                model.compile(optimizer=optimizer, loss=loss_object, metrics=['accuracy'])

            # Start tracking time
            start_time = time.time()

            # Training loop
            for epoch in range(10):  # Number of epochs
                start_epoch = time.time()
                print(f"Starting epoch {epoch + 1}")
                batch_index = 0

                try:
                    coordinator.schedule(per_worker_train_step, args=(distributed_iterator,))
                    batch_index += 1
                except tf.errors.OutOfRangeError:
                    print("No more batches to process")

                coordinator.join()

                epoch_time = time.time() - start_epoch
                print(f"Epoch {epoch + 1} completed in {epoch_time} seconds.")

                distributed_iterator = iter(distributed_dataset)  # Reset iterator for the next epoch

            # Calculate total training time
            total_time = time.time() - start_time
            print(f"Total training time: {total_time} seconds")

            # Get final accuracy
            metrics = model.evaluate(distributed_dataset)
            accuracy = metrics[1]  # Assuming accuracy is the second metric returned by evaluate()

            print(f"Final accuracy: {accuracy}")

            # Update job status upon completion (you may want to handle this part in a separate function or class)
            TrainingJobDAO.update(job.id, status=JobStatus.COMPLETED.value)

            print('Training complete.')

