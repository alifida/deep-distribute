import tensorflow as tf
from tensorflow.keras.applications import ResNet50
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Model
from tensorflow.keras.layers import GlobalAveragePooling2D, Dense
from tensorflow.keras.metrics import Precision, Recall, AUC
from tensorflow.keras.callbacks import Callback

import json
from django.utils import timezone
from train.dao.TrainingJobDAO import TrainingJobDAO
from train.utils.JobStatus import JobStatus
from sklearn.metrics import f1_score
from train.services.KerasCatalogService import KerasCatalogService
#import asyncio
from django.http import JsonResponse
from multiprocessing import Process

 
 
    
class TrainingServiceSingle:
    


    @staticmethod
    def start_training_process(job, model_name):
        
        
        process = Process(target=TrainingServiceSingle.start_training,args=(job, model_name,))
        process.start()
        #process.join()  # Optionally wait for the process to complete

    
    @staticmethod
    def start_training(job, model_name):
        from train.models import Training_job
        from train.dao.TrainingJobDAO import TrainingJobDAO

        dataset_path = job.dataset_img.extracted_path
        print('Dataset Path:', dataset_path)

        # Load the ResNet50 model pre-trained on ImageNet
        #base_model = ResNet50(weights='imagenet', include_top=False, input_shape=(150, 150, 3))
        base_model = KerasCatalogService.get_model_object(model_name);
        # Freeze the layers of the base model
        for layer in base_model.layers:
            layer.trainable = False

        # Add custom layers on top of ResNet50
        x = base_model.output
        x = GlobalAveragePooling2D()(x)
        x = Dense(1, activation='sigmoid')(x)  # Assuming binary classification

        # Create the final model
        model = Model(inputs=base_model.input, outputs=x)
        
        # Compile the model
        model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy', Precision(), Recall(), AUC()])

        # Set up your dataset
        train_datagen = ImageDataGenerator(rescale=1./255, validation_split=0.2)
        train_generator = train_datagen.flow_from_directory(
                dataset_path,
                target_size=(150, 150),
                batch_size=20,
                class_mode='binary',
                subset='training')

        validation_generator = train_datagen.flow_from_directory(
                dataset_path,
                target_size=(150, 150),
                batch_size=20,
                class_mode='binary',
                subset='validation')

        test_datagen = ImageDataGenerator(rescale=1./255)
        test_generator = test_datagen.flow_from_directory(
                dataset_path,
                target_size=(150, 150),
                batch_size=20,
                class_mode='binary',
                shuffle=False)

        # Train the model with the callback
        terminate_on_flag_callback = TerminateOnFlagCallback(job.id)
        model.fit(train_generator, epochs=10, validation_data=validation_generator, callbacks=[terminate_on_flag_callback])

        # Predictions on test set
        predictions = model.predict(test_generator)

        # Calculate metrics
        actual_labels = test_generator.classes
        binary_predictions = (predictions > 0.5).astype(int).flatten()

        accuracy = tf.keras.metrics.BinaryAccuracy()(actual_labels, binary_predictions).numpy()
        precision = tf.keras.metrics.Precision()(actual_labels, binary_predictions).numpy()
        recall = tf.keras.metrics.Recall()(actual_labels, binary_predictions).numpy()
        auc = tf.keras.metrics.AUC()(actual_labels, binary_predictions).numpy()
        f1 = f1_score(actual_labels, binary_predictions)

        # Prepare results in JSON format
        results = {
            'accuracy': float(accuracy),
            'precision': float(precision),
            'recall': float(recall),
            'auc': float(auc),
            'f1_score': float(f1)
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

