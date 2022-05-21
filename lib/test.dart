import 'package:flutter/material.dart';
import 'package:savet/Posts/Public_Post/public_post.dart';
import 'package:savet/Explore/explore_card.dart';

import 'Chat/chat.dart';
import 'Chat/message_card.dart';
import 'Explore/explore.dart';
import 'Community/community.dart';
import 'Community/community_post_card.dart';
import 'Notifications/notification_card.dart';
import 'Posts/Private_Post/private_post.dart';
import 'homepage.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => public_post()));
                },
                child: Text("Public Post", style: TextStyle(fontSize: 15)),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    fixedSize: const Size(200, 40),
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.blueAccent)),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => private_post()));
                },
                child: Text("Private Post", style: TextStyle(fontSize: 15)),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    fixedSize: const Size(200, 40),
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.blueAccent)),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => homepage()));
                },
                child: Text("HomePage", style: TextStyle(fontSize: 15)),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    fixedSize: const Size(200, 40),
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.blueAccent))
          ],
        ));
  }
}
