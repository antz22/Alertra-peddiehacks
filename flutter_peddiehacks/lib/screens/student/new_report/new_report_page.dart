import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/screens/student/home/student_home_page.dart';
import 'package:flutter_peddiehacks/widgets/custom_dropdown.dart';
import 'package:image_picker/image_picker.dart';
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

  bool _isLoading = false;

  String dropdownValue1 = '';
  List<String> items1 = new List.from([]);

  String dropdownValue2 = 'Low';
  List<String> items2 = ['Low', 'Medium', 'High'];

  var file;

  Future<String> _retrieveReportTypes() async {
    try {
      List<String> reportTypes =
          await context.read<APIServices>().retrieveReportTypes();
      items1 = reportTypes;
      dropdownValue1 = items1[0];
      return 'Success';
    } catch (e) {
      return e.toString();
    }
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
                future: _retrieveReportTypes(),
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
                              dropdownValue: dropdownValue1, items: items1),
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
                              dropdownValue: dropdownValue2, items: items2),
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
                                  dropdownValue2,
                                  dropdownValue1,
                                  file!.path,
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
}
