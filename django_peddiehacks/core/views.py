from django.shortcuts import render

from rest_framework import status, authentication, permissions
from rest_framework.decorators import api_view, authentication_classes,permission_classes
from django.views.decorators.csrf import csrf_exempt
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import Report, ReportSearchResult, ReportType, Alert, School
from .serializers import ReportSerializer, ReportTypeSerializer, AlertSerializer, UserDataSerializer

import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt
#import seaborn as sns
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




def index(request):
    pass

#Creating the lists of the django models
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

#webscraper function to find report search results
def webscrape(town, incident):
    # os.environ['MOZ_HEADLESS'] = '1'
    driver = webdriver.Firefox()

    # driver = webdriver.PhantomJS('C:\Users\Prineet Singh\Desktop\searchschoolandincident\phantomjs-1.9.7-windows\phantomjs.exe')

    driver.get("https://www.google.com/")
    driver.find_element_by_xpath('/html/body/div[1]/div[3]/form/div[1]/div[1]/div[1]/div/div[2]/input').send_keys(town + ' ' + incident + Keys.ENTER)

    # driver.
    
    # # results = driver.find_elements_by_css_selector('div.g')
    # results = driver.find_elements_by_xpath("//div[@class='g']//div[@class='r']//a[not(@class)]");
    # for result in results:
    #     print(result.get_attribute("href"))
    # # print(results)
    # link1 = results[0].find_element_by_tag_name("a")
    # link2 = results[1].find_element_by_tag_name("a")
    # link3 = results[2].find_element_by_tag_name("a")
    # href1 = link1.get_attribute("href")
    # href2 = link2.get_attribute("href")
    # href3 = link3.get_attribute("href")

    driver.implicitly_wait(20)

    allLinks = driver.find_elements_by_class_name('yuRUbf')
    # href1= allLinks[0].get_attribute('href')
    # href2 = allLinks[1].get_attribute('href')
    # href3 = allLinks[2].get_attribute('href')
    link1 = allLinks[0].find_element_by_tag_name("a")
    link2 = allLinks[1].find_element_by_tag_name("a")
    link3 = allLinks[2].find_element_by_tag_name("a")
    href1 = link1.get_attribute("href")
    href2 = link2.get_attribute("href")
    href3 = link3.get_attribute("href")

    driver.close()

    # print(urlparse.parse_qs(urlparse.urlparse(href1).query)["q"])
    print(href1, href2, href3)
    print(allLinks)

    # return urlparse.parse_qs(urlparse.urlparse(href1).query)["q"], urlparse.parse_qs(urlparse.urlparse(href2).query)["q"], urlparse.parse_qs(urlparse.urlparse(href3).query)["q"]
    return (href1, href2, href3)

#function to create csv datasets with search headlines for kmeans clustering
def createData(filePath, headlines):
    with open(filePath, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["index", "headline_text"])
        for index, headline in enumerate(headlines):
            writer.writerow([index, headline])


#function to initialize the User model
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


#function to retrieve data from the User model fields
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


#function to initialize the Report model
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
        report_type = ReportType.objects.get(name=report_type_name)

        new_report = Report.objects.create(user=user, description=description, location=location, priority=priority, school=school, report_type=report_type)
    except: 
        # if it doesn't it is an emergency report with only the report type and a default of high priority
        description = data['description']
        report_type_name = data['report_type_name']
        report_type = ReportType.objects.get(name=report_type_name)
        priority = 'high'
        picture = data['picture']
        print(picture)

        new_report = Report.objects.create(user=user, report_type=report_type, priority=priority, school=school, description=description, picture=picture)


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


    # qstSearches = new_report.search_results
    # serializer = ReportSearchResultSerializer(qstSearches, many=True)

    return Response(status=status.HTTP_201_CREATED)


#function to initialize the Alert model
@api_view(['POST'])
@authentication_classes([authentication.TokenAuthentication])
@permission_classes([permissions.IsAuthenticated])
def createAlert(request):

    data = request.data
    user = request.user

    head_line = data['headline']
    content = data['content']
    recipient = data['recipient']
    school = School.objects.get(name=user.school.name)

    if recipient == 'All':
        new_alert = Alert.objects.create(user=user, head_line=head_line, content=content, recipient='Teacher', school=school)
        new_alert = Alert.objects.create(user=user, head_line=head_line, content=content, recipient='Student', school=school)
    elif recipient == 'Teachers':
        new_alert = Alert.objects.create(user=user, head_line=head_line, content=content, recipient='Teacher', school=school)
    elif recipient == 'Students':
        new_alert = Alert.objects.create(user=user, head_line=head_line, content=content, recipient='Student', school=school)


    new_alert.save()


    return Response(status=status.HTTP_201_CREATED)


#function to initialize the School model
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
    
    filePath = os.path.join('django_peddiehacks\\extras\\datasets', name + '.csv')
    headlines = []

    createData(filePath, headlines)

    #Following code is for clustering to find the most frequent types of safety issues in a school's city
    data = pd.read_csv("C:\\Users\\suchi\\Dropbox (Sandipan.com)\\Creative\\RitiCode\\Article Clustering\\data1.csv", error_bad_lines=False, usecols =["headline_text"])
    print(data.head())

    # Deleting duplicate headlines (if any)
    data[data['headline_text'].duplicated(keep=False)].sort_values('headline_text').head(8)

    data = data.drop_duplicates('headline_text')

    #NLP:
    punc = ['.', ',', '"', "'", '?', '!', ':', ';', '(', ')', '[', ']', '{', '}',"%"]
    stop_words = text.ENGLISH_STOP_WORDS.union(punc)
    desc = data['headline_text'].values
    vectorizer = TfidfVectorizer(stop_words = stop_words)
    X = vectorizer.fit_transform(desc)

    word_features = vectorizer.get_feature_names()
    print(len(word_features))
    print(word_features[5000:5100])

    #Tokenizing
    stemmer = SnowballStemmer('english')
    tokenizer = RegexpTokenizer(r'[a-zA-Z\']+')

    def tokenize(text):
        return [stemmer.stem(word) for word in tokenizer.tokenize(text.lower())]

    #Vectorization with stop words(words irrelevant to the model), stemming and tokenizing
    vectorizer2 = TfidfVectorizer(stop_words = stop_words, tokenizer = tokenize)
    X2 = vectorizer2.fit_transform(desc)
    word_features2 = vectorizer2.get_feature_names()
    print(len(word_features2))
    print(word_features2[:50]) 

    vectorizer3 = TfidfVectorizer(stop_words = stop_words, tokenizer = tokenize, max_features = 1000)
    X3 = vectorizer3.fit_transform(desc)
    words = vectorizer3.get_feature_names()

    #K-means clustering
    from sklearn.cluster import KMeans
    wcss = []
    for i in range(1,2):
        kmeans = KMeans(n_clusters=i,init='k-means++',max_iter=300,n_init=10,random_state=0)
        kmeans.fit(X3)
        wcss.append(kmeans.inertia_)

    print(words[250:300])

    #2 clusters
    kmeans = KMeans(n_clusters = 2, n_init = 20, n_jobs = 1) # n_init(number of iterations for clsutering) n_jobs(number of cpu cores to use)
    kmeans.fit(X3)
    # We look at the 2 clusters generated by k-means.
    common_words = kmeans.cluster_centers_.argsort()[:,-1:-26:-1]

    lstReturnCategories = []
    for num, centroid in enumerate(common_words):
        lstReturnCategories.append(words[centroid[0]])
        #print(str(num) + ' : ' + ', '.join(words[word] for word in centroid))


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