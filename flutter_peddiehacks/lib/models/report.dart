class Report {
  final String description;
  final String location;
  final String report_type;
  final String priority;
  final String school;
  final bool isEmergency;

  Report({
    required this.priority,
    required this.school,
    required this.isEmergency,
    this.description = '',
    this.location = '',
    this.report_type = '',
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      priority: json['priority'],
      school: json['school'],
      isEmergency: json['isEmergency'],
      description: json['description'],
      location: json['location'],
      report_type: json['report_type_name'],
    );
  }
}
