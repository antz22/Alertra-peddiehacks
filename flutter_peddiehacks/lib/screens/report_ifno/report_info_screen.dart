import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/models/report.dart';
import 'package:flutter_peddiehacks/services/APIServices.dart';
import 'package:flutter_svg/svg.dart';

class ReportInfoScreen extends StatelessWidget {
  const ReportInfoScreen({Key? key, required this.report, this.role = ''})
      : super(key: key);

  final String role;
  final Report report;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Student Report (${report.report_type})'),
      ),
      body: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriorityInfo(report.priority),
            SizedBox(height: kDefaultPadding),
            Text(
              '${report.report_type} Report',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 21.0,
              ),
            ),
            SizedBox(height: kDefaultPadding),
            Text(
              report.description,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17.0,
              ),
            ),
            SizedBox(height: kDefaultPadding),
            Text(
              report.time,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 1.5 * kDefaultPadding),
            Text(
              'Location:',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 0.8 * kDefaultPadding),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.school,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: 0.3 * kDefaultPadding),
                Text(
                  report.location,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: kDefaultPadding),
            Text(
              'Picture:',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: kDefaultPadding),
            Text(
              'Matching Search Results:',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            role == 'Teacher'
                ? report.approved
                    ? Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await context
                                    .read<APIServices>()
                                    .deleteReport(report.id);
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFE30000),
                                  borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 7.0,
                                      spreadRadius: 1.0,
                                      offset: Offset(0, 5),
                                      color: kRedWarningColor.withOpacity(0.20),
                                    )
                                  ],
                                ),
                                height: 52.0,
                                child: Center(
                                  child: Text(
                                    'DELETE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: kDefaultPadding),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await context.read<APIServices>().approveReport(
                                    report.id, report.approved ? false : true);
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 7.0,
                                      spreadRadius: 1.0,
                                      offset: Offset(0, 5),
                                      color: kPrimaryColor.withOpacity(0.20),
                                    )
                                  ],
                                ),
                                height: 52.0,
                                child: Center(
                                  child: Text(
                                    'APPROVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Icon(Icons.check),
                      )
                : SizedBox.shrink(),
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
}
