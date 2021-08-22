class Report {
  final String id;
  final String description;
  final String location;
  final String report_type;
  final String priority;
  final String school;
  final String time;
  final bool approved;

  Report({
    required this.priority,
    required this.school,
    required this.time,
    required this.id,
    required this.approved,
    this.description = '',
    this.location = '',
    this.report_type = '',
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      approved: json['approved'],
      priority: json['priority'],
      school: json['school_name'],
      description: json['description'],
      location: json['location'],
      report_type: json['report_type_name'],
      time: json['time'],
    );
  }
}
