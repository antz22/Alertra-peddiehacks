import 'package:flutter/material.dart';
import 'package:flutter_peddiehacks/constants/constants.dart';
import 'package:flutter_peddiehacks/screens/student/alerts/alerts_page.dart';
import 'package:flutter_peddiehacks/screens/student/report/report_page.dart';
import 'package:flutter_peddiehacks/screens/teacher/home/teacher_home_page.dart';
import 'package:flutter_svg/svg.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _selectedIndex = 0;
  List<Widget> tabs = [
    AlertsPage(),
    ReportPage(),
    TeacherHomePage(),
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
          icon: SvgPicture.asset('assets/svgs/alerts.svg',
              color: _selectedIndex == 0 ? kPrimaryColor : Color(0xFFBDBDBD)),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.warning),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
