import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:savet/Posts/Post/post_comment_section.dart';

import '../Posts/Post/post_comment_section.dart';

class community_post extends StatefulWidget {
   community_post({Key? key, required this.url}) : super(key: key);
   String url;
  @override
  _community_postState createState() => _community_postState();
}

class _community_postState extends State<community_post> {
  @override
  Widget build(BuildContext context) {
    bool isPressed = false;
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
                            image: NetworkImage(this.widget.url)),

                        Container(
                          color: Colors.white,

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.favorite,
                                            color: Colors.red, size: 14),
                                        SizedBox(width: 2),
                                        Text(
                                          "1,828 Likes",
                                          style: TextStyle(
                                              fontFamily: 'arial',
                                              decoration: TextDecoration.none,
                                              color: Colors.grey[700],
                                              fontSize: 13),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    AutoSizeText(
                                      "@username",
                                      style: TextStyle(
                                          fontFamily: 'arial',
                                          decoration: TextDecoration.none,
                                          color: Colors.black87,
                                          fontSize: 15),
                                    ),
                                    SizedBox(height: 5),
                                    AutoSizeText(
                                      "Post Description________________________________________________________________________________________________________________________________________________________________",
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
                    Flexible(
                      flex: 10,
                              child:
                              Material(
                                  color: Colors.transparent,
                                  child: Row(mainAxisSize: MainAxisSize.min,
                                      children: [
                                    IconButton(
                                        iconSize: 20,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      post_comment_section(
                                                          post_id: 0,
                                                          cat_id: 0)));
                                        },
                                        icon: Icon(Icons.mode_comment_outlined,
                                            color: Colors.grey[400])),
                                    IconButton(
                                        iconSize: 20,
                                        onPressed: () {
                                          setState(() {
                                            isPressed = !isPressed;
                                          });
                                        },
                                        icon: (!isPressed)
                                            ? Icon(Icons.favorite_border,
                                                color: Colors.grey[400])
                                            : Icon(Icons.favorite,
                                                color: Colors.grey[400])),

                                        IconButton(
                                            iconSize: 20,
                                            onPressed: () {
                                               this.widget.url='https://i.pinimg.com/736x/fe/d8/3f/fed83f3a6a2008bb667e15e972452dce.jpg';
                                              setState(() {});
                                            },
                                            icon: Icon(Icons.report,
                                                color: Colors.grey[400])),
                                  ])),)
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
  }
}
