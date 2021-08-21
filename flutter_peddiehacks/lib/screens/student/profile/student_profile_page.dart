import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/screens/landing_page/landing_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_peddiehacks/services/authentication_service.dart';
import 'package:flutter_peddiehacks/widgets/custom_button.dart';
import 'package:flutter_peddiehacks/widgets/page_banner.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PageBanner(text: 'Profile'),
          Spacer(),
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
        ],
      ),
    );
  }
}
