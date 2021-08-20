from django.urls import path, include

from core import views

urlpatterns = [
    path('', views.index),
	path('get-dummy-model/', views.DummyModelList.as_view()),
    path('create-dummy-model/', views.createDummyModel),
]
