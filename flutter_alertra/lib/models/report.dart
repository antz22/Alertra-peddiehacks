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
  final List search_results;

  Report({
    required this.id,
    required this.priority,
    required this.school,
    required this.time,
    required this.approved,
    required this.description,
    required this.search_results,
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
      search_results: json['search_results'].map((result) {
        return result['url'];
      }).toList(),
      location: json['location'] ?? '',
      report_type: json['report_type_name'] ?? '',
      picture_url: json['get_picture'] ?? '',
    );
  }
}
