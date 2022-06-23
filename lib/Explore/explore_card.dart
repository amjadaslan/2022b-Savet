import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Posts/Post/post_comment_section.dart';
import '../Posts/similar_content_card.dart';

class explore_card extends StatefulWidget {
   explore_card({Key? key, required this.url}) : super(key: key);
   String url;
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
                      Container(
                        color: Colors.white,
                        child: FadeInImage.assetNetwork(
                            placeholder: 'assets/preloader.gif',
                            image: (this.widget.url)),
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
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Report post'),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  children:  <Widget>[
                                                    Text('Are you sure you want to report this post? If yes, we will review the post to determine wether it violates our Policies.')
                                                  ],
                                                ),
                                              ),
                                              actions:[
                                                TextButton(
                                                  child: Text('Yes, report it'),
                                                  style: ButtonStyle(foregroundColor : MaterialStateProperty.all(Colors.white),
                                                      backgroundColor: MaterialStateProperty.all(Colors.deepOrange)),
                                                  onPressed: () {
                                                    this.widget.url='https://i.pinimg.com/736x/fe/d8/3f/fed83f3a6a2008bb667e15e972452dce.jpg';
                                                    setState(() {});Navigator.of(context).pop(true);}
                                                ),
                                                TextButton(
                                                  child: Text('No'),
                                                  style: ButtonStyle(foregroundColor : MaterialStateProperty.all(Colors.white),
                                                      backgroundColor: MaterialStateProperty.all(Colors.deepOrange)),
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                      },
                                      icon: Icon(Icons.report,
                                          color: Colors.grey[400])),
                                  // IconButton(
                                  //     iconSize: 15,
                                  //     onPressed: () {
                                  //       // Navigator.push(
                                  //       //     context,
                                  //       //     MaterialPageRoute(
                                  //       //         builder: (context) =>
                                  //       //             public_post_comments(
                                  //       //                 post_id: 0,
                                  //       //                 cat_id: 0)));
                                  //     },
                                  //     icon: Icon(Icons.mode_comment_outlined,
                                  //         color: Colors.grey[400])),
                                  // IconButton(
                                  //     iconSize: 18,
                                  //     onPressed: () {
                                  //       setState(() {
                                  //         isPressed = !isPressed;
                                  //       });
                                  //     },
                                  //     icon: (!isPressed)
                                  //         ? Icon(Icons.favorite_border,
                                  //             color: Colors.grey[400])
                                  //         : Icon(Icons.favorite,
                                  //             color: Colors.red))
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
