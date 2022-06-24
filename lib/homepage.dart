import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'Community/community.dart';
import 'Explore/explore.dart';
import 'Home/home.dart';
import 'Notifications/notifications.dart';
import 'Posts/add_shared.dart';

class homepage extends StatefulWidget {
  homepage({Key? key, required this.LoginFrom, this.sharedFiles})
      : super(key: key);
  String LoginFrom;
  List? sharedFiles;

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  late final List<Widget> _pages;

  void initState() {
    super.initState();
    _pages = <Widget>[
      (widget.sharedFiles != null && widget.sharedFiles!.isNotEmpty)
          ? add_shared(
              sharedFiles: widget.sharedFiles ?? [],
            )
          : home(LoginFrom: widget.LoginFrom),
      const explore(),
      const notifications(),
      const community()
    ];
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser;
    bool isAnonymous = auth!.isAnonymous;
    if (!isAnonymous) {
      return Scaffold(
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: "Explore"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: "Notification"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people), label: "Community"),
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
                //if (index != 2)
                _selectedIndex = index;
              });
            },
          ));
    } else {
      //Anonymous
      print(auth.uid);
      return Scaffold(
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search_off,
                  ),
                  label: "Explore"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_off), label: "Notification"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.close_sharp), label: "Community"),
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
                if (index != 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please login')));
                } else {
                  _selectedIndex = 0;
                }
              });
            },
          ));
    }
  }
}
