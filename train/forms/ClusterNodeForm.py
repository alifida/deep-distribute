# train/forms/ClusterNodeForm.py

from django import forms
from train.models import ClusterNode

class ClusterNodeForm(forms.ModelForm):
    class Meta:
        model = ClusterNode
        fields = ['node_type', 'ip_address', 'port']
        widgets = {
            'node_type': forms.Select(attrs={'class': 'form-control'}),
            'ip_address': forms.TextInput(attrs={'class': 'form-control'}),
            'port': forms.NumberInput(attrs={'class': 'form-control'}),
        }
