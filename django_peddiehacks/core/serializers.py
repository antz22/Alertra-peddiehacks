from rest_framework import serializers

from .models import Report, ReportType, Alert

class ReportTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = ReportType
        fields = (
            'id',
            'name',
        )

class ReportSerializer(serializers.ModelSerializer):
    report_type_name = serializers.CharField(source='report_type.name')
    class Meta:
        model = Report
        fields = (
            'id',
            'description',
            'location',
            'report_type_name',
            'severity',
            'picture',
        )

class AlertSerializer(serializers.ModelSerializer):
    class Meta:
        model = Alert
        fields = (
            'id',
            'head_line',
            'content',
            'recipient',
        )