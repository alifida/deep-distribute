# Distributed Deep Learning Project

## Description
This project is designed to facilitate distributed deep learning across multiple GPU machines over a LAN. It employs data parallelism to enhance the training process of deep learning models. By distributing the computation across multiple nodes, the project aims to significantly reduce training time and handle larger datasets more efficiently.

## Features
- **Data Parallelism:** Utilizes multiple GPUs across different machines to parallelize the training.
- **Gradient Sharing:** Each node computes gradients locally and shares them with a central parameter server.
- **Parameter Server:** Aggregates gradients from all worker nodes, averages them, and distributes the updated gradients back to each node.
- **Synchronized Updates:** Ensures that each worker node updates its model parameters with the latest gradients from the parameter server before starting the next iteration.

## Installation
Clone the repository and install the necessary dependencies:
```bash
git clone https://silverlean2@bitbucket.org/silverlean2/deepdistribute.git
cd distributed-deep-learning
pip install -r requirements.txt
Setup
Cluster Configuration: Define your cluster in the configuration file, specifying the IP addresses and ports for each worker and the parameter server.
Running the Parameter Server: Start the parameter server on the designated machine to begin listening for gradient updates.
Starting Worker Nodes: Launch the training process on each worker node, ensuring they are configured to communicate with the parameter server.
Usage
To start the distributed training, run the following command on each worker node after setting up the parameter server:

bash
Copy code
python train.py --config config.json
Replace config.json with the path to your configuration file.

Contributing
We welcome contributions to this project. If you have suggestions or improvements, please fork the repository and submit a pull request.

License
This project is licensed under the MIT License - see the LICENSE.md file for details.