from django.shortcuts import render

from rest_framework import status, authentication, permissions
from rest_framework.decorators import api_view, authentication_classes,permission_classes
from django.views.decorators.csrf import csrf_exempt
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import Report, ReportSearchResult, ReportType, Alert, School
from .serializers import ReportSerializer, ReportTypeSerializer, AlertSerializer, SchoolSerializer, ReportSearchResultSerializer

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

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains
import time
import csv
from urllib.parse import urlparse
import os




def index(request):
    pass


class ReportList(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        reports = Report.objects.all()
        serializer = ReportSerializer(reports, many=True)
        return Response(serializer.data)


class ReportTypeList(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        report_types = ReportType.objects.all()
        serializer = ReportTypeSerializer(report_types, many=True)
        return Response(serializer.data)


# class ReportSearchResultList(APIView):
#     authentication_classes = [authentication.TokenAuthentication]
#     permission_classes = [permissions.IsAuthenticated]

#     def get(self, request, format=None):
#         report_search_results = ReportSearchResult.objects.filter(user=request.user)
#         serializer = ReportSearchResultSerializer(report_search_results, many=True)
#         return Response(serializer.data)


class AlertList(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        alerts = Alert.objects.filter(recipient=request.user.role)
        serializer = AlertSerializer(alerts, many=True)
        return Response(serializer.data)


# class SchoolList(APIView):
#     authentication_classes = [authentication.TokenAuthentication]
#     permission_classes = [permissions.IsAuthenticated]

#     def get(self, request, format=None):
#         schools = School.objects.filter(user=request.user)
#         serializer = SchoolSerializer(schools, many=True)
#         return Response(serializer.data)


def webscrape(town, incident):
	os.environ['MOZ_HEADLESS'] = '1'
	driver = webdriver.Firefox()

	# driver = webdriver.PhantomJS('C:\Users\Prineet Singh\Desktop\searchschoolandincident\phantomjs-1.9.7-windows\phantomjs.exe')

	driver.get("google.com")
	driver.find_element_by_xpath('/html/body/div[1]/div[3]/form/div[1]/div[1]/div[1]/div/div[2]/input').send_keys(town + incident)  # class is a4bIc
	
	results = driver.find_elements_by_css_selector('div.g')
	link1 = results[0].find_element_by_tag_name("a")
	link2 = results[1].find_element_by_tag_name("a")
	link3 = results[2].find_element_by_tag_name("a")
	href1 = link1.get_attribute("href")
	href2 = link2.get_attribute("href")
	href3 = link3.get_attribute("href")

	driver.close()

	return urlparse.parse_qs(urlparse.urlparse(href1).query)["q"], urlparse.parse_qs(urlparse.urlparse(href2).query)["q"], urlparse.parse_qs(urlparse.urlparse(href3).query)["q"]



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
    priority = data['priority']
    picture = data['picture']
    school_name = data['school_name']
    school = School.objects.get(name=school_name)

    new_report = Report.objects.create(user=user, description=description, location=location, report_type=report_type, priority=priority, picture=picture, school=school)
    new_report.save()
    
    url1, url2, url3 = webscrape(school.city, report_type)
    new_search1 = ReportSearchResult.objects.create(report=new_report.id, url=url1)
    new_search1.save()
    new_search2 = ReportSearchResult.objects.create(report=new_report.id, url=url2)
    new_search2.save()
    new_search3 = ReportSearchResult.objects.create(report=new_report.id, url=url3)
    new_search3.save()


    # qstSearches = new_report.search_results
    # serializer = ReportSearchResultSerializer(qstSearches, many=True)

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
    school_name = data['school_name']
    school = School.objects.get(name=school_name)


    new_alert = Report.objects.create(user=user, head_line=head_line, content=content, recipient=recipient, school=school)
    new_alert.save()


    return Response(status=status.HTTP_201_CREATED)


@api_view(['POST'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def createSchool(request):

    data = request.data
    user = request.user

    name = data['name']
    address = data['address']
    city = data['city']


    new_alert = Report.objects.create(user=user, name=name, address=address)
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
