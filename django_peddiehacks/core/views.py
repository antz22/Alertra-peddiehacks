from django.shortcuts import render

from rest_framework import status, authentication, permissions
from rest_framework.decorators import api_view, authentication_classes,permission_classes
from django.views.decorators.csrf import csrf_exempt
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import Report, ReportSearchResult, ReportType, Alert, School, Source, KeyWord
from .serializers import ReportSerializer, ReportTypeSerializer, AlertSerializer, UserDataSerializer, SchoolSerializer

import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt
from sklearn.feature_extraction import text
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.cluster import KMeans
from nltk.tokenize import RegexpTokenizer
from nltk.stem.snowball import SnowballStemmer

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
import csv

from pygooglenews import GoogleNews

# Creating the lists of the django models

class ReportList(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        reports = Report.objects.all()
        serializer = ReportSerializer(reports, many=True)
        return Response(serializer.data)


class SchoolList(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        schools = School.objects.all()
        serializer = SchoolSerializer(schools, many=True)
        return Response(serializer.data)


class ReportTypeList(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        report_types = ReportType.objects.all()
        serializer = ReportTypeSerializer(report_types, many=True)
        return Response(serializer.data)


class AlertList(APIView):
    authentication_classes = [authentication.TokenAuthentication]
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, format=None):
        alerts = Alert.objects.filter(recipient=request.user.role)
        serializer = AlertSerializer(alerts, many=True)
        return Response(serializer.data)


# webscraper function to find report search results
def webscrape(town, incident):
    os.environ['MOZ_HEADLESS'] = '1'
    driver = webdriver.Firefox()

    driver.get("https://www.google.com/")
    driver.find_element_by_xpath('/html/body/div[1]/div[3]/form/div[1]/div[1]/div[1]/div/div[2]/input').send_keys(town + ' ' + incident + Keys.ENTER)

    driver.implicitly_wait(20)

    allLinks = driver.find_elements_by_class_name('yuRUbf')
    link1 = allLinks[0].find_element_by_tag_name("a")
    link2 = allLinks[1].find_element_by_tag_name("a")
    link3 = allLinks[2].find_element_by_tag_name("a")
    href1 = link1.get_attribute("href")
    href2 = link2.get_attribute("href")
    href3 = link3.get_attribute("href")

    driver.close()

    print(href1, href2, href3)
    print(allLinks)

    return (href1, href2, href3)

# function to create csv datasets with search headlines for kmeans clustering
def createData(filePath, headlines):
    with open(filePath, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["index", "headline_text"])
        for index, headline in enumerate(headlines):
            writer.writerow([index, headline])


# Find safety related news for given city and state from Google News
def findSafetyNews(strCity, strState):
    gn = GoogleNews()
    strSafetyIndicators = "danger"
    foundNews = gn.search(strCity + " " + strState + " " + strSafetyIndicators)
    lstArticles = foundNews['entries']
    lstReturnNews = []
    lstReturnSources = []
    for dicItem in lstArticles:
        lstReturnNews.append(dicItem['title'])
        lstReturnSources.append(dicItem['links'][0]['href'])
    return lstReturnNews, lstReturnSources

def findSource(word, headlines, sources):
    for intCtr, headline in enumerate(headlines):
        if word in headline.lower():
            return sources[intCtr]


# function to initialize the User model
@api_view(['POST'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def createUser(request):

    data = request.data
    user = request.user

    role = data['role']
    school = data['school']

    user.school = School.objects.get(name=school)
    user.role = role
    user.save()

    return Response(status=status.HTTP_200_OK)


# function to retrieve data from the User model fields
@api_view(['GET'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def getUserData(request):

    user = request.user

    return Response({
        'role': user.role,
        'school': user.school.name,
        'username': user.username,
    })


# function to retrieve data from the User model fields
@api_view(['GET'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def getSchoolData(request):

    user = request.user
    school = user.school

    serializer = SchoolSerializer(school)
    return Response(serializer.data)


# function to initialize the Report model
@api_view(['POST'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def createReport(request):

    data = request.data
    user = request.user
    school = user.school

    try:
        # see if the report has the 'description'
        location = data['location']
        priority = data['priority']
        description = data['description']
        report_type_name = data['report_type_name']
        picture = data['picture']
        report_type = ReportType.objects.get(name=report_type_name)

        new_report = Report.objects.create(user=user, description=description, location=location, priority=priority, school=school, report_type=report_type, picture=picture)
    except: 
        # if it doesn't it is an emergency report with only the report type and a default of high priority
        description = data['description']
        report_type_name = data['report_type_name']
        report_type = ReportType.objects.get(name=report_type_name)
        priority = 'high'

        new_report = Report.objects.create(user=user, report_type=report_type, priority=priority, school=school, description=description)


    new_report.save()
    
    try:
        url1, url2, url3 = webscrape(school.city, report_type)
    except: 
        url1, url2, url3 = webscrape(school.city, description)

    new_search1 = ReportSearchResult.objects.create(report=new_report, url=url1)
    new_search1.save()
    new_search2 = ReportSearchResult.objects.create(report=new_report, url=url2)
    new_search2.save()
    new_search3 = ReportSearchResult.objects.create(report=new_report, url=url3)
    new_search3.save()

    return Response(status=status.HTTP_201_CREATED)


@api_view(['POST'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def getReportData(request):

    report_id = request.data['report_id']
    report = Report.objects.get(id=report_id)
    serializer = ReportSerializer(report)

    return Response(serializer.data)




# function to initialize the Alert model
@api_view(['POST'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def createAlert(request):

    data = request.data
    user = request.user

    head_line = data['headline']
    content = data['content']
    recipient = data['recipient']
    report_id = data['report_id']
    school = School.objects.get(name=user.school.name)
    report = Report.objects.get(id=report_id)

    if recipient == 'All':
        new_alert = Alert.objects.create(user=user, head_line=head_line, content=content, recipient='Teacher', school=school, linked_report=report)
        new_alert = Alert.objects.create(user=user, head_line=head_line, content=content, recipient='Student', school=school, linked_report=report)
    elif recipient == 'Teachers':
        new_alert = Alert.objects.create(user=user, head_line=head_line, content=content, recipient='Teacher', school=school, linked_report=report)
    elif recipient == 'Students':
        new_alert = Alert.objects.create(user=user, head_line=head_line, content=content, recipient='Student', school=school, linked_report=report)


    new_alert.save()


    return Response(status=status.HTTP_201_CREATED)


# function to initialize the School model
@api_view(['POST'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def createSchool(request):

    data = request.data
    user = request.user

    name = data['name']
    address = data['address']
    city = data['city']
    state = data['state']

    new_school = School.objects.create(name=name, address=address, city=city, state=state)
    new_school.save()
    
    filePath = os.path.join('django_peddiehacks\\extras\\datasets', name + '.csv')
    headlines, sources = findSafetyNews(city, state)

    createData(filePath, headlines)

    # Following code is for clustering to find the most frequent types of safety issues in a school's city
    data = pd.read_csv("C:\\Users\\suchi\\Dropbox (Sandipan.com)\\Creative\\RitiCode\\PeddieHacks 2021\\django_peddiehacks\\extras\\datasets\\{}.csv".format(name), error_bad_lines=False, usecols =["headline_text"])
    print(data.head())

    # Dictionary of words indicating danger in news articles
    dicDangerWords = {
        'weapons': ['gun', 'shooting', 'rifle', 'shoot', 'weapon'],
        'assault': ['beating', 'assault', 'beat', 'harm', 'hurt', 'bleeding'],
        'drugs': ['narcotic', 'drug', 'cannabis', 'opium', 'opioid', 'marijuana', 'cocaine', 'weed'],
        'storm': ['weather', 'tornado', 'hurricane', 'storm']
    }

    # Deleting duplicate headlines (if any)
    data[data['headline_text'].duplicated(keep=False)].sort_values('headline_text').head(8)
    data = data.drop_duplicates('headline_text')

    # NLP:
    punc = ['.', ',', '"', "'", '?', '!', ':', ';', '(', ')', '[', ']', '{', '}',"%"]
    stop_words = text.ENGLISH_STOP_WORDS.union(punc)
    desc = data['headline_text'].values
    vectorizer = TfidfVectorizer(stop_words = stop_words)
    X = vectorizer.fit_transform(desc)

    word_features = vectorizer.get_feature_names()
    print(len(word_features))
    print(word_features[5000:5100])

    # Tokenizing
    stemmer = SnowballStemmer('english')
    tokenizer = RegexpTokenizer(r'[a-zA-Z\']+')

    def tokenize(text):
        return [stemmer.stem(word) for word in tokenizer.tokenize(text.lower())]

    # Vectorization with stop words(words irrelevant to the model), stemming and tokenizing
    vectorizer2 = TfidfVectorizer(stop_words = stop_words, tokenizer = tokenize)
    X2 = vectorizer2.fit_transform(desc)
    word_features2 = vectorizer2.get_feature_names()
    print(len(word_features2))
    print(word_features2[:50]) 

    vectorizer3 = TfidfVectorizer(stop_words = stop_words, tokenizer = tokenize, max_features = 1000)
    X3 = vectorizer3.fit_transform(desc)
    words = vectorizer3.get_feature_names()

    # K-means clustering
    from sklearn.cluster import KMeans
    wcss = []
    for i in range(1,11):
        kmeans = KMeans(n_clusters=i,init='k-means++',max_iter=300,n_init=10,random_state=0)
        kmeans.fit(X3)
        wcss.append(kmeans.inertia_)

    print(words[250:300])

    # 2 clusters
    kmeans = KMeans(n_clusters = 3, n_init = 20, n_jobs = 1) # n_init(number of iterations for clsutering) n_jobs(number of cpu cores to use)
    kmeans.fit(X3)
    # We look at the 2 clusters generated by k-means.
    common_words = kmeans.cluster_centers_.argsort()[:,-1:-26:-1]
    lstWordCategories = []
    for num, centroid in enumerate(common_words):
        # print(words[centroid[0]])
        # print(str(num) + ' : ' + ', '.join(words[word] for word in centroid))
        # print(words[word] for word in centroid)
        lstWords = []
        for word in centroid:
            lstWords.append(words[word])
        lstWordCategories.append(lstWords)

    lstKeyWords = []
    lstSources = []
    for cluster in lstWordCategories:
        for word in cluster:
            for key, lstValue in dicDangerWords.items():
                if word in lstValue and key not in lstKeyWords:
                    lstKeyWords.append(key)
                    lstSources.append(findSource(word, headlines, sources))
    
    for src in lstSources:
        new_source = Source.objets.create(school=new_school, source=src)
        new_source.save()
    for word in lstKeyWords:
        new_key_word = KeyWord.objects.create(school=new_school, key_word=word)
        new_key_word.save()


    return Response(status=status.HTTP_201_CREATED)  


@api_view(['PUT'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def deleteReport(request):
    data = request.data
    report_id = data['id']

    report = Report.objects.get(id=report_id).delete()

    return Response(status=status.HTTP_200_OK)  


@api_view(['PUT'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def approveReport(request):
    data = request.data
    report_id = data['id']
    approved = data['approved']

    report = Report.objects.get(id=report_id)
    report.approved = approved

    report.save()

    return Response(status=status.HTTP_200_OK)  