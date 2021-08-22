class Report {
  final int id;
  final String priority;
  final String school;
  final String time;
  final bool approved;
  final String description;
  final String location;
  final String report_type;
  final String picture_url;

  Report({
    required this.id,
    required this.priority,
    required this.school,
    required this.time,
    required this.approved,
    required this.description,
    this.location = '',
    this.report_type = '',
    this.picture_url = '',
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      priority: json['priority'],
      school: json['school_name'],
      time: json['time'],
      approved: json['approved'],
      description: json['description'],
      location: json['location'] ?? '',
      report_type: json['report_type_name'] ?? '',
      picture_url: json['get_picture'] ?? '',
    );
  }
}
