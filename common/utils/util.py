 
import os
import json
from django.core.files.storage import default_storage
from django.db.models import FileField
import csv
#from django.shortcuts import render, redirect
from json import JSONEncoder
import numpy
from decimal import Decimal
from django import shortcuts 
import secrets
import string
from datetime import datetime
import logging

import zipfile
import tempfile

 
from django.conf import settings

from django.shortcuts import  get_object_or_404


def get_object_or_404(klass, *args, **kwargs):
    return  shortcuts.get_object_or_404(klass, *args, **kwargs);
    
def redirect(to, *args, permanent=False, **kwargs):
     
        
    return shortcuts.redirect(to, *args, permanent=permanent, **kwargs)

def render(request, template, data=None, content_type=None, status=None, using=None):
    print("util.............................render()")
     
    data["parentTemplate"] = "base.html"
    if "rt" in request.GET:
        print(request.GET["rt"])
        data["parentTemplate"] = "ajax.html"
    
    
    return shortcuts.render(request, template, data, content_type=content_type, status=status, using=using)
'''
def add_server_messages(request, message):
    messages = request.session.get('messages', None)
    if messages == None:
        messages ={}
    
    messages[get_unique_string()] = message
    request.session['messages'] = messages


def prepare_message(message, status="info"):
    message = {}
    message['status'] = status
    message['message'] = message
    return message;





def add_to_session(request, name, value):
    """
    Add data to session
    """
    return 

'''
def get_unique_string():
    """
        Get Unique string by concatinating Random String of lenght 10 and current timestamp
    """
    random_string = get_random_string()
    timestamp = get_current_time();
    result = f"{random_string}_{timestamp}"
    return result

def get_current_time(format="%Y%m%d%H%M%S"):
    
    """
        Get the current timestamp
    """
    return datetime.now().strftime(format) 

def get_random_string(length=10):
    """
        Generate a secure random string of the given length
    """
    return ''.join(secrets.choice(string.ascii_letters + string.digits) for _ in range(length));
 
class NumpyArrayEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, numpy.ndarray):
            return obj.tolist()
        if isinstance(obj, Decimal):
            return (str(obj) for obj in [obj])
        return JSONEncoder.default(self, obj)


class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        if isinstance(obj, numpy.ndarray):
            return obj.tolist()
        return json.JSONEncoder.default(self, obj)

def tojson(obj):
    json_str = json.dumps(obj, cls=DecimalEncoder).replace('Nan', "0")
    json_str = json_str.replace("NaN", "0", )
    
    
    return json_str


def extract_zip_to_temp(zip_file_path):
    # Ensure the zip file exists
    if not os.path.exists(zip_file_path):
        raise FileNotFoundError(f"The file {zip_file_path} does not exist.")

    # Create a temporary directory
    temp_dir = tempfile.mkdtemp()
    
    # Extract the zip file into the temporary directory
    with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
        zip_ref.extractall(temp_dir)

    return temp_dir


def extract_zip_to_shared_loc(zip_file, dataset_id):
    logging.debug(f"Checking existence of zip file: {zip_file}")
    if not os.path.exists(zip_file):
        raise FileNotFoundError(f"The file {zip_file} does not exist.")

    shared_directory = settings.SHARED_DIRECTORY
    dataset_directory = os.path.join(shared_directory, str(dataset_id))
    
    logging.debug(f"Creating dataset directory: {dataset_directory}")
    if os.path.exists(shared_directory):
        return dataset_directory
    else:
        os.makedirs(dataset_directory, exist_ok=True)

    try:
        logging.debug(f"Extracting zip file: {zip_file} to {dataset_directory}")
        with zipfile.ZipFile(zip_file, 'r') as zip_ref:
            zip_ref.extractall(dataset_directory)
    except zipfile.BadZipFile:
        raise Exception("Failed to extract the ZIP file: it may be corrupted.")
    except Exception as e:
        raise Exception(f"An error occurred during extraction: {str(e)}")
     
    return dataset_directory

def path_exist(path):
    return os.path.exists(path)