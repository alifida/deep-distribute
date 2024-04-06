import os
import tensorflow as tf
from tensorflow.keras.applications import ResNet50
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D
from tensorflow.keras.callbacks import Callback
import threading
from datetime import datetime

from train.dao.TrainingJobDAO import TrainingJobDAO
from train.utils.JobStatus import JobStatus

class TrainingService:

    @staticmethod
    def start_training_thread(job):
        thread = threading.Thread(target=TrainingService.start_training, args=(job,))
        thread.start()

    @staticmethod
    def start_training(job):
        # Configure the strategy
        node_type = os.getenv('NODE_TYPE', 'worker')  # Read from environment variable
        index = int(os.getenv('NODE_INDEX', '0'))  # Read from environment variable

        # Define the cluster specification (adjust as necessary)
        cluster_spec = tf.train.ClusterSpec({
            "worker": ["192.168.10.71:2222","192.168.10.106:2222"],
            "ps": ["192.168.10.106:2222"]
        })

        # Create a cluster resolver and strategy
        strategy = tf.distribute.experimental.ParameterServerStrategy(
            tf.distribute.cluster_resolver.SimpleClusterResolver(
                cluster_spec=cluster_spec, rpc_layer="grpc"))

        with strategy.scope():
            dataset_path = job.dataset_img.extracted_path
            print('Dataset Path: ' + dataset_path)

            # Load the ResNet50 model pre-trained on ImageNet
            base_model = ResNet50(weights='imagenet', include_top=False, input_shape=(150, 150, 3))

            # Freeze the layers of the base model
            for layer in base_model.layers:
                layer.trainable = False

            # Add custom layers on top of ResNet50
            x = base_model.output
            x = GlobalAveragePooling2D()(x)
            x = Dense(1024, activation='relu')(x)
            predictions = Dense(1, activation='sigmoid')(x)

            # Create the final model
            model = Model(inputs=base_model.input, outputs=predictions)

            # Compile the model
            model.compile(optimizer='adam', loss='binary_crossentropy',
                          metrics=['accuracy', 'Precision', 'Recall', 'MeanSquaredError'])

        # Set up your dataset
        train_datagen = ImageDataGenerator(rescale=1./255)
        train_generator = train_datagen.flow_from_directory(
            dataset_path,
            target_size=(150, 150),
            batch_size=20,  # Adjust batch size to your needs
            class_mode='binary')

        terminate_on_flag_callback = TerminateOnFlagCallback(job.id)

        # Train the model with the callback
        model.fit(train_generator, epochs=10, callbacks=[terminate_on_flag_callback])

        # Update the job status in the database
        training_job = TrainingJobDAO.get(job.id)
        if training_job.status == JobStatus.RUNNING.value:
            TrainingJobDAO.update(job.id, status=JobStatus.COMPLETED.value, ended_at=datetime.now())


class TerminateOnFlagCallback(Callback):
    def __init__(self, job_id):
        super().__init__()
        self.job_id = job_id

    def on_epoch_end(self, epoch, logs=None):
        training_job = TrainingJobDAO.get(self.job_id)
        if training_job.status != JobStatus.RUNNING.value:
            self.model.stop_training = True
            print(f"Stopping training at the end of epoch {epoch}")
