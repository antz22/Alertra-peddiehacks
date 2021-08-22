from django.urls import path, include
from core import views

urlpatterns = [
    path('', views.index),
	path('get-reports/', views.ReportList.as_view()),
	path('get-report-types/', views.ReportTypeList.as_view()),
    # path('get-report-search-result/', views.ReportSearchResultList.as_view()),
	path('get-alerts/', views.AlertList.as_view()),
	path('get-user-data/', views.getUserData),
	path('get-report-data/', views.getReportData),
	path('create-user/', views.createUser),
    path('create-report/', views.createReport),
    path('create-alert/', views.createAlert),
    path('create-school/', views.createSchool),
    path('delete-report/', views.deleteReport),
    path('approve-report/', views.approveReport),
]
