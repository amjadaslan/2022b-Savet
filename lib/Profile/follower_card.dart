import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:savet/Profile/profile_ext_view.dart';

class follower_card extends StatefulWidget {
  follower_card({Key? key, required this.user, this.flag = true})
      : super(key: key);
  Map user;
  bool flag;
  @override
  _follower_cardState createState() => _follower_cardState();
}

class _follower_cardState extends State<follower_card> {
  @override
  Widget build(BuildContext context) {
    return (widget.user.isEmpty && widget.user['email'] == null)
        ? SizedBox()
        : InkWell(
            onTap: () {
              if (widget.flag) {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          profile_ext_view(user: widget.user)),
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
                                (widget.user['avatar_path'] == "")
                                    ? CircleAvatar(
                                        radius: 30,
                                        backgroundImage: const AssetImage(
                                            'assets/images/avatar.jpg'))
                                    : CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            widget.user['avatar_path'])),
                                const SizedBox(width: 20),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${widget.user['username']}",
                                          maxLines: 1,
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
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
                                              "${widget.user['followers_count']}",
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
                                              "${widget.user['following_count']}",
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
  }
}
