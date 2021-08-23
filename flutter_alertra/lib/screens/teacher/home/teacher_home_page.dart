import 'package:flutter/material.dart';
import 'package:flutter_alertra/constants/constants.dart';
import 'package:flutter_alertra/screens/profile/profile_page.dart';
import 'package:flutter_alertra/screens/teacher/feed/feed_page.dart';
import 'package:flutter_alertra/screens/teacher/school/school_page.dart';
import 'package:flutter_alertra/screens/teacher/send_alert/send_alert_nav.dart';
import 'package:flutter_svg/svg.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key}) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  int _selectedIndex = 0;
  List<Widget> tabs = [
    FeedPage(),
    SendAlertNav(),
    SchoolPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      unselectedIconTheme: IconThemeData(
        color: Color(0xFFBDBDBD),
      ),
      unselectedItemColor: Color(0xFFBDBDBD),
      selectedIconTheme: IconThemeData(
        color: kPrimaryColor,
      ),
      selectedItemColor: kPrimaryColor,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.warning),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/svgs/alerts.svg',
              color: _selectedIndex == 1 ? kPrimaryColor : Color(0xFFBDBDBD)),
          label: 'Alert',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'School',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
