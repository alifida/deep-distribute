import os
import tensorflow as tf
from tensorflow.keras.applications import ResNet50
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D
from tensorflow.keras.callbacks import TensorBoard, Callback
from datetime import datetime
import threading
import logging


from train.dao.TrainingJobDAO import TrainingJobDAO
from train.utils.JobStatus import JobStatus

# Helper function to get label from file path
def get_label(file_path):
    # Assuming directory structure: /path/to/data/class_x/xxx.png
    return tf.strings.split(file_path, os.path.sep)[-2]

 
class TrainingService_2:
    @staticmethod
    def start_training_thread(job):
        thread = threading.Thread(target=TrainingService_2.start_training, args=(job,))
        thread.start()

    @staticmethod
    def start_training(job):

        logging.basicConfig(level=logging.DEBUG)

        os.environ['TF_CPP_MIN_LOG_LEVEL'] = '0'  # Enable TF logging
        tf.debugging.set_log_device_placement(True)  # Log device placement (operations on which devices)


        print("Configuring distributed strategy")
        cluster_spec = tf.train.ClusterSpec({
            "worker": ["172.16.1.97:2222"],
            "ps": ["172.16.1.97:2223"]
        })
        cluster_resolver = tf.distribute.cluster_resolver.SimpleClusterResolver(cluster_spec, rpc_layer="grpc")
        strategy = tf.distribute.experimental.ParameterServerStrategy(cluster_resolver)
        coordinator = tf.distribute.experimental.coordinator.ClusterCoordinator(strategy)

        with strategy.scope():
            dataset_path = job.dataset_img.extracted_path
            
            def decode_img(img):
                # Convert the compressed string to a 3D uint8 tensor and resize the image
                img = tf.image.decode_png(img, channels=3)
                return tf.image.resize(img, [150, 150])
            
            def prepare_dataset(dataset_path, batch_size=5):
                image_paths = tf.io.gfile.glob(dataset_path + '/**/*.png')
                list_ds = tf.data.Dataset.list_files(image_paths, shuffle=False)
                list_ds = list_ds.map(process_path, num_parallel_calls=tf.data.AUTOTUNE)
                return list_ds.batch(batch_size).prefetch(buffer_size=tf.data.AUTOTUNE)



            # Simplified dataset preparation code
            dataset_path_pattern = dataset_path + '/**/*.png'
            def process_path(file_path):
                label = get_label(file_path)
                img = tf.io.read_file(file_path)
                img = decode_img(img)
                return img, label
            
            try:
                #train_dataset = tf.data.Dataset.list_files(dataset_path_pattern)
                train_dataset = prepare_dataset(dataset_path, batch_size=5)
                #train_dataset = train_dataset.map(process_path, num_parallel_calls=tf.data.AUTOTUNE)
                #train_dataset = train_dataset.batch(5).prefetch(buffer_size=tf.data.AUTOTUNE)

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

                coordinator.schedule(lambda: model.fit(train_dataset, epochs=2, callbacks=[tensorboard_callback]))

                coordinator.join()
                training_job = TrainingJobDAO.get(job.id)
                if training_job.status == JobStatus.RUNNING.value:
                    TrainingJobDAO.update(job.id, status=JobStatus.COMPLETED.value, ended_at=datetime.now())
            except Exception as e:
                logging.error("Failed during dataset preparation or training: ", exc_info=True)
                TrainingJobDAO.update(job.id, status=JobStatus.FAILED.value, ended_at=datetime.now())
     
class TerminateOnFlagCallback(Callback):
    def __init__(self, job_id):
        super().__init__()
        self.job_id = job_id

    def on_epoch_end(self, epoch, logs=None):
        training_job = TrainingJobDAO.get(self.job_id)
        if training_job.status != JobStatus.RUNNING.value:
            self.model.stop_training = True
            print(f"Stopping training at the end of epoch {epoch}")

# You can use TerminateOnFlagCallback as needed in your callbacks list.
