import tensorflow as tf
from tensorflow.keras.losses import BinaryCrossentropy
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.models import Model
from tensorflow.keras.applications import ResNet50
from tensorflow.keras.layers import GlobalAveragePooling2D, Dense
from tensorflow.keras.backend import clear_session
from django.utils import timezone
from django.conf import settings
from train.dao.TrainingJobDAO import TrainingJobDAO
from train.utils.JobStatus import JobStatus
from train.services.KerasCatalogService import KerasCatalogService
import requests
import threading
import os
import json
import time
from multiprocessing import Process


def worker_process(job_id):
    import django
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'deepdistribute.settings')
    django.setup()

    from train.services import TrainingServicePS
    from train.models import Training_job

    job = Training_job.objects.get(id=job_id)
    TrainingServicePS.start_training({'training_job': job})


class TrainingServicePS:

    @staticmethod
    def get_cluster_config():
        url = settings.CLUSTER_DETAIL_URL
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            raise Exception(f"Failed to retrieve cluster configuration, status code {response.status_code}")

    @staticmethod
    def start_training_thread(job):
        clear_session()
        thread = threading.Thread(target=TrainingServicePS.start_training, args=({'training_job': job},))
        thread.start()

    @staticmethod
    def start_training_process(job_id):
        process = Process(target=worker_process, args=(job_id,))
        process.start()
        process.join()

    @staticmethod
    def start_training(training_params):
        print('Start training called...')
        job = training_params['training_job']
        cluster_spec = TrainingServicePS.get_cluster_config()

        cluster_resolver = tf.distribute.cluster_resolver.SimpleClusterResolver(
            tf.train.ClusterSpec(cluster_spec), rpc_layer="grpc")
        strategy = tf.distribute.experimental.ParameterServerStrategy(cluster_resolver)
        coordinator = tf.distribute.experimental.coordinator.ClusterCoordinator(strategy)

        global_batch_size = 20
        loss_object = BinaryCrossentropy(from_logits=True, reduction=tf.keras.losses.Reduction.NONE)

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

        raw_dataset = dataset_fn()
        num_classes = len(raw_dataset.class_names)

        with strategy.scope():
            base_model = ResNet50(weights='imagenet', include_top=False, input_shape=(150, 150, 3))
            for layer in base_model.layers:
                layer.trainable = False
            x = base_model.output
            x = GlobalAveragePooling2D()(x)
            x = Dense(1024, activation='relu')(x)
            predictions = Dense(1, activation='sigmoid')(x)
            model = Model(inputs=base_model.input, outputs=predictions)
            optimizer = Adam()
            model.compile(optimizer=optimizer, loss=loss_object,
                          metrics=['accuracy', tf.keras.metrics.Precision(),
                                   tf.keras.metrics.Recall(), tf.keras.metrics.AUC()])

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

        distributed_dataset = coordinator.create_per_worker_dataset(dataset_fn)
        distributed_iterator = iter(distributed_dataset)

        for epoch in range(10):
            start_epoch = time.time()
            print(f"Starting epoch {epoch + 1}")
            batch_index = 0
            try:
                while True:
                    start_batch = time.time()
                    coordinator.schedule(per_worker_train_step, args=(distributed_iterator,))
                    print(f"Batch {batch_index} processed in {time.time() - start_batch:.2f} sec")
                    batch_index += 1
            except tf.errors.OutOfRangeError:
                print("End of epoch dataset.")
            coordinator.join()
            print(f"Epoch {epoch + 1} finished in {time.time() - start_epoch:.2f} sec")
            distributed_iterator = iter(distributed_dataset)

        def eval_dataset_fn():
            return dataset_fn()

        eval_distributed_dataset = coordinator.create_per_worker_dataset(eval_dataset_fn)
        eval_distributed_iterator = iter(eval_distributed_dataset)

        accuracy_metric = tf.keras.metrics.BinaryAccuracy()
        precision_metric = tf.keras.metrics.Precision()
        recall_metric = tf.keras.metrics.Recall()
        auc_metric = tf.keras.metrics.AUC()

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

        try:
            while True:
                coordinator.schedule(per_worker_eval_step, args=(eval_distributed_iterator,))
        except tf.errors.OutOfRangeError:
            pass
        coordinator.join()

        final_accuracy = accuracy_metric.result().numpy()
        final_precision = precision_metric.result().numpy()
        final_recall = recall_metric.result().numpy()
        final_auc = auc_metric.result().numpy()
        final_f1 = 2 * (final_precision * final_recall) / (final_precision + final_recall + 1e-7)

        ended_at = timezone.now()
        results = {
            'accuracy': float(final_accuracy),
            'precision': float(final_precision),
            'recall': float(final_recall),
            'auc': float(final_auc),
            'f1_score': float(final_f1)
        }

        results_json = json.dumps(results)
        TrainingJobDAO.update(job.id, status=JobStatus.COMPLETED.value, result=results_json, ended_at=ended_at)

        print(f'Training complete. Final accuracy: {final_accuracy:.4f}')
