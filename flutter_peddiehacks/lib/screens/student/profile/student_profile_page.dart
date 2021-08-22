import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/screens/landing_page/landing_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_peddiehacks/services/authentication_service.dart';
import 'package:flutter_peddiehacks/widgets/custom_button.dart';
import 'package:flutter_peddiehacks/widgets/page_banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentProfilePage extends StatefulWidget {
  StudentProfilePage({Key? key}) : super(key: key);

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  String? username = '';

  String? role = '';

  String? school = '';

  Future<String> _retrieveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = await prefs.getString('username');
    role = await prefs.getString('role');
    school = await prefs.getString('school');
    return 'Success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _retrieveUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                PageBanner(text: 'Profile'),
                SizedBox(height: 3 * kDefaultPadding),
                Text(username ?? ''),
                Text(role ?? ''),
                Text(school ?? ''),
                GestureDetector(
                  onTap: () async {
                    await context.read<AuthenticationService>().signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LandingPage(),
                      ),
                    );
                  },
                  child: CustomButton(purpose: 'other', text: 'Sign Out'),
                ),
                SizedBox(height: kDefaultPadding),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
