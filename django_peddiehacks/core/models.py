from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
	pass


class DummyModel(models.Model):
    dummyField = models.CharField(max_length=64)