from django.shortcuts import render
from django.shortcuts import redirect
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import Group
from uac.models import Group_config


'''
from django.urls import reverse

return redirect(reverse('profile', kwargs={"user_id": userid}))
'''


# Create your views here.
@login_required
def welcome(request):
    redirect_url ='home'
    userpk = request.user.id
    groups  = request.user.groups.all()
    if groups and groups.first():
        group = groups.first()
        config = Group_config.objects.filter(group = group)
        if config :
            redirect_url = config[0].welcome_url
     
    return redirect(redirect_url)