from django.contrib.auth.models import AbstractUser
from django.db import models


class School(models.Model):
    name = models.CharField(max_length=128)
    address = models.CharField(max_length=128)
    city = models.CharField(max_length=128)

    def __str__(self):
        return f"{self.name}"


class User(AbstractUser):
    # teacher, student
    role = models.CharField(max_length=64, null=True, blank=True),
    school = models.ForeignKey(School, on_delete=models.CASCADE, null=True, blank=True)


class ReportType(models.Model):
    name = models.CharField(max_length=128)

    def __str__(self):
        return f"{self.name}"


class Report(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='reports')
    description = models.CharField(max_length=64, null=True, blank=True)
    location = models.CharField(max_length=64, null=True, blank=True)
    report_type = models.ForeignKey(ReportType, on_delete=models.CASCADE, null=True, blank=True)
    # low, medium, high
    priority = models.CharField(max_length=64, default='low')
    picture = models.ImageField(upload_to='uploads/', null=True, blank=True)
    school = models.ForeignKey(School, on_delete=models.CASCADE)
    time = models.DateTimeField(auto_now_add=True, null=True, blank=True)

    def __str__(self):
        return f"{self.priority} priority report"

    def get_picture(self):
        if self.image:
            return 'http://127.0.0.1:8000' + self.image.url
        return ''


class ReportSearchResult(models.Model):
    report = models.ForeignKey(Report, on_delete=models.CASCADE, related_name='search_results')
    url = models.URLField(max_length=200)


class Alert(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='alerts')
    # low, medium, high
    priority = models.CharField(max_length=64, default='low')
    head_line = models.CharField(max_length=64, null=True, blank=True)
    content = models.CharField(max_length=128)
    # teacher, student, all
    recipient = models.CharField(max_length=64)
    school = models.ForeignKey(School, on_delete=models.CASCADE)
    time = models.DateTimeField(auto_now_add=True, null=True, blank=True)
    linked_report = models.ForeignKey(Report, on_delete=models.CASCADE, null=True, blank=True)

    def __str__(self):
        return f"{self.head_line}"
