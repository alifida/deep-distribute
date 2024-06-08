import os
import json
import tensorflow as tf
from tensorflow.keras.layers import Dense, Flatten
from tensorflow.keras import Model

os.environ["TF_CONFIG"] = json.dumps({
    "cluster": {
        "worker": ["192.168.100.109111:2222"],
        "ps": ["192.168.100.109111:2223"]
    },
    "task": {"type": "worker", "index": 0}
})


def start_worker_training():
    print("(((((((((((((((((((((((((((())))))))))))))))))))))))))))")
    # Initialize the cluster resolver
    cluster_resolver = tf.distribute.cluster_resolver.TFConfigClusterResolver()

    # Define the ParameterServerStrategy with the cluster resolver
    strategy = tf.distribute.experimental.ParameterServerStrategy(cluster_resolver)

    tf.get_logger().setLevel('INFO')
    # Set TF_CONFIG environment for the worker
    os.environ["TF_CONFIG"] = json.dumps({
        "cluster": {
            "worker": ["192.168.100.109111:2222"],
            "ps": ["192.168.100.109111:2223"]
        },
        "task": {"type": "worker", "index": 0}
    })

    strategy = tf.distribute.experimental.ParameterServerStrategy()


    train_dataset = load_dataset().batch(10)

    with strategy.scope():
        # Define a simple Sequential model
        model = tf.keras.Sequential([
            Flatten(input_shape=(224, 224, 3)),
            Dense(128, activation='relu'),
            Dense(1, activation='sigmoid')  # Binary classification
        ])
        model.compile(loss=tf.keras.losses.BinaryCrossentropy(),
                    optimizer=tf.keras.optimizers.Adam(),
                    metrics=['accuracy'])

    # Train the model
    model.fit(train_dataset, epochs=10)

def decode_image(image_file):
    image = tf.io.decode_jpeg(image_file, channels=3)  # Decode JPEG image
    image = tf.image.resize(image, [224, 224])  # Resize to the expected input size
    image /= 255.0  # Normalize to range [0, 1]
    return image

def process_path(file_path):
    label = tf.strings.split(file_path, os.path.sep)[-2]  # Assuming directory name is the label
    label = tf.where(label == 'patient', 1, 0)  # Convert label to binary (0 for normal, 1 for patient)
    image = tf.io.read_file(file_path)
    image = decode_image(image)
    return image, label

def load_dataset():
    data_dir = tf.data.Dataset.list_files("E:\\dataset\\tb_dataset_tiny\\*\\*.png", shuffle=False)
    data_dir = data_dir.map(process_path, num_parallel_calls=tf.data.AUTOTUNE)
    return data_dir