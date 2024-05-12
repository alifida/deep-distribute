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
class TrainingService:
    @staticmethod
    def start_training(job):
        #logging.basicConfig(level=logging.DEBUG)

        #os.environ['TF_CPP_MIN_LOG_LEVEL'] = '0'  # Enable TF logging
        #tf.debugging.set_log_device_placement(True)  # Log device placement (operations on which devices)

        print('Start training called...')

        # Define the cluster specification
        cluster_spec = {
            "worker": ["192.168.100.109:2222"],
            "ps": ["192.168.100.109:2223"]
        }

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
            datagen = ImageDataGenerator(rescale=1./255)
            train_dataset = datagen.flow_from_directory(
                'E:/dataset/tb_dataset_tiny',  # Path to the data
                target_size=(150, 150),        # All images will be resized to 150x150
                batch_size=global_batch_size,
                class_mode='binary'            # For binary classification
            )
            # Convert to tf.data.Dataset
            return tf.data.Dataset.from_generator(
                lambda: ((img, label) for img, label in train_dataset),
                output_types=(tf.float32, tf.float32),
                output_shapes=([None, 150, 150, 3], [None])
            ).prefetch(tf.data.experimental.AUTOTUNE)

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
        for epoch in range(10):  # Number of epochs
            start_epoch = time.time()
            print(f"Starting epoch********** {epoch + 1}")
            batch_index = 0
            #while True:
            start_batch = time.time()
            try:
                coordinator.schedule(per_worker_train_step, args=(distributed_iterator,))
                print(f"Batch {batch_index} processed in {time.time() - start_batch} seconds.")
                batch_index += 1
            except tf.errors.OutOfRangeError:
                print("there are no more batches to process")
                #break  # Break the loop when there are no more batches to process
            coordinator.join()  # Wait for all tasks to complete
            print(f"Epoch {epoch + 1} completed in {time.time() - start_epoch} seconds.")

            distributed_iterator = iter(distributed_dataset)  # Reset iterator for the next epoch

        # Update job status upon completion
        TrainingJobDAO.update(job.id, status = JobStatus.COMPLETED.value)
        
        print('Training complete.')

