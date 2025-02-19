#!/bin/bash

# Start Django server
python3 manage.py runserver 0.0.0.0:89 &

# Start Django Q cluster in the background
python3 manage.py qcluster &
