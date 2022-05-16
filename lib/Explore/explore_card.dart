import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../Posts/Public_Post/public_post_comments.dart';
import '../Posts/similar_content_card.dart';

class explore_card extends StatefulWidget {
  const explore_card({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  _explore_cardState createState() => _explore_cardState();
}

class _explore_cardState extends State<explore_card> {
  @override
  Widget build(BuildContext context) {
    bool isPressed = false;
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
                      Image(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(this.widget.url)),
                      Container(
                        height: 40,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "  @username",
                                  style: TextStyle(
                                      fontFamily: 'arial',
                                      decoration: TextDecoration.none,
                                      color: Colors.black54,
                                      fontSize: 11),
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(Icons.favorite,
                                        color: Colors.red, size: 10),
                                    SizedBox(width: 2),
                                    Text(
                                      "1,828 Likes",
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
                                                    const public_post_comments()));
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
                                              color: Colors.grey[400]))
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
