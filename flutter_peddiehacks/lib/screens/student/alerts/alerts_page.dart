import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/models/alert.dart';
import 'package:flutter_peddiehacks/screens/alert_info/alert_info_screen.dart';
import 'package:flutter_peddiehacks/services/APIServices.dart';
import 'package:flutter_peddiehacks/widgets/page_banner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({Key? key}) : super(key: key);

  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  Future<List<dynamic>?> _loadAlerts() async {
    List<dynamic>? alerts = await context.read<APIServices>().retrieveAlerts();
    return alerts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageBanner(text: 'Alerts'),
          Container(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                FutureBuilder(
                  future: _loadAlerts(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>?> snapshot) {
                    if (snapshot.hasData) {
                      List<Alert> alerts = snapshot.data as List<Alert>;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: alerts.length,
                        itemBuilder: (context, index) {
                          Alert alert = alerts[index];
                          return Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: kDefaultPadding),
                                child: Container(
                                  child: _buildWarningIcon(alert.priority),
                                  width: 42.0,
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    color: alert.priority == 'high'
                                        ? kRedWarningColor
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      _buildBoxShadow(alert.priority),
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
    );
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

  BoxShadow _buildBoxShadow(String priority) {
    if (priority == 'high') {
      return BoxShadow(
        color: kRedWarningColor.withOpacity(0.35),
        spreadRadius: 0,
        blurRadius: 7.0,
        offset: Offset(0, 4),
      );
    } else if (priority == 'medium') {
      return BoxShadow(
        color: kOrangeWarningColor.withOpacity(0.35),
        spreadRadius: 0,
        blurRadius: 7.0,
        offset: Offset(0, 4),
      );
    } else {
      return BoxShadow(
        color: kYellowWarningColor.withOpacity(0.50),
        spreadRadius: 0,
        blurRadius: 7.0,
        offset: Offset(0, 4),
      );
    }
  }
}
