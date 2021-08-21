from django.contrib import admin
from .models import User, ReportType, Report, Alert

admin.site.register(User)
admin.site.register(ReportType)
admin.site.register(Report)
admin.site.register(Alert)
