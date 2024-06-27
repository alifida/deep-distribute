import tensorflow as tf
from tensorflow.keras.applications import ResNet50
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D
from common.utils import util

from train.dao.TrainingJobDAO import TrainingJobDAO
from train.utils.JobStatus import JobStatus
from django.utils import timezone

from tensorflow.keras.callbacks import Callback
import threading
import json
import numpy as np
from sklearn.metrics import accuracy_score


class TrainingService:

    @staticmethod
    def start_training_thread(job):
        thread = threading.Thread(target=TrainingService.start_training, args=(job,))
        thread.start()

    @staticmethod
    def start_training(job):

        dataset_path = job.dataset_img.extracted_path
        print('Dataset Path:', dataset_path)

        # Load the ResNet50 model pre-trained on ImageNet
        base_model = ResNet50(weights='imagenet', include_top=False, input_shape=(150, 150, 3))

        # Freeze the layers of the base model
        for layer in base_model.layers:
            layer.trainable = False

        # Add custom layers on top of ResNet50
        x = base_model.output
        x = GlobalAveragePooling2D()(x)
        x = Dense(1024, activation='relu')(x)
        predictions = Dense(1, activation='sigmoid')(x)  # Assuming binary classification

        # Create the final model
        model = Model(inputs=base_model.input, outputs=predictions)

        # Compile the model
        model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy', 'Precision','Recall','MeanSquaredError'])

        # Set up your dataset
        train_datagen = ImageDataGenerator(rescale=1./255)
        train_generator = train_datagen.flow_from_directory(
                dataset_path,
                target_size=(150, 150),
                batch_size=20,
                class_mode='binary')

        test_datagen = ImageDataGenerator(rescale=1./255)
        test_generator = test_datagen.flow_from_directory(
                dataset_path,
                target_size=(150, 150),
                batch_size=20,
                class_mode='binary',
                shuffle=False)

        # Train the model with the callback
        terminate_on_flag_callback = TerminateOnFlagCallback(job.id)
        model.fit(train_generator, epochs=10, callbacks=[terminate_on_flag_callback])

        # Predictions on test set
        predictions = model.predict(test_generator)

        # Calculate accuracy (example for binary classification)
        actual_labels = test_generator.classes
        binary_predictions = (predictions > 0.5).astype(int).flatten()  # Convert probabilities to binary predictions
        accuracy = accuracy_score(actual_labels, binary_predictions)

        # Prepare results in JSON format
        results = {
            
            'accuracy': float(accuracy),
            'predictions': predictions.flatten().tolist(),
            # Include other metrics or details as needed
        }
        results_json = json.dumps(results)

        # Update job status in TrainingJobDAO
        TrainingJobDAO.update(
            job.id,
            status=JobStatus.COMPLETED.value,
            ended_at=timezone.now(),
            result=results_json
        )

class TerminateOnFlagCallback(Callback):
    def __init__(self, job_id):
        super().__init__()
        self.job_id = job_id

    def on_epoch_end(self, epoch, logs=None):
        training_job = TrainingJobDAO.get(self.job_id)
        if training_job.status != JobStatus.RUNNING.value:  
            self.model.stop_training = True
            print(f"Stopping training at the end of epoch {epoch}")


