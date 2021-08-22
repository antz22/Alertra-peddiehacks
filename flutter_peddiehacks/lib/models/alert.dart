import 'package:flutter_peddiehacks/models/report.dart';

class Alert {
  final String priority;
  final String headline;
  final String content;
  final String recipient;
  final String school;
  final String time;
  final int? report_id;

  Alert({
    required this.priority,
    required this.headline,
    required this.content,
    required this.recipient,
    required this.school,
    required this.time,
    this.report_id,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      priority: json['priority'],
      headline: json['head_line'],
      content: json['content'],
      recipient: json['recipient'],
      school: json['school_name'],
      time: json['time'],
      report_id: json['report_id'],
    );
  }
}
