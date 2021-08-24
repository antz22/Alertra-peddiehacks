import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_alertra/constants/constants.dart';
import 'package:flutter_alertra/screens/teacher/school/create_new_school_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_alertra/services/APIServices.dart';
import 'package:flutter_alertra/widgets/custom_button.dart';
import 'package:flutter_alertra/widgets/page_banner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
                _buildFirstRow(context, data),
                data['key_words'].length == 4 ? Spacer() : SizedBox.shrink(),
                _buildSecondRow(context, data),
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

  Row _buildFirstRow(BuildContext context, Map<String, dynamic> data) {
    if (data['key_words'].length > 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          _buildInfoBubble(
            context,
            true,
            data['key_words'][0][0].toUpperCase() +
                data['key_words'][0].substring(1).toLowerCase(),
            data['sources'][0],
          ),
          Spacer(),
          _buildInfoBubble(
            context,
            false,
            data['key_words'][1][0].toUpperCase() +
                data['key_words'][1].substring(1).toLowerCase(),
            data['sources'][1],
          ),
          Spacer(),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildInfoBubble(
            context,
            true,
            data['key_words'][0][0].toUpperCase() +
                data['key_words'][0].substring(1).toLowerCase(),
            data['sources'][0],
          ),
        ],
      );
    }
  }

  Row _buildSecondRow(BuildContext context, Map<String, dynamic> data) {
    switch (data['key_words'].length) {
      case 3:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoBubble(
              context,
              false,
              data['key_words'][2][0].toUpperCase() +
                  data['key_words'][2].substring(1).toLowerCase(),
              data['sources'][2],
            ),
          ],
        );
      case 4:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            _buildInfoBubble(
              context,
              false,
              data['key_words'][2][0].toUpperCase() +
                  data['key_words'][2].substring(1).toLowerCase(),
              data['sources'][2],
            ),
            Spacer(),
            _buildInfoBubble(
              context,
              false,
              data['key_words'][3][0].toUpperCase() +
                  data['key_words'][3].substring(1).toLowerCase(),
              data['sources'][3],
            ),
            Spacer(),
          ],
        );
      // <= 2 or > 4
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.shrink(),
          ],
        );
    }
  }

  Container _buildInfoBubble(
      BuildContext context, bool large, String keyword, String url) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      width: large
          ? 0.40 * MediaQuery.of(context).size.width
          : 0.35 * MediaQuery.of(context).size.width,
      height: large
          ? 0.40 * MediaQuery.of(context).size.width
          : 0.35 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 15.0,
            spreadRadius: 0.0,
            color: kPrimaryColor.withOpacity(0.2),
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Center(
        child: GestureDetector(
          onTap: () => _launchUrl(context, url),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                keyword,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5.0),
              Transform.rotate(
                angle: 180 * math.pi / 180,
                child: Icon(
                  Icons.arrow_back,
                  size: 15.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchUrl(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Error launching url');
    }
  }
}
