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
    print(alerts);
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
    List<Report> reports =
        data.map((report) => Report.fromJson(report)).toList();
    return reports;
  }

  Future<String> createAlert(String filename, Map<String, dynamic> body) async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'restAPI');
    var request = http.MultipartRequest(
        'POST', Uri.parse(API_BASE_URL + '/api/v1/create-listing/'));
    request.headers['Authorization'] = "Token " + token!;
    request.headers['Content-Type'] = "application/json";
    request.fields['name'] = body['name'];
    request.fields['description'] = body['desc'];
    request.fields['price'] = body['price'];
    request.fields['amount'] = body['amount'];
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        filename,
      ),
    );
    var result = await request.send();
    return result.reasonPhrase!;
  }
}
