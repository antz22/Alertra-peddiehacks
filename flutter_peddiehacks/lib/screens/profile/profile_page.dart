import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_peddiehacks/screens/landing_page/landing_page.dart';
import 'package:flutter_peddiehacks/services/authentication_service.dart';
import 'package:flutter_peddiehacks/widgets/custom_button.dart';
import 'package:flutter_peddiehacks/widgets/page_banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      role == 'Teacher'
                          ? IconButton(
                              onPressed: () {},
                              iconSize: 180.0,
                              icon: SvgPicture.asset(
                                'assets/svgs/apple.svg',
                              ),
                            )
                          : IconButton(
                              onPressed: () {},
                              iconSize: 180.0,
                              icon: SvgPicture.asset(
                                'assets/svgs/pencil.svg',
                              ),
                            ),
                      SizedBox(height: kDefaultPadding),
                      Text(
                        username ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                        ),
                      ),
                      SizedBox(height: 0.4 * kDefaultPadding),
                      Text(
                        role ?? '',
                        style: TextStyle(
                          fontSize: 23.0,
                        ),
                      ),
                      SizedBox(height: 1.6 * kDefaultPadding),
                      SvgPicture.asset(
                        'assets/svgs/school.svg',
                        height: 40.0,
                      ),
                      SizedBox(height: 0.6 * kDefaultPadding),
                      Text(
                        school ?? '',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
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
