import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/widgets/custom_dropdown.dart';
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
  String dropdownValue = 'One';
  List<String> items = ['One', 'Two', 'Three'];

  Future<List<String>> _retrieveReportTypes() async {
    List<String> reportTypes =
        await context.read<APIServices>().retrieveReportTypes();
    return reportTypes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: null,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Emergency Report'),
              backgroundColor: kRedWarningColor,
            ),
            body: Container(
              padding: EdgeInsets.all(kDefaultPadding),
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
                  CustomDropdown(dropdownValue: dropdownValue, items: items),
                  Spacer(),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        await context
                            .read<APIServices>()
                            .createReport('', '', '', dropdownValue, true);
                      },
                      child: CustomButton(purpose: 'warning', text: 'REPORT'),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
