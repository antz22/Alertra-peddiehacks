import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/screens/student/emergency_report/emergency_report_page.dart';
import 'package:flutter_peddiehacks/screens/student/new_report/new_report_page.dart';
import 'package:flutter_peddiehacks/widgets/custom_button.dart';
import 'package:flutter_peddiehacks/widgets/page_banner.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PageBanner(text: 'Report'),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewReportPage(),
                    ),
                  ),
                  child:
                      CustomButton(purpose: 'other', text: 'File new report'),
                ),
                SizedBox(height: kDefaultPadding),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmergencyReportPage(),
                    ),
                  ),
                  child: CustomButton(
                      purpose: 'warning', text: 'EMERGENCY REPORT'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
