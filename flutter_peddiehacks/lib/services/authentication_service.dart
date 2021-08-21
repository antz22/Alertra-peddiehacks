import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_produce_provider/models/user.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationService with ChangeNotifier {
  // Emulator
  static const API_BASE_URL = 'http://10.0.2.2:5000';
  // USB Debugging
  // static const API_BASE_URL = 'http://192.168.1.126:5000';

  Future<Map> registerUser(username, password) async {
    final headers = {"Content-Type": "application/json"};
    final url = Uri.parse(API_BASE_URL + '/api/v1/users/');
    final body = json.encode({
      'username': username,
      'password': password,
    });
    final response = await http.post(url, headers: headers, body: body);
    print(response.body);

    Map data = {
      'statusCode': response.statusCode.toString(),
      'body': json.decode(response.body),
    };
    print(data);
    return data;
  }

  Future<Map<String, dynamic>> signIn(String username, String password) async {
    final headers = {"Content-Type": "application/json"};
    final url = Uri.parse(API_BASE_URL + '/api/v1/token/login/');
    final body = json.encode({
      'username': username,
      'password': password,
      // 'username': 'user',
      // 'password': 'testing123123',
    });

    final response = await http.post(url, headers: headers, body: body);
    Map<String, dynamic> data = json.decode(response.body);

    if (response.statusCode == 200) {
      String token = data['auth_token'];
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'restAPI', value: token);
    }
    Map<String, dynamic> responseData = {
      'statusCode': response.statusCode.toString(),
      'body': json.decode(response.body),
    };
    return responseData;
  }

  Future<Map<String, dynamic>> sawoSignIn(
      String username, String password) async {
    final headers = {"Content-Type": "application/json"};
    final url = Uri.parse(API_BASE_URL + '/api/v1/token/login/');
    final body = json.encode({
      'username': username,
      'password': password,
      // 'username': 'user',
      // 'password': 'testing123123',
    });

    final response = await http.post(url, headers: headers, body: body);
    Map<String, dynamic> data = json.decode(response.body);

    if (response.statusCode == 200) {
      String token = data['auth_token'];
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'restAPI', value: token);
    }
    Map<String, dynamic> responseData = {
      'statusCode': response.statusCode.toString(),
      'body': json.decode(response.body),
    };
    return responseData;
  }
}
