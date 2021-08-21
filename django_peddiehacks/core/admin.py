from django.contrib import admin
from .models import User, ReportType, Report, ReportSearchResult, Alert, School

admin.site.register(User)
admin.site.register(ReportType)
admin.site.register(Report)
admin.site.register(ReportSearchResult)
admin.site.register(Alert)
admin.site.register(School)

