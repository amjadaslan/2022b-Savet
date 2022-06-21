import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Posts/Post/Reactions.dart';
import 'package:savet/Posts/similar_content_card.dart';
import 'package:savet/Posts/videoPlayer.dart';

import '../../Services/user_db.dart';
import '../edit_post.dart';
import '../similar_content.dart';

class postPage extends StatefulWidget {
  postPage(
      {Key? key,
      required this.cat_id,
      required this.post_id,
      this.user,
      this.public_flag = false})
      : super(key: key);
  Map? user;
  int cat_id;
  int post_id;
  var date;
  bool public_flag;
  @override
  _postPageState createState() => _postPageState();
}

class _postPageState extends State<postPage> {
  bool isPressed = false;
  List arr = [];
  @override
  Widget build(BuildContext context) {
    String tag;
    List posts;
    if (widget.user != null) {
      var cat = widget.user!['categories']
          .singleWhere((element) => element['id'] == widget.cat_id);
      posts = cat['posts'];
      tag = cat['tag'];
    } else {
      var cat = Provider.of<UserDB>(context)
          .categories
          .singleWhere((element) => element['id'] == widget.cat_id);
      posts = cat['posts'];
      tag = cat['tag'];
    }
    Map post = {
      'title': "",
      'image':
          "https://cdn.pixabay.com/photo/2020/12/09/09/27/women-5816861_960_720.jpg",
      'cat_id': widget.cat_id,
      'id': widget.post_id,
      'description': "",
      'reminder': widget.date,
    };
    for (var e in posts) {
      if (e['id'] == widget.post_id) {
        post = e;
        break;
      }
    }
    return FutureBuilder(
        future: getTagPosts(tag),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: Text(post['title']),
                actions: [
                  PopupMenuButton(
                      itemBuilder: (context) => [
                            PopupMenuItem(
                              child: TextButton(
                                onPressed: () async {
                                  print(widget.post_id);
                                  print(widget.cat_id);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => edit_post(
                                                post_id: widget.post_id,
                                                cat_id: widget.cat_id,
                                              )));
                                },
                                child: Text("Edit"),
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
                            PopupMenuItem(
                              child: TextButton(
                                onPressed: () async {
                                  print(widget.date);
                                  await showDatePicker(
                                          context: context,
                                          initialDate:
                                              widget.date ?? DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2050))
                                      .then((value) {
                                    Provider.of<UserDB>(context, listen: false)
                                        .changeDate(
                                            Timestamp.fromDate(DateTime.now()),
                                            widget.post_id);

                                    print(value);

                                    if (value != null) widget.date = value;
                                  });
                                },
                                //prefixIcon: Icon(Icons.add_alert),
                                child: Text(
                                  'Reminder',
                                  //style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              child: TextButton(
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
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.deepOrange)),
                                              onPressed: () {
                                                setState(() {
                                                  Provider.of<UserDB>(context,
                                                          listen: false)
                                                      .removePost(post['id'],
                                                          post['cat_id']);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                });
                                              },
                                            ),
                                            TextButton(
                                              child: const Text("No"),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.deepOrange)),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                // icon: const Icon(Icons.delete),
                                child: Text(
                                  'Delete',
                                  //style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ]),
                  const SizedBox(width: 10),
                ],
              ),
              body: SingleChildScrollView(
                  child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    (widget.user != null)
                        ? Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 5.0, color: Colors.grey[100]!))),
                            child: Container(
                                color: Colors.lightBlue,
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            widget.user!['avatar_path'])),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.user!['username'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontSize: 13,
                                                  fontFamily: 'arial',
                                                  color: Colors.white)),
                                          SizedBox(height: 5),
                                          Text(
                                              "${widget.user!['followers_count']} Followers",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontSize: 11,
                                                  fontFamily: 'arial',
                                                  color: Colors.white))
                                        ]),
                                    TextButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Following a user has not been implemented yet!')));
                                        },
                                        child: const AutoSizeText("Follow",
                                            style:
                                                const TextStyle(fontSize: 10)),
                                        style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            fixedSize: const Size(100, 20),
                                            //shape: const StadiumBorder(),
                                            backgroundColor:
                                                Colors.deepOrangeAccent))
                                  ],
                                )),
                          )
                        : SizedBox(),
                    (post['videoFlag'])
                        ? VideoPlayerScreen(
                            networkFlag: true, url: post['image'])
                        : Image(
                            fit: BoxFit.cover,
                            width: double.infinity,
                            image: NetworkImage(post['image'])),
                    (widget.public_flag)
                        ? Container(
                            // height: MediaQuery.of(context).size.height * 0.12,
                            //  color: Colors.deepOrangeAccent,
                            // child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //children: [
                            //  Material(
                            //   color: Colors.transparent,
                            child: Reaction(
                            cat_id: widget.cat_id,
                            post_id: widget.post_id,
                            user: widget.user ??
                                FirebaseAuth.instance.currentUser,
                          ))
                        //   child: IconButton(
                        //       iconSize: 50,
                        //       onPressed: () {
                        //         setState(() {
                        //           isPressed = !isPressed;
                        //         });
                        //       },
                        //       icon: (!isPressed)
                        //           ? Icon(Icons.favorite_border,
                        //               color: Colors.white)
                        //           : Icon(Icons.favorite,
                        //               color: Colors.white))
                        //  ),
                        //    const VerticalDivider(
                        //      color: Colors.white,
                        //      thickness: 3,
                        //      indent: 5,
                        //      endIndent: 5,
                        //    ),
                        // Material(
                        //     color: Colors.transparent,
                        //     child: IconButton(
                        //         iconSize: 40,
                        //         onPressed: () {
                        //           Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                   builder: (context) =>
                        //                       post_comment_section(
                        //                         post_id: post['id'],
                        //                         cat_id: post['cat_id'],
                        //                       )));
                        //         },
                        //         icon: Icon(Icons.mode_comment_outlined,
                        //             color: Colors.white))),
                        //   ],
                        // ),
                        // )
                        : const SizedBox(),
                    const SizedBox(height: 20),
                    (widget.public_flag)
                        ? Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.favorite, color: Colors.red, size: 30),
                              SizedBox(width: 5),
                              Text(
                                '0',
                                //'${Provider.of<UserDB>(context).categories[widget.cat_id]['posts'][widget.post_id]['likes']}',
                                style: TextStyle(
                                    fontFamily: 'arial',
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    color: Colors.black54,
                                    fontSize: 20),
                              )
                            ],
                          )
                        : const SizedBox(),
                    (!post['description'].isEmpty)
                        ? Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: Text(
                              post['description'],
                              style: const TextStyle(
                                  fontFamily: 'arial',
                                  decoration: TextDecoration.none,
                                  color: Colors.black54,
                                  fontSize: 15),
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(height: (widget.public_flag) ? 30 : 0),
                    (arr.length > 0)
                        ? Container(
                            child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "   Similar Content",
                                    style: TextStyle(
                                        fontFamily: 'arial',
                                        decoration: TextDecoration.none,
                                        color: Colors.black,
                                        fontSize: 15),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    similar_content(arr: arr)));
                                      },
                                      child: const Text("VIEW ALL",
                                          style: TextStyle(
                                              fontFamily: 'arial',
                                              color: Colors.deepOrangeAccent,
                                              fontSize: 13)))
                                ],
                              ),
                              Container(
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                            (arr.length > 10) ? 10 : arr.length,
                                            (index) {
                                          return similar_content_card(
                                              post: arr[index]);
                                        }),
                                      )))
                            ],
                          ))
                        : SizedBox()
                  ],
                ),
              )));
        });
  }

  Future<void> getTagPosts(String tag) async {
    arr.clear();
    if (tag == "Private") return;
    var snapshot = (await FirebaseFirestore.instance.collection('users').get());
    var users = snapshot.docs.map((doc) => doc.data()).toList();
    for (var user in users) {
      user['categories'].forEach((c) {
        if (c['id'] != 0 && tag == c['tag']) {
          arr = [...arr, ...c['posts']];
        }
      });
    }

    arr.removeWhere((post) => post['id'] == widget.post_id);
  }
}
