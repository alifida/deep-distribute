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

    @staticmethod
    def start_training(job):
        print('Start training called...')

        # Define the cluster specification
        cluster_spec = TrainingService.get_cluster_config()

        print("**** CLUSTER NODES ****")
        cluster_spec = {"worker": ["192.168.10.92:2222"], "ps": ["192.168.10.92:2223"]  }
        print(cluster_spec)
        # Set up the cluster resolver and strategy
        cluster_resolver = tf.distribute.cluster_resolver.SimpleClusterResolver(
            tf.train.ClusterSpec(cluster_spec), rpc_layer="grpc")
        print("------------------1")
        #exit()
        print("Cluster Spec:", cluster_resolver.cluster_spec())
        print("Resolving cluster...")
        try:
            print("Master: ", cluster_resolver.master())
            print("Num workers: ", cluster_resolver.num_accelerators())
        except Exception as e:
            print("Failed to resolve cluster:", e)

        strategy = tf.distribute.experimental.ParameterServerStrategy(cluster_resolver)
        print("Strategy initialized.")
         
        print("------------------2")
        # Setup the coordinator
        coordinator = tf.distribute.experimental.coordinator.ClusterCoordinator(strategy)
        print("------------------3")

        # Loss function with Reduction.NONE
        loss_object = BinaryCrossentropy(from_logits=True, reduction=tf.keras.losses.Reduction.NONE)
        print("------------------4")

        # Define `global_batch_size` appropriately
        global_batch_size = 2
        print("------------------5")

        def dataset_fn():
            data_dir = 'E:/dataset/tb_dataset_tiny'
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
            print(f"Number of batches: {dataset.cardinality().numpy()}", flush=True)
            return dataset
        






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

        # Create and distribute the dataset
        distributed_dataset = coordinator.create_per_worker_dataset(dataset_fn)
        distributed_iterator = iter(distributed_dataset)

        # Training loop
        for epoch in range(10):
            start_epoch = time.time()
            print(f"Starting epoch {epoch + 1}")
            batch_index = 0
            while True:
                start_batch = time.time()
                try:
                    coordinator.schedule(per_worker_train_step, args=(distributed_iterator,))
                    print(f"Batch {batch_index} processed in {time.time() - start_batch} seconds.")
                    batch_index += 1
                except tf.errors.OutOfRangeError:
                    print("There are no more batches to process")
                    break
            coordinator.join()  # Wait for all tasks to complete
            print(f"Epoch {epoch + 1} completed in {time.time() - start_epoch} seconds.")
            distributed_iterator = iter(distributed_dataset)  # Reset iterator for the next epoch

        # Update job status upon completion
        TrainingJobDAO.update(job.id, status=JobStatus.COMPLETED.value)

        print('Training complete.')
