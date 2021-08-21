import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/screens/login/login_page.dart';
import 'package:flutter_peddiehacks/services/authentication_service.dart';
import 'package:flutter_peddiehacks/widgets/custom_textfield.dart';
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
  final password2Controller = TextEditingController();

  _register() async {
    if (passwordController.text == password2Controller.text) {
      Map data = await context
          .read<AuthenticationService>()
          .registerUser(usernameController.text, passwordController.text);
      if (data.containsKey('statusCode') &&
          data['statusCode'] != '200' &&
          data['statusCode'] != '201') {
        String key = data['body'].keys.elementAt(0);
        print(data['body'][key][0]!);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
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
          SizedBox(height: 0.1 * MediaQuery.of(context).size.height),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: 2 * kDefaultPadding, vertical: 3 * kDefaultPadding),
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
                  hintText: 'Repeat Password',
                  controller: password2Controller,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _register(),
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(13.0),
              ),
              width: MediaQuery.of(context).size.width - 4 * kDefaultPadding,
              height: 52.0,
              child: Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
