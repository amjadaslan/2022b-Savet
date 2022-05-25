import 'package:flutter/material.dart';

import 'Community/community.dart';
import 'Explore/explore.dart';
import 'Home/home.dart';
import 'Notifications/notifications.dart';

class homepage extends StatefulWidget {
  homepage({Key? key, required this.LoginFrom}) : super(key: key);
  String LoginFrom;

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  void initState() {
    super.initState();
    // s = widget.LoginFrom;
  }

//late String s;
  final List<Widget> _pages = <Widget>[
    home(LoginFrom: "Google"), //TODO: maybe need to change the  LoginFrom
    const explore(),
    const notifications(),
    const community()
  ];

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          onTap: _onItemTapped,
        ));
  }
}
