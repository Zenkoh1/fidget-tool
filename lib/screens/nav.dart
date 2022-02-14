import 'package:fidget_tool/screens/inner-screens/all-inner-screens.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import 'package:fidget_tool/models/settings-model.dart';

import 'package:fidget_tool/data/vibration-options.dart';

import 'package:fidget_tool/services/stored-data.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Nav extends StatefulWidget {
  static const route = '/';
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _currentIndex;

  List<Widget> _children() {
    return [
      //FidgetScroller(),
      //FidgetDrag(),
      FidgetNav(),
      TrackingScreen(),
      Settings(),
    ];
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => SettingsModel(),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _children(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.red.withOpacity(0),
          selectedItemColor: Colors.red,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.gamepad,
              ),
              label: 'Widgets',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.track_changes,
              ),
              label: 'Tracking Thing',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
