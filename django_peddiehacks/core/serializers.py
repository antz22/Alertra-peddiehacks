from rest_framework import serializers

from .models import Report, ReportType, Alert, School, ReportSearchResult

class ReportTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = ReportType
        fields = (
            'id',
            'name',
        )

class ReportSerializer(serializers.ModelSerializer):
    report_type_name = serializers.CharField(source='report_type.name')
    school_name = serializers.CharField(source='school.name')
    class Meta:
        model = Report
        fields = (
            'id',
            'description',
            'location',
            'report_type_name',
            'severity',
            'picture',
            'school_name',
            'time',
            'isEmergency',
        )

class ReportSearchResultSerializer(serializers.ModelSerializer):
    report_name = serializers.CharField(source='report.name')
    class Meta:
        model = ReportSearchResult
        fields = (
            'id',
            'report_name',
            'url',
        )

class AlertSerializer(serializers.ModelSerializer):
    school_name = serializers.CharField(source='school.name')
    class Meta:
        model = Alert
        fields = (
            'id',
            'priority',
            'head_line',
            'content',
            'recipient',
            'school_name',
            'time',
        )
