import 'package:flutter/material.dart';
import 'package:flutter_alertra/constants/constants.dart';
import 'package:flutter_alertra/models/alert.dart';
import 'package:flutter_alertra/models/report.dart';
import 'package:flutter_alertra/screens/alert_info/alert_info_screen.dart';
import 'package:flutter_alertra/screens/report_info/report_info_screen.dart';
import 'package:flutter_alertra/widgets/page_banner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_alertra/services/APIServices.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Future<Map<String, List<dynamic>?>> _loadFeed() async {
    List<dynamic>? alerts = await context.read<APIServices>().retrieveAlerts();
    List<dynamic>? reports =
        await context.read<APIServices>().retrieveReports();
    return {
      'alerts': alerts,
      'reports': reports,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageBanner(text: 'Feed'),
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: _loadFeed(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, List<dynamic>?>> snapshot) {
                      if (snapshot.hasData) {
                        List<Alert> alerts =
                            snapshot.data?['alerts'] as List<Alert>;
                        List<Report> reports =
                            snapshot.data?['reports'] as List<Report>;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alerts',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: alerts.length,
                              itemBuilder: (context, index) {
                                Alert alert = alerts[index];
                                return Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: kDefaultPadding),
                                      child: Container(
                                        child:
                                            _buildWarningIcon(alert.priority),
                                        width: 42.0,
                                        height: 42.0,
                                        decoration: BoxDecoration(
                                          color: alert.priority == 'high'
                                              ? kRedWarningColor
                                              : Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            _buildBoxShadow(
                                                alert.priority, 'alert'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AlertInfoScreen(alert: alert),
                                          ),
                                        ),
                                        child: Container(
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 4,
                                            text: TextSpan(
                                              text: '${alert.headline}: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 15.0,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: alert.content,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: kDefaultPadding),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Icon(Icons.more_horiz_sharp,
                                          color: kPrimaryColor),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 1.5 * kDefaultPadding),
                            Text(
                              'Reports',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: reports.length,
                              itemBuilder: (context, index) {
                                Report report = reports[index];
                                return Container(
                                  margin:
                                      EdgeInsets.only(bottom: kDefaultPadding),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: kDefaultPadding),
                                        child: Container(
                                          child:
                                              _buildReportIcon(report.priority),
                                          width: 42.0,
                                          height: 42.0,
                                          decoration: BoxDecoration(
                                            color: report.priority == 'high'
                                                ? kRedWarningColor
                                                : Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              _buildBoxShadow(
                                                  report.priority, 'report'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportInfoScreen(
                                                      report: report,
                                                      role: 'Teacher'),
                                            ),
                                          ),
                                          child: Container(
                                            child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                              text: TextSpan(
                                                text: '${report.report_type}: ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: report.description,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: kDefaultPadding),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Icon(Icons.more_horiz_sharp,
                                            color: kPrimaryColor),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconButton _buildReportIcon(String priority) {
    if (priority == 'high') {
      return IconButton(
        onPressed: () {},
        icon: SvgPicture.asset('assets/svgs/file.svg',
            color: Colors.white, height: 100.0, width: 100.0),
      );
    } else {
      return IconButton(
        onPressed: () {},
        icon: SvgPicture.asset('assets/svgs/file.svg',
            color: kPrimaryColor, height: 100.0, width: 100.0),
      );
    }
  }

  IconButton _buildWarningIcon(String priority) {
    if (priority == 'high') {
      return IconButton(
        onPressed: () {},
        icon: SvgPicture.asset('assets/svgs/warning.svg',
            color: Colors.white, height: 100.0, width: 100.0),
      );
    } else if (priority == 'medium') {
      return IconButton(
        onPressed: () {},
        icon: SvgPicture.asset('assets/svgs/warning.svg',
            color: kOrangeWarningColor, height: 100.0, width: 100.0),
      );
    } else {
      return IconButton(
        onPressed: () {},
        icon: SvgPicture.asset('assets/svgs/warning.svg',
            color: kYellowWarningColor, height: 100.0, width: 100.0),
      );
    }
  }

  BoxShadow _buildBoxShadow(String priority, String type) {
    if (priority == 'high') {
      return BoxShadow(
        color: kRedWarningColor.withOpacity(0.35),
        spreadRadius: 0,
        blurRadius: 7.0,
        offset: Offset(0, 4),
      );
    } else if (priority == 'medium') {
      return BoxShadow(
        color: type == 'alert'
            ? kOrangeWarningColor.withOpacity(0.35)
            : kPrimaryColor.withOpacity(0.35),
        spreadRadius: 0,
        blurRadius: 7.0,
        offset: Offset(0, 4),
      );
    } else {
      return BoxShadow(
        color: type == 'alert'
            ? kYellowWarningColor.withOpacity(0.50)
            : kPrimaryColor.withOpacity(0.35),
        spreadRadius: 0,
        blurRadius: 7.0,
        offset: Offset(0, 4),
      );
    }
  }
}
