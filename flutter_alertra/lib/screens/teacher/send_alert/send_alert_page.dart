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
  final recipientsController = new TextEditingController();
  final headlineController = new TextEditingController();
  final contentController = new TextEditingController();

  String dropdownValue1 = 'All';
  List<String> items1 = ['All', 'Teachers', 'Students'];

  String dropdownValue2 = 'Low';
  List<String> items2 = ['Low', 'Medium', 'High'];

  String dropdownValue3 = '';
  List<String> items3 = new List.from([]);

  Future<List<dynamic>?> _loadReports() async {
    List<dynamic>? reports =
        await context.read<APIServices>().retrieveReports();
    items3 = reports!.map((report) {
      return '${report.report_type} Report (${report.time})';
    }).toList();
    dropdownValue3 = items3[0];
    return reports;
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
              future: _loadReports(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Report> reports = snapshot.data as List<Report>;
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
                                dropdownValue: dropdownValue1, items: items1),
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
                                dropdownValue: dropdownValue2, items: items2),
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
                                dropdownValue: dropdownValue3,
                                items: items3,
                                isExpanded: true),
                          ],
                        ),
                        SizedBox(height: 3 * kDefaultPadding),
                        GestureDetector(
                          onTap: () async {
                            await context.read<APIServices>().createAlert(
                                  dropdownValue1,
                                  headlineController.text,
                                  contentController.text,
                                  dropdownValue2.toLowerCase(),
                                  reports[items3.indexOf(dropdownValue3)],
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
}
