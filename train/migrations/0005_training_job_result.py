# Generated by Django 3.1.2 on 2024-06-22 07:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('train', '0004_clusternode'),
    ]

    operations = [
        migrations.AddField(
            model_name='training_job',
            name='result',
            field=models.TextField(null=True),
        ),
    ]