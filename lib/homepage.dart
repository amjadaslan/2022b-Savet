import 'package:flutter/material.dart';

import 'Explore/explore.dart';
import 'Community/community.dart';
import 'Notifications/notifications.dart';
import 'Home/home.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final List<Widget> _pages = <Widget>[
    home(),
    const explore(),
    const notifications(),
    const community()
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "d"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "a"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: "b"),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: "c"),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: (Colors.black54),
          backgroundColor: Colors.deepOrange,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ));
  }
}
