from django.urls import path, include
from core import views

urlpatterns = [
    path('', views.index),
	path('get-reports/', views.ReportList.as_view()),
	path('get-report-types/', views.ReportTypeList.as_view()),
	path('get-alerts/', views.AlertList.as_view()),
    path('create-report/', views.createReport),
    path('create-alert/', views.createAlert),
]
