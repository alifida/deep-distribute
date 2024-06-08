from django.http import JsonResponse
from train.models import ClusterNode

def cluster_nodes_json(request):
    # Query all nodes from the database
    nodes = ClusterNode.objects.all()
    
    # Construct the JSON data structure
    data = {
        "worker": [],
        "ps": []
    }
    
    # Populate the lists based on node_type
    for node in nodes:
        if node.node_type == "worker":
            data["worker"].append(f"{node.ip_address}:{node.port}")
        elif node.node_type == "ps":
            data["ps"].append(f"{node.ip_address}:{node.port}")
    
    # Return a JsonResponse with the constructed data
    return JsonResponse(data)
