from rest_framework import serializers

from .models import Report, ReportType, Alert, ReportSearchResult, User, School


class SchoolSerializer(serializers.ModelSerializer):
    class Meta:
        model = School
        fields = (
            'id',
            'name',
            'address',
            'city',
            'state'
        )

class UserDataSerializer(serializers.ModelSerializer):
    school_name = serializers.CharField(source='school.name')
    class Meta:
        model = User
        fields = (
            'school_name',
            'role',
        )

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
            'priority',
            'get_picture',
            'school_name',
            'time',
            'approved',
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
