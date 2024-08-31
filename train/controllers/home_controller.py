from django.shortcuts import render
from django.http import HttpResponse
import zipfile
import os
from django.conf import settings
from common.utils import util


def home(request):
    return  util.myrender(request, 'home.html', {}) 



    
