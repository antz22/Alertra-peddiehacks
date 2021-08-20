from django.urls import path, include
from django.contrib import admin

urlpatterns = [
	path('admin/', admin.site.urls),
	path('api/v1/', include('djoser.urls')),
	path('api/v1/', include('djoser.urls.authtoken')),
	path('api/v1/', include('core.urls')),
]

