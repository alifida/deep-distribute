import os
import tensorflow as tf
from tensorflow.keras.callbacks import TensorBoard
from datetime import datetime
from tensorflow.keras.applications import ResNet50
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D
from tensorflow.keras.callbacks import Callback
import threading

from train.dao.TrainingJobDAO import TrainingJobDAO
from train.utils.JobStatus import JobStatus

class TrainingService:

    @staticmethod
    def start_training_thread(job):
        thread = threading.Thread(target=TrainingService.start_training, args=(job,))
        thread.start()

    @staticmethod
    def start_training(job):
        print("Configuring distributed strategy")
        cluster_spec = tf.train.ClusterSpec({
            "worker": ["192.168.10.106:2222", "192.168.10.71:2222"],
            "ps": ["192.168.10.106:2223"]
        })
        cluster_resolver = tf.distribute.cluster_resolver.SimpleClusterResolver(
            cluster_spec=cluster_spec, rpc_layer="grpc"
        )
        strategy = tf.distribute.experimental.ParameterServerStrategy(cluster_resolver)

        with strategy.scope():
            dataset_path = job.dataset_img.extracted_path
            if not os.path.exists(dataset_path):
                print(f"Dataset path {dataset_path} does not exist.")
                return

            log_dir = f"logs/fit/{datetime.now().strftime('%Y%m%d-%H%M%S')}"
            tensorboard_callback = TensorBoard(log_dir=log_dir, histogram_freq=1)

            base_model = ResNet50(weights='imagenet', include_top=False, input_shape=(150, 150, 3))
            for layer in base_model.layers:
                layer.trainable = False

            x = base_model.output
            x = GlobalAveragePooling2D()(x)
            x = Dense(1024, activation='relu')(x)
            predictions = Dense(1, activation='sigmoid')(x)
            model = Model(inputs=base_model.input, outputs=predictions)
            model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy', 'Precision', 'Recall', 'MeanSquaredError'])

            train_datagen = ImageDataGenerator(rescale=1./255)
            train_generator = TrainingService.distribute_datasets(strategy, dataset_path, train_datagen)

            terminate_on_flag_callback = TerminateOnFlagCallback(job.id)
            model.fit(train_generator, epochs=10, callbacks=[tensorboard_callback, terminate_on_flag_callback])

            training_job = TrainingJobDAO.get(job.id)
            if training_job.status == JobStatus.RUNNING.value:
                TrainingJobDAO.update(job.id, status=JobStatus.COMPLETED.value, ended_at=datetime.now())
    
    @staticmethod
    def distribute_datasets(strategy, dataset_path, train_datagen):
        """ Prepare and distribute datasets using a tf.function within TensorFlow's distributed strategy. """
        @tf.function
        def dataset_fn(input_context):
            batch_size = input_context.get_per_replica_batch_size(global_batch_size)
            return train_datagen.flow_from_directory(
                dataset_path,
                target_size=(150, 150),
                batch_size=batch_size,
                class_mode='binary')

        global_batch_size = 20
        return strategy.distribute_datasets_from_function(dataset_fn)

class TerminateOnFlagCallback(Callback):
    def __init__(self, job_id):
        super().__init__()
        self.job_id = job_id

    def on_epoch_end(self, epoch, logs=None):
        training_job = TrainingJobDAO.get(self.job_id)
        if training_job.status != JobStatus.RUNNING.value:
            self.model.stop_training = True
            print(f"Stopping training at the end of epoch {epoch}")
