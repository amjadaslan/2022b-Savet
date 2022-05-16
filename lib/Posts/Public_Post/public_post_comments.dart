import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:savet/Posts/similar_content_card.dart';
import 'package:savet/Posts/Comment_Section/comment_card.dart';

import '../Comment_Section/comment_card.dart';

class public_post_comments extends StatefulWidget {
  const public_post_comments({Key? key}) : super(key: key);

  @override
  _public_post_commentsState createState() => _public_post_commentsState();
}

class _public_post_commentsState extends State<public_post_comments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back),
          title: Text('Post Title'),
          actions: [
            Icon(Icons.add_alert),
            SizedBox(width: 20),
            Icon(Icons.share),
            SizedBox(width: 20)
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                  color: Colors.lightBlue,
                  child: Row(
                    children: [
                      const SizedBox(height: 75),
                      const SizedBox(width: 20),
                      const CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage('https://i.ibb.co/CwTL6Br/1.jpg')),
                      const SizedBox(width: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Michael Hendley",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 13,
                                    fontFamily: 'arial',
                                    color: Colors.white)),
                            SizedBox(height: 5),
                            Text("270 Followers",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 10,
                                    fontFamily: 'arial',
                                    color: Colors.white))
                          ]),
                      const SizedBox(width: 50),
                      TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Following a user has not been implemented yet!')));
                          },
                          child: const AutoSizeText("Follow",
                              style: const TextStyle(fontSize: 10)),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              fixedSize: const Size(100, 20),
                              //shape: const StadiumBorder(),
                              backgroundColor: Colors.deepOrangeAccent))
                    ],
                  )),
              Container(
                width: MediaQuery.of(context).size.width,
                child: const Image(
                    fit: BoxFit.fitWidth,
                    image: NetworkImage('https://i.ibb.co/kGwjjp0/1.png')),
              ),
              Divider(
                thickness: 2,
              ),
              Container(
                height: 300.0,
                child: ListView(
                    children: List.generate(20, (index) {
                  return comment();
                })),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(children: [
                  SizedBox(width: 15),
                  const CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          NetworkImage('https://i.ibb.co/CwTL6Br/1.jpg')),
                  SizedBox(width: 15),
                  SizedBox(
                      width: 257,
                      child: TextField(
                          decoration:
                              InputDecoration(hintText: "Add a comment..."),
                          style: TextStyle(fontSize: 13))),
                  TextButton(
                      onPressed: () {},
                      child: const Text("Post",
                          style: TextStyle(
                              fontFamily: 'arial',
                              color: Colors.deepOrangeAccent,
                              fontSize: 13)))
                ]),
              )
            ],
          ),
        )));
  }
}
