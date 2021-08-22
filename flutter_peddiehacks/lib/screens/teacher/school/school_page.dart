import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/screens/teacher/school/create_new_school_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_peddiehacks/services/APIServices.dart';
import 'package:flutter_peddiehacks/widgets/custom_button.dart';
import 'package:flutter_peddiehacks/widgets/page_banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({Key? key}) : super(key: key);

  @override
  _SchoolPageState createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  String school = '';

  Future<Map<String, dynamic>> _retrieveInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    school = await prefs.getString('school')!;
    var response = await context.read<APIServices>().retrieveSchoolInfo();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _retrieveInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
            return Column(
              children: [
                PageBanner(text: 'School Info'),
                SizedBox(height: 2 * kDefaultPadding),
                Text(
                  data['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: kDefaultPadding),
                Text(
                  data['city'],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 0.7 * kDefaultPadding),
                Text(
                  data['address'],
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Container(
                      child: Text(
                          // data['sources'][0] ?? '',
                          ''),
                    ),
                    SizedBox(width: 3 * kDefaultPadding),
                    Container(
                      child: Text(
                          // data['sources'][1] ?? '',
                          ''),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Container(
                      child: Text(
                          // data['sources'][2] ?? '',
                          ''),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateNewSchoolPage(),
                    ),
                  ),
                  child: CustomButton(
                    purpose: 'other',
                    text: 'CREATE NEW',
                  ),
                ),
                SizedBox(height: kDefaultPadding),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
