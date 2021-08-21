import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/screens/student/home/student_home_page.dart';
import 'package:flutter_peddiehacks/screens/teacher/home/teacher_home_page.dart';
import 'package:flutter_peddiehacks/services/authentication_service.dart';
import 'package:flutter_peddiehacks/widgets/custom_button.dart';
import 'package:flutter_peddiehacks/widgets/custom_textfield.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, this.isFirstTime = false}) : super(key: key);

  final bool isFirstTime;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  _signIn() async {
    Map<String, dynamic> response = await context
        .read<AuthenticationService>()
        .signIn(usernameController.text, passwordController.text);

    if (response['statusCode'] != '200') {
      String key = response['body'].keys.elementAt(0);
      print(response['body'][key][0]!);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? role = await prefs.getString('role');
      String? school = await prefs.getString('role');
      if (role == 'Teacher') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherHomePage(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentHomePage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.125 * MediaQuery.of(context).size.height),
          Column(
            children: [
              SvgPicture.asset('assets/svgs/logo.svg'),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: 2 * kDefaultPadding, vertical: 4 * kDefaultPadding),
            decoration: BoxDecoration(),
            child: Column(
              children: [
                CustomTextField(
                    hintText: 'Username', controller: usernameController),
                SizedBox(height: kDefaultPadding),
                CustomTextField(
                    hintText: 'Password', controller: passwordController),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _signIn(),
            child: CustomButton(purpose: 'other', text: 'LOGIN'),
          ),
          SizedBox(height: kDefaultPadding),
          GestureDetector(
            onTap: () {
              print(usernameController.text);
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: Color(0xFF9F9F9F),
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
