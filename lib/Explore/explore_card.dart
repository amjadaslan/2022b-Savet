import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Posts/Post/postPage.dart';

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
                                icon: Icon(Icons.more_vert, color: Colors.grey),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: TextButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            barrierDismissible:
                                            false, // user must tap button!
                                            builder:
                                                (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Report post'),
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
                                                      child: Text('Report'),
                                                      style: ButtonStyle(
                                                          foregroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                              .white),
                                                          backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                              .deepOrange)),
                                                      onPressed: () {
                                                        widget.post[
                                                        'image'] =
                                                        'https://firebasestorage.googleapis.com/v0/b/savet-b9216.appspot.com/o/report.png?alt=media&token=ab9ee150-0bd4-4697-aee9-96b10d7b4959';
                                                        Provider.of<UserDB>(
                                                            context,
                                                            listen:
                                                            false)
                                                            .addToReported(
                                                            widget.post[
                                                            'id']);
                                                        setState(() {});
                                                        Navigator.of(
                                                            context)
                                                            .pop(true);
                                                      }),
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    style: ButtonStyle(
                                                        foregroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                            .white),
                                                        backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                            .deepOrange)),
                                                    onPressed: () =>
                                                        Navigator.of(
                                                            context)
                                                            .pop(false),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(width: 5),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.20,
                                  child: AutoSizeText(
                                    "       ${widget.post['username']}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'arial',
                                        decoration: TextDecoration.none,
                                        color: Colors.black54,
                                        fontSize: 11),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.favorite,
                                        color: Colors.red, size: 13),
                                    SizedBox(width: 2),
                                    Text(
                                      // (alreadyReacted)
                                      //     ? "${widget.post['likes'] + widget.post['loves'] - 1} Likes" :
                                      "${widget.post['likes'] + widget.post['loves']} Likes",
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          decoration: TextDecoration.none,
                                          color: Colors.grey[500],
                                          fontSize: 10),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Material(
                                color: Colors.transparent,
                                child: Row(children: [
                                  IconButton(
                                      iconSize: 15,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    post_comment_section(
                                                        post_id:
                                                        widget.post['id'],
                                                        cat_id: widget
                                                            .post['cat_id'],
                                                        user: widget.user)));
                                      },
                                      icon: Icon(Icons.mode_comment_outlined,
                                          color: Colors.grey[400])),
                                  IconButton(
                                      iconSize: 18,
                                      onPressed: () async {
                                        clicked = 1 - clicked;
                                        if (clicked == 0) {
                                          if (happy) {
                                            await Provider.of<UserDB>(context,
                                                listen: false)
                                                .removeLike(
                                                Provider.of<UserDB>(context,
                                                    listen: false)
                                                    .user_email,
                                                widget.user['email'],
                                                widget.post['id'],
                                                widget.post['cat_id']);

                                            widget.post['likes']--;
                                            happy = false;
                                          } else {
                                            await Provider.of<UserDB>(context,
                                                listen: false)
                                                .removeLove(
                                                Provider.of<UserDB>(context,
                                                    listen: false)
                                                    .user_email,
                                                widget.user['email'],
                                                widget.post['id'],
                                                widget.post['cat_id']);
                                            widget.post['loves']--;
                                          }
                                        } else {
                                          await Provider.of<UserDB>(context,
                                              listen: false)
                                              .addLove(
                                              Provider.of<UserDB>(context,
                                                  listen: false)
                                                  .user_email,
                                              widget.user['email'],
                                              widget.post['id'],
                                              widget.post['cat_id']);
                                          widget.post['loves']++;
                                        }
                                        setState(() {});
                                      },
                                      icon: (clicked == 0)
                                          ? Icon(Icons.favorite_border,
                                          color: Colors.grey[400])
                                          : Icon(Icons.favorite,
                                          color: Colors.red))
                                ])),
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
  }
}