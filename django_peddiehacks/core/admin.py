from django.contrib import admin
from .models import User, DummyModel

admin.site.register(User)
admin.site.register(DummyModel)
