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
from django_q.tasks import async_task
import gc

from django.conf import settings
import os
import joblib
from train.models import TrainedModel



class TrainingServiceSingle:
    
    @staticmethod
    def is_gpu_available():
        from tensorflow.python.client import device_lib
        devices = device_lib.list_local_devices()
        return any([device.device_type == 'GPU' for device in devices])
    
    @staticmethod
    def release_gpu():
        import gc
        import tensorflow as tf
        # Clear GPU memory
        tf.keras.backend.clear_session()
        gc.collect()

    @staticmethod
    def start_training_process__old(job, model_name):
        process = Process(target=TrainingServiceSingle.start_training,args=(job, model_name,))
        process.start()
        #process.join()  # Optionally wait for the process to complete

    @staticmethod
    def start_training_process(training_params):
        print("before starting........")
         
        async_task(TrainingServiceSingle.start_training, training_params)
        #TrainingServiceSingle.start_training(training_params)
        print("after starting........")

    @staticmethod
    def start_training(training_params):
        if not TrainingServiceSingle.is_gpu_available():
            raise RuntimeError("GPU is not available for training right now. Please try again later.")
        else:
            TrainingServiceSingle.release_gpu();
            print(" GPU available.....................................")

        from train.models import Training_job
        from train.dao.TrainingJobDAO import TrainingJobDAO
        from tensorflow.keras.optimizers import Adam, SGD, RMSprop, Adadelta , Adagrad, Adamax, Nadam, Ftrl # Import other optimizers as needed

        try:
            # Extracting paths from training job
            dataset_path_train = training_params['training_job'].dataset_img.extracted_path
            dataset_path_test = training_params['training_job'].dataset_img.extracted_path_test
            ####################################################################################################

            # Set up the dataset
            if training_params['augmentation'] and training_params['augmentation'].lower() != 'none':
                augmentation_params = eval(training_params['augmentation'])
            else:
                augmentation_params = {}

            # Set up the dataset
            train_datagen = ImageDataGenerator(
                rescale=1. / 255,
                validation_split=float(training_params['validation_split']),
                **augmentation_params  # Using augmentation if any
            )

            train_generator = train_datagen.flow_from_directory(
                dataset_path_train,
                target_size=(150, 150),
                batch_size=int(training_params['batch_size']),
                class_mode='categorical',
                subset='training'
            )

            validation_generator = train_datagen.flow_from_directory(
                dataset_path_train,
                target_size=(150, 150),
                batch_size=int(training_params['batch_size']),
                class_mode='categorical',
                subset='validation'
            )

            test_datagen = ImageDataGenerator(rescale=1. / 255)

            test_generator = test_datagen.flow_from_directory(
                dataset_path_test,
                target_size=(150, 150),
                batch_size=int(training_params['batch_size']),
                class_mode='categorical',
                shuffle=False
            )
            # Get the number of classes
            num_classes = train_generator.num_classes
            ####################################################################################################
            # Dynamically load the model based on model_name
            base_model = KerasCatalogService.get_model_object(training_params['algo_name'])

            # Freeze the layers of the base model
            for layer in base_model.layers:
                layer.trainable = False

            # Add custom layers on top of the base model
            x = base_model.output
            x = GlobalAveragePooling2D()(x)
            x = Dense(num_classes, activation='softmax')(x)  # Assuming binary classification

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


            # # Set up early stopping callback
            # early_stopping = EarlyStopping(monitor='val_loss',
            #                             patience=int(training_params['early_stopping_patience']),
            #                             restore_best_weights=True)

            # Set up early stopping callback
            early_stopping = EarlyStopping(monitor='val_accuracy',
                                           patience=int(training_params['early_stopping_patience']),
                                           restore_best_weights=True,
                                           mode='max')

            # Train the model with the callback
            terminate_on_flag_callback = TerminateOnFlagCallback(training_params['training_job'].id)
            model.fit(train_generator, 
                    epochs=int(training_params['epochs']), 
                    validation_data=validation_generator, 
                    callbacks=[early_stopping, terminate_on_flag_callback])

            model_id = TrainingServiceSingle.save_model(model, training_params)

            # Predictions on test set
            #####predictions = model.predict(test_generator)

            # Calculate metrics
            ####actual_labels = test_generator.classes
            ###binary_predictions = (predictions > 0.5).astype(int).flatten()

            # accuracy = tf.keras.metrics.BinaryAccuracy()(actual_labels, binary_predictions).numpy()
            # precision = tf.keras.metrics.Precision()(actual_labels, binary_predictions).numpy()
            # recall = tf.keras.metrics.Recall()(actual_labels, binary_predictions).numpy()
            # auc = tf.keras.metrics.AUC()(actual_labels, binary_predictions).numpy()
            # f1 = f1_score(actual_labels, binary_predictions)

            from sklearn.metrics import accuracy_score, precision_score, recall_score, roc_auc_score, f1_score

            # Predictions on test set
            predictions = model.predict(test_generator)

            # Calculate metrics
            actual_labels = test_generator.classes
            # Use argmax to get predicted class labels for multiclass
            predicted_classes = predictions.argmax(axis=1)

            # Compute metrics using scikit-learn
            accuracy = accuracy_score(actual_labels, predicted_classes)
            precision = precision_score(actual_labels, predicted_classes, average='weighted')  # Use 'weighted' for multiclass
            recall = recall_score(actual_labels, predicted_classes, average='weighted')
            # For AUC, use probabilities (only for the positive class, if binary) or a one-vs-rest approach for multiclass
            auc = roc_auc_score(test_generator.classes, predictions,
                                multi_class='ovr')  # One-vs-Rest AUC for multiclass
            f1 = f1_score(actual_labels, predicted_classes, average='weighted')  # Use 'weighted' for multiclass

            # Print metrics
            print(f"Accuracy: {accuracy}")
            print(f"Precision: {precision}")
            print(f"Recall: {recall}")
            print(f"AUC: {auc}")
            print(f"F1 Score: {f1}")

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
        except ImportError as e:
            print(f"An unexpected error occurred: {e}")
        finally:
            TrainingServiceSingle.release_gpu()
            print('Training completed and GPU memory released.')


    @staticmethod
    def save_model(model, params):
        """
        Save the trained model to a file using joblib and store the metadata in the database.
        
        :param model: The trained model object.
        :param params: Dictionary containing parameters including 'user_id', 'dataset_id', and 'algo_name'.
        """

        # Construct the file path and ensure the directory exists
        user_id = params.get('user').id
        dataset_id = params.get('dataset_id')
        algo_name = params.get('algo_name')
        
        directory = os.path.join(settings.MEDIA_ROOT, str(user_id), 'trained_models','images', str(dataset_id))
        if not os.path.exists(directory):
            os.makedirs(directory)

        file_name = f"{algo_name}.h5"  # File name based on the algorithm name
        file_path = os.path.join(directory, file_name)

        try:
            # Save the model to the file
            model.save(file_path)
            print(f"Model saved successfully to {file_path}")
            dataset_img = params['training_job'].dataset_img
            stats = dataset_img.gather_dataset_stats()
            # Create and save the TrainedModel object
            trained_model = TrainedModel(
                model_file=os.path.relpath(file_path, settings.MEDIA_ROOT),  # Store the relative path
                description=f"{params.get('algo_name')}",
                status='Temp',
                user_id=user_id,
                dataset_img_id=dataset_id,
                
                class_label = stats['train']['class_names']
            )
            trained_model.save()
            print("TrainedModel saved to the database successfully.")
            return trained_model.id
            
        except Exception as e:
            print(f"Error saving model: {str(e)}")
            return 0
    




class TerminateOnFlagCallback(Callback):
    def __init__(self, job_id):
        super().__init__()
        self.job_id = job_id

    def on_epoch_end(self, epoch, logs=None):
        training_job = TrainingJobDAO.get(self.job_id)
        
        # Append new log to the history
        history = json.loads(training_job.training_log_history) if training_job.training_log_history else []
        history.append({'epoch': epoch + 1, 'logs': logs})
        
        # Update current epoch log and full history
        TrainingJobDAO.update(
            self.job_id,
            status=JobStatus.RUNNING.value,
            training_log=json.dumps({'epoch': epoch + 1, 'logs': logs}),  # Store current epoch log
            training_log_history=json.dumps(history)  # Store full log history
        )
        
        # Stop if the job status is no longer running
        if training_job.status != JobStatus.RUNNING.value:
            self.model.stop_training = True
            print(f"Stopping training at the end of epoch {epoch}")


