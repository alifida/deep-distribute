#!/bin/bash

# Set NODE_TYPE environment variable and start TensorFlow server
export NODE_TYPE=ps
python3 manage.py start_tf_server
