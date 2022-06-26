import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Posts/Post/postPage.dart';
import 'package:savet/main.dart';

import '../Posts/Post/post_comment_section.dart';
import '../Services/user_db.dart';

class explore_card extends StatefulWidget {
  explore_card({Key? key, required this.post, required this.user})
      : super(key: key);
  Map post;
  Map user;
  @override
  _explore_cardState createState() => _explore_cardState();
}

class _explore_cardState extends State<explore_card> {
  bool alreadyReacted = false;
  int clicked = 0;
  bool happy = false;
  String token = "";
  @override
  void initState() {
    Provider.of<UserDB>(context, listen: false).postsIliked.forEach((p) {
      if (p == widget.post['id']) {
        alreadyReacted = true;
        happy = true;
      }
    });
    Provider.of<UserDB>(context, listen: false).postsIloved.forEach((p) {
      if (p == widget.post['id']) alreadyReacted = true;
    });
    if (alreadyReacted) clicked = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: findTokenByEmail(widget.user['email']),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Container(
            padding: EdgeInsets.fromLTRB(2, 3, 2, 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    flex: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.black12,
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => postPage(
                                                  cat_id: widget.post['cat_id'],
                                                  post_id: widget.post['id'],
                                                  user: widget.user,
                                                  public_flag: true,
                                                )));
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/preloader.gif',
                                        image: (this.widget.post['image'])),
                                  ),
                                ),
                                Positioned(
                                  top: -5.0,
                                  right: -10.0,
                                  child: PopupMenuButton(
                                      icon: Icon(Icons.more_vert,
                                          color: Colors.grey),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible:
                                                          false, // user must tap button!
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Report post'),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              children: const <
                                                                  Widget>[
                                                                Text(
                                                                    'Are you sure you want to report this post?')
                                                              ],
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                                child: Text(
                                                                    'Report'),
                                                                style: ButtonStyle(
                                                                    foregroundColor:
                                                                        MaterialStateProperty.all(Colors
                                                                            .white),
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            Colors.deepOrange)),
                                                                onPressed: () {
                                                                  widget.post[
                                                                          'image'] =
                                                                      'https://firebasestorage.googleapis.com/v0/b/savet-b9216.appspot.com/o/report.png?alt=media&token=ab9ee150-0bd4-4697-aee9-96b10d7b4959';
                                                                  Provider.of<UserDB>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .addToReported(
                                                                          widget
                                                                              .post['id']);
                                                                  setState(
                                                                      () {});
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true);
                                                                }),
                                                            TextButton(
                                                              child: Text(
                                                                  'Cancel'),
                                                              style: ButtonStyle(
                                                                  foregroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .white),
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .deepOrange)),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Row(
                                                  children: const [
                                                    Icon(Icons.report),
                                                    Text("Report")
                                                  ],
                                                ),
                                                //prefixIcon: Icon(Icons.add_alert),
                                                // child: Container(
                                                //   decoration: BoxDecoration(),
                                                //   child: Center(
                                                //     child: Text(
                                                //       'Edit',
                                                //       style: TextStyle(
                                                //         fontFamily: 'Arial',
                                                //         fontSize: 18,
                                                //         color: Colors.deepOrange,
                                                //       ),
                                                //       textAlign: TextAlign.center,
                                                //     ),
                                                //   ),
                                                // ),
                                              ),
                                            ),
                                          ]),
                                )
                              ],
                            ),
                            Container(
                              height: 40,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                      radius: 10,
                                      backgroundImage: (widget
                                                  .user['avatar_path'] !=
                                              "")
                                          ? NetworkImage(
                                              widget.user['avatar_path'])
                                          : const AssetImage(
                                                  'assets/images/avatar.jpg')
                                              as ImageProvider),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.favorite,
                                          color: Colors.red, size: 15),
                                      SizedBox(width: 2),
                                      AutoSizeText(
                                        "${widget.post['likes'] + widget.post['loves']} Likes",
                                        style: TextStyle(
                                            fontFamily: 'arial',
                                            decoration: TextDecoration.none,
                                            color: Colors.grey[500],
                                            fontSize: 5),
                                        maxFontSize: 13,
                                      )
                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                            iconSize: 15,
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          post_comment_section(
                                                              post_id: widget
                                                                  .post['id'],
                                                              cat_id:
                                                                  widget.post[
                                                                      'cat_id'],
                                                              user: widget
                                                                  .user)));
                                            },
                                            icon: Icon(
                                                Icons.mode_comment_outlined,
                                                color: Colors.grey[400])),
                                        SizedBox(width: 10),
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                            iconSize: 18,
                                            onPressed: () async {
                                              clicked = 1 - clicked;
                                              if (clicked == 0) {
                                                if (happy) {
                                                  await Provider.of<UserDB>(
                                                          context,
                                                          listen: false)
                                                      .removeLike(
                                                          Provider.of<UserDB>(
                                                                  context,
                                                                  listen: false)
                                                              .user_email,
                                                          widget.user['email'],
                                                          widget.post['id'],
                                                          widget
                                                              .post['cat_id']);

                                                  widget.post['likes']--;
                                                  happy = false;
                                                } else {
                                                  await Provider.of<UserDB>(
                                                          context,
                                                          listen: false)
                                                      .removeLove(
                                                          Provider.of<UserDB>(
                                                                  context,
                                                                  listen: false)
                                                              .user_email,
                                                          widget.user['email'],
                                                          widget.post['id'],
                                                          widget
                                                              .post['cat_id']);
                                                  widget.post['loves']--;
                                                }
                                              } else {
                                                await Provider.of<UserDB>(
                                                        context,
                                                        listen: false)
                                                    .addLove(
                                                        Provider.of<UserDB>(
                                                                context,
                                                                listen: false)
                                                            .user_email,
                                                        widget.user['email'],
                                                        widget.post['id'],
                                                        widget.post['cat_id']);
                                                widget.post['loves']++;
                                                sendPushMessage(
                                                    token,
                                                    '',
                                                    '${Provider.of<UserDB>(context, listen: false).username}'
                                                        ' reacted to your post.');
                                              }
                                              setState(() {});
                                            },
                                            icon: (clicked == 0)
                                                ? Icon(Icons.favorite_border,
                                                    color: Colors.grey[400])
                                                : Icon(Icons.favorite,
                                                    color: Colors.red))
                                      ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          );
        });
  }

  Future<void> findTokenByEmail(String email) async {
    var s = FirebaseFirestore.instance.collection('tokens').doc(email);
    DocumentSnapshot userSnapshot = await s.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    token = userData['token'];
  }
}
