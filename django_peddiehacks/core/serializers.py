from rest_framework import serializers

from .models import Report, ReportType, Alert, ReportSearchResult, User, School, KeyWord, Source


class KeyWordSerializer(serializers.Serializer):
    school_id = serializers.CharField(source='school.id')
    class Meta:
        model = KeyWord
        fields = (
            'id',
            'school_id',
            'word',
        )


class SourceSerializer(serializers.Serializer):
    school_id = serializers.CharField(source='school.id')
    class Meta:
        model = Source
        fields = (
            'id',
            'school_id',
            'url',
        )

class SchoolSerializer(serializers.ModelSerializer):
    sources = SourceSerializer(read_only=True, many=True)
    key_words = KeyWordSerializer(read_only=True, many=True)
    class Meta:
        model = School
        fields = (
            'id',
            'name',
            'address',
            'city',
            'state',
            'sources',
            'key_words',
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

class ReportSearchResultSerializer(serializers.ModelSerializer):
    report_id = serializers.CharField(source='report.id')
    class Meta:
        model = ReportSearchResult
        fields = (
            'id',
            'report_id',
            'url',
        )


class ReportSerializer(serializers.ModelSerializer):
    report_type_name = serializers.CharField(source='report_type.name')
    school_name = serializers.CharField(source='school.name')
    time = serializers.DateTimeField(format="%d %b, %Y %H:%M%p")
    search_results = ReportSearchResultSerializer(read_only=True, many=True)
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
            'search_results',
        )


class AlertSerializer(serializers.ModelSerializer):
    school_name = serializers.CharField(source='school.name')
    report_id = serializers.IntegerField(source='linked_report.id')
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
            'report_id'
        )
