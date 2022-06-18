import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Posts/similar_content_card.dart';
import 'package:savet/Posts/videoPlayer.dart';
import '../../Services/user_db.dart';
import '../Comment_Section/comment_card.dart';
import '../edit_post.dart';
import '../similar_content.dart';

class post_comment_section extends StatefulWidget {
  post_comment_section(
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
  _post_comment_sectionState createState() => _post_comment_sectionState();
}

class _post_comment_sectionState extends State<post_comment_section> {
  bool isPressed = false;
  TextEditingController commentController = TextEditingController();
  List arr = [];
  @override
  Widget build(BuildContext context) {
    List posts;
    if (widget.user != null) {
      var cat = widget.user!['categories']
          .singleWhere((element) => element['id'] == widget.cat_id);
      posts = cat['posts'];
    } else {
      var cat = Provider.of<UserDB>(context)
          .categories
          .singleWhere((element) => element['id'] == widget.cat_id);
      posts = cat['posts'];
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
    return Scaffold(
      appBar: AppBar(
        title: Text(post['title']),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: TextButton(
                        onPressed: () async {
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
                                  initialDate: widget.date ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2050))
                              .then((value) {
                            Provider.of<UserDB>(context, listen: false)
                                .changeDate(Timestamp.fromDate(DateTime.now()),
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
                                              .removePost(
                                                  post['id'], post['cat_id']);
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
                                      onPressed: () => Navigator.pop(context),
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
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(widget.user!['avatar_path'])),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.user!['username'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                          fontSize: 13,
                                          fontFamily: 'arial',
                                          color: Colors.white)),
                                  SizedBox(height: 5),
                                  Text(
                                      "${widget.user!['followers_count']} Followers",
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 11,
                                          fontFamily: 'arial',
                                          color: Colors.white))
                                ]),
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
                  )
                : SizedBox(),
            (post['videoFlag'])
                ? VideoPlayerScreen(networkFlag: true, url: post['image'])
                : Image(
                    fit: BoxFit.cover,
                    width: double.infinity,
                    image: NetworkImage(post['image'])),
            Divider(
              thickness: 1,
            ),
            Container(
              child: Column(
                  children: List.generate(post['comments'].length + 1, (index) {
                if (index == post['comments'].length)
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.1);
                return comment(content: post['comments'][index]);
              })),
            ),
            Divider()
          ],
        ),
      )),
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
        child: Row(children: [
          SizedBox(width: 15),
          CircleAvatar(
              radius: 30,
              backgroundImage:
                  NetworkImage(Provider.of<UserDB>(context).avatar_path)),
          SizedBox(width: 15),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(hintText: "Add a comment..."),
                  style: TextStyle(fontSize: 13))),
          TextButton(
              onPressed: () async {
                if (commentController.text.isNotEmpty) {
                  Map comment = {
                    'username':
                        Provider.of<UserDB>(context, listen: false).username,
                    'avatar_path':
                        Provider.of<UserDB>(context, listen: false).avatar_path,
                    'content': commentController.text
                  };
                  await Provider.of<UserDB>(context, listen: false)
                      .addCommentToPost(widget.user?['email'], widget.post_id,
                          widget.cat_id, comment);
                  commentController.clear();
                  setState(() {});
                }
              },
              child: Text("Post",
                  style: TextStyle(
                      fontFamily: 'arial',
                      color: (commentController.text.isNotEmpty)
                          ? Colors.deepOrangeAccent
                          : Colors.deepOrange[100],
                      fontSize: 13)))
        ]),
      ),
    );
  }
}
