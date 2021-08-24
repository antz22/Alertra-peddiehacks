import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_alertra/models/report.dart';
import 'package:flutter_alertra/widgets/custom_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:flutter_alertra/constants/constants.dart';
import 'package:flutter_alertra/services/APIServices.dart';
import 'package:flutter_alertra/widgets/custom_button.dart';
import 'package:flutter_alertra/widgets/custom_textfield.dart';
import 'package:flutter_alertra/widgets/page_banner.dart';

class SendAlertPage extends StatefulWidget {
  const SendAlertPage({Key? key}) : super(key: key);

  @override
  _SendAlertPageState createState() => _SendAlertPageState();
}

class _SendAlertPageState extends State<SendAlertPage> {
  final headlineController = TextEditingController();
  final contentController = TextEditingController();

  String recipient = 'All';
  List<String> recipients = ['All', 'Teachers', 'Students'];

  String priority = 'Low';
  List<String> priorities = ['Low', 'Medium', 'High'];

  String dropdownReport = '';
  List<String> dropdownReports = new List.from([]);

  List<Report> reports = new List.from([]);

  Future<String> _loadReports() async {
    try {
      reports =
          await context.read<APIServices>().retrieveReports() as List<Report>;
      dropdownReports = reports.map((report) {
        return '${report.report_type} Report (${report.time})';
      }).toList();
      dropdownReports.insert(0, '(None)');
      dropdownReport = dropdownReports[0];
      return 'Success';
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  late Future<String> future;

  @override
  void initState() {
    super.initState();
    future = _loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            PageBanner(text: 'Send an Alert'),
            FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: kDefaultPadding, right: kDefaultPadding),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(height: 0.5 * kDefaultPadding),
                            Text(
                              'Recipients',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 0.7 * kDefaultPadding),
                            CustomDropdown(
                              updateFunction: updateRecipient,
                              dropdownValue: recipient,
                              items: recipients,
                            ),
                            SizedBox(height: 1.5 * kDefaultPadding),
                            Text(
                              'Head Line',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 0.7 * kDefaultPadding),
                            CustomTextField(
                                controller: headlineController, hintText: ''),
                            SizedBox(height: 1.5 * kDefaultPadding),
                            Text(
                              'Content',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 0.7 * kDefaultPadding),
                            CustomTextField(
                                controller: contentController, hintText: ''),
                            SizedBox(height: 1.5 * kDefaultPadding),
                            Text(
                              'Alert Priority',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 0.7 * kDefaultPadding),
                            CustomDropdown(
                              updateFunction: updatePriority,
                              dropdownValue: priority,
                              items: priorities,
                            ),
                            SizedBox(height: 1.5 * kDefaultPadding),
                            Text(
                              'Link Student Report',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 0.7 * kDefaultPadding),
                            CustomDropdown(
                              updateFunction: updateReport,
                              dropdownValue: dropdownReport,
                              items: dropdownReports,
                              isExpanded: true,
                            ),
                          ],
                        ),
                        SizedBox(height: 3 * kDefaultPadding),
                        GestureDetector(
                          onTap: () async {
                            await context.read<APIServices>().createAlert(
                                  recipient,
                                  headlineController.text,
                                  contentController.text,
                                  priority.toLowerCase(),
                                  dropdownReport != '(None)'
                                      ? reports[dropdownReports
                                          .indexOf(dropdownReport)]
                                      : null,
                                );
                            Navigator.pop(context);
                          },
                          child: CustomButton(purpose: 'other', text: 'SEND'),
                        ),
                        SizedBox(height: kDefaultPadding),
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void updateRecipient(String newRecipient) {
    setState(() {
      recipient = newRecipient;
    });
  }

  void updatePriority(String newPriority) {
    setState(() {
      priority = newPriority;
    });
    print(priority);
  }

  void updateReport(String newReport) {
    setState(() {
      dropdownReport = newReport;
    });
  }
}
