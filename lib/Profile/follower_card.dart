import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Profile/profile_ext_view.dart';

import '../Services/user_db.dart';

class follower_card extends StatefulWidget {
  follower_card({Key? key, required this.user, this.flag = true})
      : super(key: key);
  Map user;
  bool flag;
  @override
  _follower_cardState createState() => _follower_cardState();
}

class _follower_cardState extends State<follower_card> {
  late Map userUpdated;
  bool already_follow = false;
  @override
  Widget build(BuildContext context) {
    userUpdated = widget.user;
    return FutureBuilder(
        future: updateUser(),
        builder: (context, snapshot) {
          return (userUpdated == null || userUpdated['email'] == null)
              ? SizedBox()
              : InkWell(
                  onTap: () {
                    if (widget.flag) {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => profile_ext_view(
                                user: userUpdated,
                                already_follow: already_follow)),
                      );
                    }
                  },
                  child: Container(
                      padding: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 5),
                          Flex(direction: Axis.horizontal, children: [
                            Flexible(
                              child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      (userUpdated['avatar_path'] == "")
                                          ? CircleAvatar(
                                              radius: 30,
                                              backgroundImage: const AssetImage(
                                                  'assets/images/avatar.jpg'))
                                          : CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  userUpdated['avatar_path'])),
                                      const SizedBox(width: 20),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("${userUpdated['username']}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontSize: 15,
                                                    fontFamily: 'arial',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${userUpdated['followers_count']}",
                                                    style: const TextStyle(
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontSize: 12,
                                                        fontFamily: 'arial',
                                                        color: Colors.black45)),
                                                const Text(" followers",
                                                    style: const TextStyle(
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontSize: 12,
                                                        fontFamily: 'arial',
                                                        color: Colors.black45)),
                                                const SizedBox(width: 40),
                                                Text(
                                                    "${userUpdated['following_count']}",
                                                    style: const TextStyle(
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontSize: 12,
                                                        fontFamily: 'arial',
                                                        color: Colors.black45)),
                                                const Text(" following",
                                                    style: const TextStyle(
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontSize: 12,
                                                        fontFamily: 'arial',
                                                        color: Colors.black45))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            )
                          ]),
                          const SizedBox(height: 5),
                          const Divider()
                        ],
                      )),
                );
        });
  }

  Future<void> updateUser() async {
    userUpdated = await Provider.of<UserDB>(context, listen: false)
        .getUserByEmail(widget.user['email']);
    userUpdated['followers'].forEach((follower) {
      if (follower['username'] ==
          Provider.of<UserDB>(context, listen: false).username)
        already_follow = true;
    });
  }
}
