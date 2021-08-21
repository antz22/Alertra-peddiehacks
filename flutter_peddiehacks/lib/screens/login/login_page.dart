import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/screens/home/home_page.dart';
import 'package:flutter_peddiehacks/services/authentication_service.dart';
import 'package:flutter_peddiehacks/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
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
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(13.0),
              ),
              width: MediaQuery.of(context).size.width - 4 * kDefaultPadding,
              height: 52.0,
              child: Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
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
