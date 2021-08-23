import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/models/report.dart';
import 'package:flutter_peddiehacks/screens/report_info/report_info_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/models/alert.dart';
import 'package:flutter_peddiehacks/services/APIServices.dart';
import 'package:flutter_svg/svg.dart';

class AlertInfoScreen extends StatelessWidget {
  const AlertInfoScreen({Key? key, required this.alert}) : super(key: key);

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(alert.priority),
      body: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            _buildPriorityInfo(alert.priority),
            SizedBox(height: kDefaultPadding),
            Text(
              alert.content,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 21.0,
              ),
            ),
            SizedBox(height: kDefaultPadding),
            Row(
              children: [
                Text(
                  'Posted by Teacher',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Spacer(),
                Text(
                  alert.time,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: kDefaultPadding),
            alert.report_id == null
                ? SizedBox.shrink()
                : FutureBuilder(
                    future: context
                        .read<APIServices>()
                        .retrieveReport(alert.report_id!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Report report = snapshot.data as Report;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReportInfoScreen(report: report),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(kDefaultPadding),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 5.0,
                                  offset: Offset(0, 2),
                                  spreadRadius: 0.0,
                                  color: Colors.black.withOpacity(0.15),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        report.approved
                                            ? '${report.report_type} (Approved Report)'
                                            : '${report.report_type} (Unreviewed Report)',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Transform.rotate(
                                        angle: 180 * math.pi / 180,
                                        child: Icon(Icons.arrow_back)),
                                  ],
                                ),
                                SizedBox(height: 0.7 * kDefaultPadding),
                                Text(
                                  report.description,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 0.7 * kDefaultPadding),
                                report.picture_url != ''
                                    ? Container(
                                        child: ClipRRect(
                                          child: Image(
                                            image: NetworkImage(
                                                '${report.picture_url}'),
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Row _buildPriorityInfo(String priority) {
    if (priority == 'high') {
      return Row(
        children: [
          SvgPicture.asset('assets/svgs/warning.svg', color: kRedWarningColor),
          SizedBox(width: 0.5 * kDefaultPadding),
          Text(
            'High Priority',
            style: TextStyle(
              color: kRedWarningColor,
              fontSize: 15.0,
            ),
          ),
        ],
      );
    } else if (priority == 'medium') {
      return Row(
        children: [
          SvgPicture.asset('assets/svgs/warning.svg',
              color: kOrangeWarningColor),
          SizedBox(width: 0.5 * kDefaultPadding),
          Text(
            'Medium Priority',
            style: TextStyle(
              color: kOrangeWarningColor,
              fontSize: 15.0,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          SvgPicture.asset('assets/svgs/warning.svg',
              color: kYellowWarningColor),
          SizedBox(width: 0.5 * kDefaultPadding),
          Text(
            'Low Priority',
            style: TextStyle(
              color: kYellowWarningColor,
              fontSize: 15.0,
            ),
          ),
        ],
      );
    }
  }

  AppBar _buildAppBar(String priority) {
    if (priority == 'high') {
      return AppBar(
        title: Text(alert.headline),
        backgroundColor: kRedWarningColor,
      );
    } else if (priority == 'medium') {
      return AppBar(
        title: Text(alert.headline),
        backgroundColor: kOrangeWarningColor,
      );
    } else {
      return AppBar(
        title: Text(alert.headline),
        backgroundColor: kYellowWarningColor,
      );
    }
  }
}
