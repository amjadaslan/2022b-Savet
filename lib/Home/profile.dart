import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Home/follower_card.dart';
import 'package:savet/auth/auth_repository.dart';
import 'package:savet/auth/googleLogin.dart';

import '../Category/add_category.dart';
import '../Category/profileImage.dart';
import '../Services/user_db.dart';
import '../auth/login_page.dart';

class profile extends StatefulWidget {
  profile({Key? key, required this.LoginFrom}) : super(key: key);
  String LoginFrom;

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    // var userDocument = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(Provider.of<UserDB>(context).user_email)
    //     .get();
    // print(userDocument["username"]);
    // var user = userDocument['username'];
    // print(FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(AuthRepository.instance().user?.email)
    //     .collection('username'));
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     print(doc["first_name"]);
    //   });
    // });
    var pWrap = pathWrapper(Provider.of<UserDB>(context).avatar_path);
    var username = Provider.of<UserDB>(context).username;
    //var loginFrom = Provider.of<Login>(context).logFtom;
    // final email = FirebaseAuth.instance.currentUser!.email;
    // var methods =
    //     FirebaseAuth.instance.fetchSignInMethodsForEmail(email.toString());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          actions: [
            IconButton(
                onPressed: () async {
                  print("debug");
                  //print(widget.LoginFrom);
                  if (widget.LoginFrom == "Email") {
                    Provider.of<AuthRepository>(context, listen: false)
                        .signOut();
                  } else if (widget.LoginFrom == "Google") {
                    print("try to log out from google");
                    await Google.instance().signOut();
                  } else if (widget.LoginFrom == "Facebook") {
                    await Login().signOut();
                  }
                  setState(() {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const Login()),
                        (Route<dynamic> route) => false);
                  });
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
                  '$username',
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
                                  10, (index) => const follower_card()),
                            ),
                            ListView(
                              shrinkWrap: true,
                              children: List.generate(
                                  10, (index) => const follower_card()),
                            ),
                          ],
                        ),
                      ))
                ]),
              )
            ])));
  }
}
