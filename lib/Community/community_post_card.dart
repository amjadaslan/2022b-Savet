import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Posts/Post/post_comment_section.dart';

import '../Posts/Post/post_comment_section.dart';
import '../Services/user_db.dart';

class community_post extends StatefulWidget {
  const community_post({Key? key, required this.post}) : super(key: key);
  final Map post;
  @override
  _community_postState createState() => _community_postState();
}

class _community_postState extends State<community_post> {
  Map? user;
  @override
  Widget build(BuildContext context) {
    bool isPressed = false;
    return FutureBuilder(
        future: getUser(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Container(
            padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    flex: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: (Colors.black12),
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          //color: Colors.white,
                          child: Column(
                            children: [
                              Image(
                                  fit: BoxFit.fill,
                                  width: MediaQuery.of(context).size.width,
                                  image: NetworkImage(widget.post['image'])),
                              Container(
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10.0, 0, 0, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(Icons.favorite,
                                                  color: Colors.red, size: 14),
                                              SizedBox(width: 2),
                                              Text(
                                                "${widget.post['likes']} Likes",
                                                style: TextStyle(
                                                    fontFamily: 'arial',
                                                    decoration:
                                                        TextDecoration.none,
                                                    color: Colors.grey[700],
                                                    fontSize: 13),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          AutoSizeText(
                                            "${widget.post['username']}",
                                            style: TextStyle(
                                                fontFamily: 'arial',
                                                decoration: TextDecoration.none,
                                                color: Colors.black87,
                                                fontSize: 15),
                                          ),
                                          SizedBox(height: 5),
                                          AutoSizeText(
                                            "${widget.post['title']}",
                                            style: TextStyle(
                                                fontFamily: 'arial',
                                                decoration: TextDecoration.none,
                                                color: Colors.black54,
                                                fontSize: 11),
                                          ),
                                          SizedBox(height: 5),
                                          AutoSizeText(
                                            "${widget.post['description']}",
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'arial',
                                                decoration: TextDecoration.none,
                                                color: Colors.black54,
                                                fontSize: 11),
                                          ),
                                          SizedBox(height: 8)
                                        ],
                                      ),
                                    ),
                                    Material(
                                        color: Colors.transparent,
                                        child: Row(children: [
                                          IconButton(
                                              iconSize: 50,
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
                                                              user: user,
                                                            )));
                                              },
                                              icon: Icon(
                                                  Icons.mode_comment_outlined,
                                                  color: Colors.grey[400])),
                                          IconButton(
                                              iconSize: 50,
                                              onPressed: () {
                                                setState(() {
                                                  isPressed = !isPressed;
                                                });
                                              },
                                              icon: (!isPressed)
                                                  ? Icon(Icons.favorite_border,
                                                      color: Colors.grey[400])
                                                  : Icon(Icons.favorite,
                                                      color: Colors.grey[400]))
                                        ])),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          );
        });
  }

  Future<void> getUser() async {
    user =
        await Provider.of<UserDB>(context).getUserByEmail(widget.post['email']);
  }
}
