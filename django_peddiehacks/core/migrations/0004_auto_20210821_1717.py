# Generated by Django 3.2.6 on 2021-08-21 17:17

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0003_auto_20210821_0023'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='report',
            name='severity',
        ),
        migrations.AddField(
            model_name='alert',
            name='linked_report',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='core.report'),
        ),
        migrations.AddField(
            model_name='alert',
            name='priority',
            field=models.CharField(default='low', max_length=64),
        ),
        migrations.AddField(
            model_name='alert',
            name='time',
            field=models.DateTimeField(auto_now_add=True, null=True),
        ),
        migrations.AddField(
            model_name='report',
            name='isEmergency',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='report',
            name='priority',
            field=models.CharField(default='low', max_length=64),
        ),
        migrations.AddField(
            model_name='report',
            name='time',
            field=models.DateTimeField(auto_now_add=True, null=True),
        ),
        migrations.AlterField(
            model_name='reportsearchresult',
            name='report',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='search_results', to='core.report'),
        ),
    ]
