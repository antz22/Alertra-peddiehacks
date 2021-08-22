import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/widgets/custom_dropdown.dart';
import 'package:flutter_peddiehacks/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/services/APIServices.dart';
import 'package:flutter_peddiehacks/widgets/custom_button.dart';

class EmergencyReportPage extends StatefulWidget {
  const EmergencyReportPage({Key? key}) : super(key: key);

  @override
  _EmergencyReportPageState createState() => _EmergencyReportPageState();
}

class _EmergencyReportPageState extends State<EmergencyReportPage> {
  final descController = new TextEditingController();
  String dropdownValue = '';
  List<String> items = new List.from([]);

  Future<String> _retrieveReportTypes() async {
    try {
      List<String> reportTypes =
          await context.read<APIServices>().retrieveReportTypes();
      items = reportTypes;
      dropdownValue = items[0];
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Report'),
        backgroundColor: kRedWarningColor,
      ),
      body: Container(
        padding: EdgeInsets.all(kDefaultPadding),
        child: FutureBuilder(
          future: _retrieveReportTypes(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == 'Success') {
              return Column(
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
                  CustomDropdown(dropdownValue: dropdownValue, items: items),
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
                  Spacer(),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        await context.read<APIServices>().createReport(
                            descController.text,
                            '',
                            'high',
                            dropdownValue,
                            '',
                            true);

                        Navigator.pop(context);
                      },
                      child: CustomButton(purpose: 'warning', text: 'REPORT'),
                    ),
                  ),
                ],
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
}
