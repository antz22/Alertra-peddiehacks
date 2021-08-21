import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/screens/login/login_page.dart';
import 'package:flutter_peddiehacks/screens/student/home/student_home_page.dart';
import 'package:flutter_peddiehacks/screens/teacher/home/teacher_home_page.dart';
import 'package:flutter_peddiehacks/services/authentication_service.dart';
import 'package:flutter_peddiehacks/widgets/custom_button.dart';
import 'package:flutter_peddiehacks/widgets/custom_textfield.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final roleController = TextEditingController();
  final schoolController = TextEditingController();

  _register() async {
    Map data = await context.read<AuthenticationService>().registerUser(
        usernameController.text,
        passwordController.text,
        roleController.text,
        schoolController.text);
    if (data.containsKey('statusCode') &&
        data['statusCode'] != '200' &&
        data['statusCode'] != '201') {
      String key = data['body'].keys.elementAt(0);
      print(data['body'][key][0]!);
    } else {
      if (roleController.text == 'Teacher') {
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
          Spacer(),
          Column(
            children: [
              SvgPicture.asset('assets/svgs/logo.svg'),
            ],
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 2 * kDefaultPadding),
            decoration: BoxDecoration(),
            child: Column(
              children: [
                CustomTextField(
                  hintText: 'Username',
                  controller: usernameController,
                ),
                SizedBox(height: kDefaultPadding),
                CustomTextField(
                  hintText: 'Password',
                  controller: passwordController,
                ),
                SizedBox(height: kDefaultPadding),
                CustomTextField(
                  hintText: 'Role',
                  controller: roleController,
                ),
                SizedBox(height: kDefaultPadding),
                CustomTextField(
                  hintText: 'School',
                  controller: schoolController,
                ),
              ],
            ),
          ),
          Spacer(),
          GestureDetector(
              onTap: () => _register(),
              child: CustomButton(purpose: 'other', text: 'REGISTER')),
          Spacer(),
        ],
      ),
    );
  }
}
