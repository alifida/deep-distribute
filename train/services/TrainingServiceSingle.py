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
from tensorflow.keras.callbacks import EarlyStopping


 
    
class TrainingServiceSingle:
    


    @staticmethod
    def start_training_process__old(job, model_name):
        
        
        process = Process(target=TrainingServiceSingle.start_training,args=(job, model_name,))
        process.start()
        #process.join()  # Optionally wait for the process to complete

    @staticmethod
    def start_training_process(job, model_name):
        print("before starting........")
        TrainingServiceSingle.start_training.delay(job.id, model_name)
        print("after starting........")

    @staticmethod
    def start_training(training_params):
        from train.models import Training_job
        from train.dao.TrainingJobDAO import TrainingJobDAO
        from tensorflow.keras.optimizers import Adam, SGD, RMSprop, Adadelta , Adagrad, Adamax, Nadam, Ftrl # Import other optimizers as needed

        # Extracting paths from training job
        dataset_path_train = training_params['training_job'].dataset_img.extracted_path
        dataset_path_test = training_params['training_job'].dataset_img.extracted_path_test

        # Dynamically load the model based on model_name
        base_model = KerasCatalogService.get_model_object(training_params['algo_name'])

        # Freeze the layers of the base model
        for layer in base_model.layers:
            layer.trainable = False

        # Add custom layers on top of the base model
        x = base_model.output
        x = GlobalAveragePooling2D()(x)
        x = Dense(1, activation='sigmoid')(x)  # Assuming binary classification

        # Create the final model
        model = Model(inputs=base_model.input, outputs=x)

        # Select optimizer dynamically
        optimizer = None
        learning_rate = float(training_params['learning_rate'])

        if training_params['optimizer'] == 'adam':
            optimizer = Adam(learning_rate=learning_rate)
        elif training_params['optimizer'] == 'sgd':
            optimizer = SGD(learning_rate=learning_rate)
        elif training_params['optimizer'] == 'rmsprop':
            optimizer = RMSprop(learning_rate=learning_rate)
        elif training_params['optimizer'] == 'adadelta':
            optimizer = Adadelta(learning_rate=learning_rate)
        elif training_params['optimizer'] == 'adagrad':
            optimizer = Adagrad(learning_rate=learning_rate)
        elif training_params['optimizer'] == 'adamax':
            optimizer = Adamax(learning_rate=learning_rate)
        elif training_params['optimizer'] == 'nadam':
            optimizer = Nadam(learning_rate=learning_rate)
        elif training_params['optimizer'] == 'ftrl':
            optimizer = Ftrl(learning_rate=learning_rate)

        # Compile the model with dynamic parameters
        model.compile(optimizer=optimizer, 
                    loss=training_params['loss_function'], 
                    metrics=['accuracy', Precision(), Recall(), AUC()])

        # Set up the dataset
        if training_params['augmentation'] and training_params['augmentation'].lower() != 'none':
            augmentation_params = eval(training_params['augmentation'])
        else:
            augmentation_params = {}

        # Set up the dataset
        train_datagen = ImageDataGenerator(
            rescale=1./255,
            validation_split=float(training_params['validation_split']),
            **augmentation_params  # Using augmentation if any
        )
        train_generator = train_datagen.flow_from_directory(
            dataset_path_train,
            target_size=(150, 150),
            batch_size=int(training_params['batch_size']),
            class_mode='binary',
            subset='training'
        )

        validation_generator = train_datagen.flow_from_directory(
            dataset_path_train,
            target_size=(150, 150),
            batch_size=int(training_params['batch_size']),
            class_mode='binary',
            subset='validation'
        )

        test_datagen = ImageDataGenerator(rescale=1./255)
        test_generator = test_datagen.flow_from_directory(
            dataset_path_test,
            target_size=(150, 150),
            batch_size=int(training_params['batch_size']),
            class_mode='binary',
            shuffle=False
        )

        # Set up early stopping callback
        early_stopping = EarlyStopping(monitor='val_loss', 
                                    patience=int(training_params['early_stopping_patience']),
                                    restore_best_weights=True)

        # Train the model with the callback
        terminate_on_flag_callback = TerminateOnFlagCallback(training_params['training_job'].id)
        model.fit(train_generator, 
                epochs=int(training_params['epochs']), 
                validation_data=validation_generator, 
                callbacks=[early_stopping, terminate_on_flag_callback])

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
            training_params['training_job'].id,
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

