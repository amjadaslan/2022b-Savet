import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Posts/similar_content_card.dart';
import 'package:savet/Posts/Comment_Section/comment_card.dart';

import '../../Services/user_db.dart';
import '../Comment_Section/comment_card.dart';

class public_post_comments extends StatefulWidget {
  public_post_comments({Key? key, required this.cat_id, required this.post_id})
      : super(key: key);
  int cat_id;
  int post_id;

  @override
  _public_post_commentsState createState() => _public_post_commentsState();
}

class _public_post_commentsState extends State<public_post_comments> {
  @override
  Widget build(BuildContext context) {
    Map post = Provider.of<UserDB>(context).categories[widget.cat_id]['posts']
        [widget.post_id];

    return Scaffold(
        appBar: AppBar(
          title: Text('Post Title'),
          actions: [
            const Icon(Icons.add_alert),
            const SizedBox(width: 20),
            const Icon(Icons.share),
            const SizedBox(width: 20),
            IconButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Post"),
                          content: const Text(
                              "Are you sure you want to delete this post?"),
                          actions: [
                            TextButton(
                              child: const Text("Yes"),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.deepOrange)),
                              onPressed: () {
                                setState(() {
                                  Provider.of<UserDB>(context, listen: false)
                                      .removePost(post['id'], post['cat_id']);
                                  Navigator.pop(context);
                                });
                              },
                            ),
                            TextButton(
                              child: const Text("No"),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.deepOrange)),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.delete)),
            const SizedBox(width: 20)
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
                thickness: 1,
              ),
              Container(
                child: Column(
                    children: List.generate(20, (index) {
                  if (index == 19)
                    return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.1);
                  return comment();
                })),
              ),
              Divider(),
            ],
          ),
        )),
        bottomSheet: Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
          child: Row(children: [
            SizedBox(width: 15),
            const CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage('https://i.ibb.co/CwTL6Br/1.jpg')),
            SizedBox(width: 15),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                    decoration: InputDecoration(hintText: "Add a comment..."),
                    style: TextStyle(fontSize: 13))),
            TextButton(
                onPressed: () {},
                child: const Text("Post",
                    style: TextStyle(
                        fontFamily: 'arial',
                        color: Colors.deepOrangeAccent,
                        fontSize: 13)))
          ]),
        ));
  }
}
