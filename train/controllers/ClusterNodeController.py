# train/controllers/ClusterNodeController.py

from django.http import HttpResponse
from django.shortcuts import redirect
from django.contrib.auth.decorators import login_required
from train.services.ClusterNodeService import ClusterNodeService
from train.forms.ClusterNodeForm import ClusterNodeForm
from common.utils import util
from django.contrib import messages

@login_required
def list(request):
    nodes = ClusterNodeService.list()
    return util.render(request, 'cluster/list.html', {'nodes': nodes})

@login_required
def create(request):
    if request.method == "POST":
        form = ClusterNodeForm(request.POST)
        if form.is_valid():
            node_type = form.cleaned_data['node_type']
            ip_address = form.cleaned_data['ip_address']
            port = form.cleaned_data['port']
            ClusterNodeService.create(node_type=node_type, ip_address=ip_address, port=port)
            messages.success(request, "Node Created successfully.")
            return redirect('list_cluster_nodes')
    else:
        form = ClusterNodeForm()
    return util.render(request, 'cluster/create.html', {'form': form})

@login_required
def edit(request, node_id):
    node = ClusterNodeService.get(node_id)
    if request.method == 'POST':
        form = ClusterNodeForm(request.POST, instance=node)
        if form.is_valid():
            ClusterNodeService.update(node_id, **form.cleaned_data)
            messages.success(request, "Node Updated successfully.")
            return redirect('list_cluster_nodes')
    else:
        form = ClusterNodeForm(instance=node)
    return util.render(request, 'cluster/create.html', {'form': form, 'node': node})


@login_required
def view(request, node_id):
    node = ClusterNodeService.get(node_id)  #  
    form = ClusterNodeForm(instance=node)  # 
    return util.render(request, 'cluster/view.html', {'form': form, 'node': node})







@login_required 
def delete_confirm(request, node_id):
    node = ClusterNodeService.get(node_id)  # Use service to fetch the node
    form = ClusterNodeForm(instance=node)  # Form for display purposes only, if needed
    return util.render(request, 'cluster/delete.html', {'form': form, 'node': node})


@login_required
def delete(request, node_id):
    if request.method == 'POST':
        ClusterNodeService.delete(node_id)
        messages.success(request, "Node Deleted successfully.")
        return redirect('list_cluster_nodes')
    else:
        return HttpResponse("Method Not Allowed", status=405)
