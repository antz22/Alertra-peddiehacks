from django.contrib.auth.models import AbstractUser
from django.db import models


class School(models.Model):
    name = models.CharField(max_length=128)
    address = models.CharField(max_length=128)
    city = models.CharField(max_length=128)

class User(AbstractUser):
    role = models.CharField(max_length=64),
    school = models.ForeignKey(School, on_delete=models.CASCADE)

class ReportType(models.Model):
    name = models.CharField(max_length=128)

class Report(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="reports")
    description = models.CharField(max_length=64, null=True, blank=True)
    location = models.CharField(max_length=64, null=True, blank=True)
    report_type = models.ForeignKey(ReportType, on_delete=models.CASCADE, null=True, blank=True)
    severity = models.IntegerField(default=0)
    picture = models.ImageField(upload_to='uploads/', null=True, blank=True)
    school = models.ForeignKey(School, on_delete=models.CASCADE)

class ReportSearchResult(models.Model):
    report = models.ForeignKey(Report, on_delete=models.CASCADE)
    url = models.URLField(max_length=200)

class Alert(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="alerts")
    head_line = models.CharField(max_length=64, null=True, blank=True)
    content = models.CharField(max_length=128)
    recipient = models.CharField(max_length=64)
    school = models.ForeignKey(School, on_delete=models.CASCADE)

