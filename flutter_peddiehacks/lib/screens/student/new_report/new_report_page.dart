import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/screens/student/home/student_home_page.dart';
import 'package:flutter_peddiehacks/widgets/custom_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/services/APIServices.dart';
import 'package:flutter_peddiehacks/widgets/custom_button.dart';
import 'package:flutter_peddiehacks/widgets/custom_textfield.dart';

class NewReportPage extends StatefulWidget {
  const NewReportPage({Key? key}) : super(key: key);

  @override
  _NewReportPageState createState() => _NewReportPageState();
}

class _NewReportPageState extends State<NewReportPage> {
  final descController = new TextEditingController();
  final locationController = new TextEditingController();
  final severityController = new TextEditingController();

  String dropdownValue = 'Low';
  List<String> items = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File a Report'),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.only(
            top: kDefaultPadding,
            left: kDefaultPadding,
            right: kDefaultPadding),
        child: ListView(
          shrinkWrap: true,
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 0.5 * kDefaultPadding),
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
                    controller: locationController, hintText: 'Location'),
                SizedBox(height: 1.5 * kDefaultPadding),
                Text(
                  'What is the urgency or severity of your incident?',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 0.7 * kDefaultPadding),
                CustomDropdown(dropdownValue: dropdownValue, items: items)
              ],
            ),
            SizedBox(height: 3 * kDefaultPadding),
            GestureDetector(
              onTap: () async {
                await context.read<APIServices>().createReport(
                    descController.text,
                    locationController.text,
                    severityController.text,
                    '',
                    false);
                Navigator.pop(context);
              },
              child: CustomButton(purpose: 'other', text: 'REPORT'),
            ),
          ],
        ),
      ),
    );
  }
}
