import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:savet/Profile/follower_card.dart';
import 'package:savet/auth/auth_repository.dart';

import '../Category/add_category.dart';
import '../Category/profileImage.dart';
import '../Chat/message_card.dart';
import '../Services/user_db.dart';
import '../auth/login_page.dart';

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
          title: const Text("Profile"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    Provider.of<AuthRepository>(context, listen: false)
                        .signOut();
                  });
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (Route<dynamic> route) => false);
                  // Navigator.of(context).pop();
                },
                icon: const Icon(Icons.logout)),
            const SizedBox(width: 20)
          ],
        ),
        body: Container(
            color: Colors.white,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const SizedBox(height: 20),
              profileImage(
                  pWrap: pWrap,
                  shape: "circle",
                  network_flag: true,
                  profile_pic: true),
              const SizedBox(height: 10),
              Container(
                child: Text(
                  '${Provider.of<UserDB>(context).username}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),
              DefaultTabController(
                length: 2,
                child: Column(children: [
                  const TabBar(
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
                              children: List.generate(
                                  Provider.of<UserDB>(context, listen: false)
                                      .followers
                                      .length,
                                  (index) => follower_card(
                                      user: Provider.of<UserDB>(context,
                                              listen: false)
                                          .followers[index],
                                      flag: false)),
                            ),
                            ListView(
                              shrinkWrap: true,
                              children: List.generate(
                                  Provider.of<UserDB>(context, listen: false)
                                      .following
                                      .length,
                                  (index) => follower_card(
                                      user: Provider.of<UserDB>(context,
                                              listen: false)
                                          .following[index],
                                      flag: false)),
                            ),
                          ],
                        ),
                      ))
                ]),
              )
            ])));
  }
}
