import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:savet/Home/follower_card.dart';
import 'package:savet/auth/auth_repository.dart';

import '../Category/add_category.dart';
import '../Category/profileImage.dart';
import '../Chat/message_card.dart';
import '../Services/user_db.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    var pWrap = pathWrapper(Provider.of<UserDB>(context).avatar_path);

    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    Provider.of<AuthRepository>(context, listen: false)
                        .signOut();
                  });
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.logout)),
            SizedBox(width: 20)
          ],
        ),
        body: Container(
            color: Colors.white,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              SizedBox(height: 20),
              profileImage(pWrap: pWrap, shape: "circle", network_flag: true),
              SizedBox(height: 10),
              Container(
                child: Text(
                  'John',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
              SizedBox(height: 10),
              DefaultTabController(
                length: 2,
                child: Column(children: [
                  TabBar(
                    labelColor: Colors.black,
                    tabs: [
                      Tab(
                        text: "Followers",
                      ),
                      Tab(
                        text: "Following",
                      ),
                    ],
                  ),
                  LimitedBox(
                      maxHeight: MediaQuery.of(context).size.height * 0.5813,
                      child: Container(
                        color: Colors.transparent,
                        child: TabBarView(
                          children: [
                            ListView(
                              shrinkWrap: true,
                              children:
                                  List.generate(10, (index) => follower_card()),
                            ),
                            ListView(
                              shrinkWrap: true,
                              children:
                                  List.generate(10, (index) => follower_card()),
                            ),
                          ],
                        ),
                      ))
                ]),
              )
            ])));
  }
}
