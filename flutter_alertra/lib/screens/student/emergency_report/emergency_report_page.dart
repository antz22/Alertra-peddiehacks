import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_alertra/widgets/custom_dropdown.dart';
import 'package:flutter_alertra/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:flutter_alertra/constants/constants.dart';
import 'package:flutter_alertra/services/APIServices.dart';
import 'package:flutter_alertra/widgets/custom_button.dart';

class EmergencyReportPage extends StatefulWidget {
  const EmergencyReportPage({Key? key}) : super(key: key);

  @override
  _EmergencyReportPageState createState() => _EmergencyReportPageState();
}

class _EmergencyReportPageState extends State<EmergencyReportPage> {
  final descController = TextEditingController();

  bool _isLoading = false;
  String reportType = '';
  List<String> reportTypes = new List.from([]);

  late Future<String> future;

  Future<String> _retrieveReportTypes() async {
    try {
      reportTypes = await context.read<APIServices>().retrieveReportTypes();
      reportType = reportTypes[0];
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    future = _retrieveReportTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Report'),
        backgroundColor: kRedWarningColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(
                  top: kDefaultPadding,
                  left: kDefaultPadding,
                  right: kDefaultPadding),
              child: FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == 'Success') {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Reports have a default of High Priority and will alert teachers through push notifications immediately.',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          SizedBox(height: 2 * kDefaultPadding),
                          Text('What is the type of your emergency?'),
                          CustomDropdown(
                            updateFunction: updateReportType,
                            dropdownValue: reportType,
                            items: reportTypes,
                          ),
                          SizedBox(height: 1.5 * kDefaultPadding),
                          Text(
                            'Describe the incident you wish to report.',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 0.7 * kDefaultPadding),
                          CustomTextField(
                              controller: descController,
                              hintText: 'Description',
                              verbose: true),
                          SizedBox(height: 3.0 * kDefaultPadding),
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await context.read<APIServices>().createReport(
                                    descController.text,
                                    '',
                                    'high',
                                    reportType,
                                    '',
                                    true);
                                Navigator.pop(context);
                              },
                              child: CustomButton(
                                  purpose: 'warning', text: 'REPORT'),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
    );
  }

  void updateReportType(String newReportType) {
    setState(() {
      reportType = newReportType;
    });
  }
}
