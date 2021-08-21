import 'package:flutter_peddiehacks/models/report.dart';

class Alert {
  final String priority;
  final String headline;
  final String content;
  final String recipient;
  final String school;
  final String time;
  final Report? linked_report;

  Alert({
    required this.priority,
    required this.headline,
    required this.content,
    required this.recipient,
    required this.school,
    required this.time,
    this.linked_report,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      priority: json['priority'],
      headline: json['head_line'],
      content: json['content'],
      recipient: json['recipient'],
      school: json['school_name'],
      time: json['time'],
    );
  }

  dynamic toJson() => {
        'priority': priority,
        'headline': headline,
        'content': content,
        'recipient': recipient,
        'school_name': school,
        'time': time,
      };
}
