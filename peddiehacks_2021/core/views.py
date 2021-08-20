from django.shortcuts import render

from rest_framework import status, authentication, permissions
from rest_framework.decorators import api_view, authentication_classes,permission_classes
from django.views.decorators.csrf import csrf_exempt
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import DummyModel
from .serializers import DummyModelSerializer

import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from keras.models import Sequential
from keras.layers import Dense
from keras.models import model_from_json
import numpy
import os
import sys
sys.path.append('C:\\Users\\suchi\\Dropbox (Sandipan.com)\\Creative\\RitiCode\\PeddieHacks 2021\\peddiehacks_2021\\extras')
import predicting



def index(request):
    pass


class DummyModelList(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        dummy_models = DummyModel.objects.filter(user=request.user)
        serializer = DummyModelSerializer(dummy_models, many=True)
        return Response(serializer.data)


@api_view(['POST'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def createDummyModel(request):

    data = request.data

    name = data['name']
    dummy_field = data['dummy_field']

    new_dummy_model = DummyModel.objects.create(user=user, name=name, dummy_field=dummy_field)
    new_dummy_model.save()


    return Response(status=status.HTTP_201_CREATED)