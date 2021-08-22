import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/screens/teacher/send_alert/send_alert_page.dart';
import 'package:flutter_peddiehacks/widgets/custom_button.dart';
import 'package:flutter_peddiehacks/widgets/page_banner.dart';

class SendAlertNav extends StatelessWidget {
  const SendAlertNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PageBanner(text: 'Send an Alert'),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendAlertPage(),
                    ),
                  );
                },
                child: CustomButton(purpose: 'other', text: 'NEW ALERT'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
