#!/bin/bash

python3 manage.py runserver 0.0.0.0:89 &
python3 manage.py qcluster &