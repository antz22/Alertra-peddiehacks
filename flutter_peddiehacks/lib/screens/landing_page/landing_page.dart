import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/screens/login/login_page.dart';
import 'package:flutter_peddiehacks/screens/sign_up/sign_up.dart';
import 'package:flutter_peddiehacks/widgets/custom_button.dart';
import 'package:flutter_svg/svg.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text(
                  'Welcome to Alertra.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
                SizedBox(height: kDefaultPadding),
                Text(
                  'A school safety app that integrates student-centered threat assessment into a connected and schoolwide environment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.8,
                    fontWeight: FontWeight.w300,
                    // color: Color(0xFF9A9A9A),
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            ),
            child: CustomButton(purpose: 'other', text: 'LOGIN'),
          ),
          SizedBox(height: 1.5 * kDefaultPadding),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpScreen(),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: kPrimaryColor, width: 3.0),
                boxShadow: [
                  kBoxShadow(),
                ],
              ),
              width: MediaQuery.of(context).size.width - 5 * kDefaultPadding,
              height: 52.0,
              child: Center(
                child: Text(
                  'REGISTER',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 20.0,
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
