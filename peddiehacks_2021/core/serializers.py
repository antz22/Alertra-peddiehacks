from rest_framework import serializers

from .models import DummyModel

class DummyModelSerializer(serializers.ModelSerializer):
    class Meta:
        model = DummyModel
        fields = (
            'id',
        )