import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Posts/Post/postPage.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Posts/Post/post_comment_section.dart';
import '../Posts/similar_content_card.dart';
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
  bool isPressed = false;
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
                                          user: widget.user)));
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
                                Text(
                                  "  ${widget.post['username']}",
                                  style: TextStyle(
                                      fontFamily: 'arial',
                                      decoration: TextDecoration.none,
                                      color: Colors.black54,
                                      fontSize: 11),
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Icon(Icons.favorite,
                                        color: Colors.red, size: 13),
                                    SizedBox(width: 2),
                                    Text(
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
                                      onPressed: () {
                                        setState(() {
                                          isPressed = !isPressed;
                                        });
                                      },
                                      icon: (!isPressed)
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
