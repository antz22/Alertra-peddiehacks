import 'dart:convert';

import 'package:flutter_peddiehacks/models/alert.dart';
import 'package:flutter_peddiehacks/models/report.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class APIServices {
  // Emulator
  static const API_BASE_URL = 'http://10.0.2.2:5000';
  // USB Debugging
  // static const API_BASE_URL = 'http://192.168.1.126:5000';

  Future<List<dynamic>?> retrieveAlerts() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'restAPI');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token!
    };
    final url = Uri.parse(API_BASE_URL + '/api/v1/get-alerts/');
    final response = await http.get(url, headers: headers);
    List<dynamic> data = json.decode(response.body);
    List<Alert> alerts = data.map((alert) => Alert.fromJson(alert)).toList();
    return alerts;
  }

  Future<List<dynamic>?> retrieveReports() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'restAPI');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token!
    };
    final url = Uri.parse(API_BASE_URL + '/api/v1/get-reports/');
    final response = await http.get(url, headers: headers);
    List<dynamic> data = json.decode(response.body);
    print(data);
    List<Report> reports =
        data.map((report) => Report.fromJson(report)).toList();
    return reports;
  }

  Future<List<String>> retrieveReportTypes() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'restAPI');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token!
    };
    final url = Uri.parse(API_BASE_URL + '/api/v1/get-report-types/');
    final response = await http.get(url, headers: headers);
    List<dynamic> jsonData = json.decode(response.body);
    List<String> data = jsonData.map((vals) {
      return vals['name'].toString();
    }).toList();
    return data;
  }

  // Future<String> createReport(String filename, Map<String, dynamic> body) async {
  //   final storage = new FlutterSecureStorage();
  //   final token = await storage.read(key: 'restAPI');
  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse(API_BASE_URL + '/api/v1/create-listing/'));
  //   request.headers['Authorization'] = "Token " + token!;
  //   request.headers['Content-Type'] = "application/json";
  //   request.fields['name'] = body['name'];
  //   request.fields['description'] = body['desc'];
  //   request.fields['price'] = body['price'];
  //   request.fields['amount'] = body['amount'];
  //   request.files.add(
  //     await http.MultipartFile.fromPath(
  //       'image',
  //       filename,
  //     ),
  //   );
  //   var result = await request.send();
  //   return result.reasonPhrase!;
  // }
  Future<String> createReport(String description, String location,
      String priority, String report_type_name, bool isEmergency) async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'restAPI');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token!
    };
    final url = Uri.parse(API_BASE_URL + '/api/v1/create-report/');
    final body = isEmergency
        ? json.encode({
            'severity': 'high',
            'report_type_name': report_type_name,
          })
        : json.encode({
            'description': description,
            'location': location,
            'priority': priority.toLowerCase(),
          });
    try {
      await http.post(url, headers: headers, body: body);
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> createAlert(String recipients, String headline, String content,
      String priority) async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'restAPI');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token!
    };
    final url = Uri.parse(API_BASE_URL + '/api/v1/create-alert/');
    final body = json.encode({
      'recipient': recipients,
      'headline': headline,
      'content': content,
      'priority': priority,
    });
    try {
      await http.post(url, headers: headers, body: body);
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> deleteReport(String id) async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'restAPI');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token!
    };
    final url = Uri.parse(API_BASE_URL + '/api/v1/delete-report/');
    final body = json.encode({
      'id': id,
    });
    try {
      await http.put(url, headers: headers, body: body);
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> approveReport(String id, bool approved) async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'restAPI');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Token " + token!
    };
    final url = Uri.parse(API_BASE_URL + '/api/v1/approve-report/');
    final body = json.encode({
      'id': id,
      'approved': approved,
    });
    try {
      await http.put(url, headers: headers, body: body);
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }
}
