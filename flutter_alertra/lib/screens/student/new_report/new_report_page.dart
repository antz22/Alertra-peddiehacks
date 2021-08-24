import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_alertra/screens/student/home/student_home_page.dart';
import 'package:flutter_alertra/widgets/custom_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_alertra/constants/constants.dart';
import 'package:flutter_alertra/services/APIServices.dart';
import 'package:flutter_alertra/widgets/custom_button.dart';
import 'package:flutter_alertra/widgets/custom_textfield.dart';

class NewReportPage extends StatefulWidget {
  const NewReportPage({Key? key}) : super(key: key);

  @override
  _NewReportPageState createState() => _NewReportPageState();
}

class _NewReportPageState extends State<NewReportPage> {
  final descController = new TextEditingController();
  final locationController = new TextEditingController();
  final severityController = new TextEditingController();

  bool _isLoading = false;

  String reportType = '';
  List<String> reportTypes = new List.from([]);

  String priority = 'Low';
  List<String> priorities = ['Low', 'Medium', 'High'];

  var file;

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
        title: Text('File a Report'),
        backgroundColor: kPrimaryColor,
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
                          SizedBox(height: 0.5 * kDefaultPadding),
                          Text(
                            'What is the type of your emergency?',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
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
                          SizedBox(height: 1.5 * kDefaultPadding),
                          Text(
                            'Describe the location of the incident.',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 0.7 * kDefaultPadding),
                          CustomTextField(
                              controller: locationController,
                              hintText: 'Location'),
                          SizedBox(height: 1.5 * kDefaultPadding),
                          Text(
                            'What is the urgency or severity of your incident?',
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
                          Row(
                            children: [
                              Text(
                                'Insert (optional) Picture',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 0.7 * kDefaultPadding),
                              IconButton(
                                icon: Icon(Icons.add, color: kPrimaryColor),
                                onPressed: () async {
                                  ImagePicker picker = ImagePicker();
                                  file = await picker.pickImage(
                                      source: ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 2 * kDefaultPadding),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await context.read<APIServices>().createReport(
                                  descController.text,
                                  locationController.text,
                                  priority.toLowerCase(),
                                  reportType,
                                  file?.path,
                                  false);

                              Navigator.pop(context);
                            },
                            child:
                                CustomButton(purpose: 'other', text: 'REPORT'),
                          ),
                          SizedBox(height: 1.5 * kDefaultPadding),
                        ],
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
    );
  }

  void updatePriority(String newPriority) {
    setState(() {
      priority = newPriority;
    });
  }

  void updateReportType(String newReportType) {
    setState(() {
      reportType = newReportType;
    });
  }
}
