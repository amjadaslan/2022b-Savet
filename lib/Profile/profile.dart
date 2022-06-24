import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Profile/follower_card.dart';
import 'package:savet/auth/auth_repository.dart';
import 'package:savet/auth/googleLogin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Category/add_category.dart';
import '../Category/profileImage.dart';
import '../Services/user_db.dart';
import '../auth/login_page.dart';
import '../main.dart';

class profile extends StatefulWidget {
  profile({Key? key, required this.LoginFrom}) : super(key: key);
  String LoginFrom;

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    var pWrap = pathWrapper(Provider.of<UserDB>(context).avatar_path);
    var logfrom = (Provider.of<UserDB>(context).log_from);
    // print(logfrom);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          actions: [
            IconButton(
                onPressed: () async {
                  initializeNotifications(out: true);
                  if (widget.LoginFrom == "Email" || logfrom == "Email") {
                    Provider.of<UserDB>(context, listen: false)
                        .resetFetchData();
                    await AuthRepository.instance().signOut();
                  } else if (widget.LoginFrom == "Google" ||
                      logfrom == "Google") {
                    Provider.of<UserDB>(context, listen: false)
                        .resetFetchData();
                    print("try to log out from google");
                    await Google.instance().signOut();
                  } else if (widget.LoginFrom == "Facebook" ||
                      logfrom == "Facebook") {
                    Provider.of<UserDB>(context, listen: false)
                        .resetFetchData();
                    await Login().signOut();
                  }
                  await notifsPlugin.cancelAll();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) => false);
                },
                icon: const Icon(Icons.logout)),
            IconButton(
                onPressed: () {
                  showAboutDialog(
                      context: context,
                      applicationName: 'Savet',
                      applicationVersion: '2.0.0',
                      applicationLegalese: '©️ 2022 Savet all rights reserved',
                      children: <Widget>[
                        InkWell(
                            child: const Text('Privacy Policy'),
                            onTap: () async {
                              var url =
                                  'https://gist.github.com/SiwarK97/dc43067d24e89221da6e1f3f250fd703#file-savet-privacypolicy-md';
                              await launch(url);
                            }),
                        InkWell(
                            child: const Text('Terms & Conditions'),
                            onTap: () async {
                              var url =
                                  'https://gist.github.com/SiwarK97/dc43067d24e89221da6e1f3f250fd703#file-savet-terms-conditions-md';
                              await launch(url);
                            }),
                        // InkWell(
                        // child: const Text('Credits'),
                        // onTap: () async {
                        // var url =
                        // 'https://gist.github.com/mostafanaax69/118ab1cb1cbfa18dcd7ebe0df39b0db4';
                        // await launch(url);
                        // }),
                      ]);
                },

                // showAboutDialog(
                //   context: context,
                //   applicationIcon: FlutterLogo(),
                //   applicationName: 'Savet App',
                //   applicationVersion: '2.0.0',
                //   applicationLegalese: '©2022 Savet-Technion All Rights Reserved',
                //   children: <Widget>[
                //     Padding(
                //         padding: EdgeInsets.only(top: 15),
                //         child: Text('')
                //     )
                //   ],
                // );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const about()),
                // );
                // },
                icon: const Icon(Icons.info_outline)),
            const SizedBox(width: 20),
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
                      maxHeight: MediaQuery.of(context).size.height * 0.55,
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
