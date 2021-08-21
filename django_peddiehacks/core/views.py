from django.shortcuts import render

from rest_framework import status, authentication, permissions
from rest_framework.decorators import api_view, authentication_classes,permission_classes
from django.views.decorators.csrf import csrf_exempt
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import Report, ReportType, Alert
from .serializers import ReportSerializer, ReportTypeSerializer, AlertSerializer

# import tensorflow as tf
# from tensorflow import keras
# from tensorflow.keras import layers
# from keras.models import Sequential
# from keras.layers import Dense
# from keras.models import model_from_json
# import numpy
# import os
# import sys
# sys.path.append('C:\\Users\\suchi\\Dropbox (Sandipan.com)\\Creative\\RitiCode\\PeddieHacks 2021\\peddiehacks_2021\\extras')
# import predicting



def index(request):
    pass


class ReportList(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        reports = Report.objects.filter(user=request.user)
        serializer = ReportSerializer(reports, many=True)
        return Response(serializer.data)

class ReportTypeList(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        report_types = ReportType.objects.filter(user=request.user)
        serializer = ReportTypeSerializer(report_types, many=True)
        return Response(serializer.data)

class AlertList(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        alerts = Alert.objects.filter(user=request.user)
        serializer = AlertSerializer(alerts, many=True)
        return Response(serializer.data)


@api_view(['POST'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def createReport(request):

    data = request.data
    user = request.user

    description = data['description']
    location = data['location']
    report_type_name = data['report_type_name']
    report_type = ReportType.objects.get(name=report_type_name)
    severity = data['severity']
    picture = data['picture']


    new_report = Report.objects.create(user=user, description=description, location=location, report_type=report_type, severity=severity, picture=picture)
    new_report.save()


    return Response(status=status.HTTP_201_CREATED)

@api_view(['POST'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def createAlert(request):

    data = request.data
    user = request.user

    head_line = data['head_line']
    content = data['content']
    recipient = data['recipient']


    new_alert = Report.objects.create(user=user, head_line=head_line, content=content, recipient=recipient)
    new_alert.save()


    return Response(status=status.HTTP_201_CREATED)

'''
@api_view(['POST'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def imagePrediction(request):
    data = request.data
    strImagePath = data['strImagePath']

    image_size = (150, 150)
    strModelPath = 'C:\\Users\\suchi\\Dropbox (Sandipan.com)\\Creative\\RitiCode\\Image Recognition Experiment\\afhq_model-1629321815.json'
    strWeightsPath = 'C:\\Users\\suchi\\Dropbox (Sandipan.com)\\Creative\\RitiCode\\Image Recognition Experiment\\afhq_model-1629321815.h5'
    strDatasetPath = 'C:\\Users\\suchi\\Dropbox (Sandipan.com)\\Creative\\RitiCode\\Image Recognition Experiment\\afhq\\train'

    objFinalModel = predicting.TrainedModel(strImagePath, image_size, strModelPath, strWeightsPath, strDatasetPath)
    objFinalModel.fnLoadAndCompile()
    return objFinalModel.fnPredict()
'''
