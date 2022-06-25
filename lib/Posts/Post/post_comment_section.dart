import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Posts/videoPlayer.dart';

import '../../Notifications/notificationsHelper.dart';
import '../../Services/user_db.dart';
import '../../main.dart';
import '../Comment_Section/comment_card.dart';
import '../edit_post.dart';

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
  Map post = {};
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPost(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(post['title']),
              actions: [
                (widget.user == null)
                    ? PopupMenuButton(
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
                                    await showDatePicker(
                                            context: context,
                                            initialDate:
                                                widget.date ?? DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2050))
                                        .then((value) async {
                                      if (value != null) {
                                        var time = await showTimePicker(
                                          initialEntryMode:
                                              TimePickerEntryMode.input,
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        if (time != null) {
                                          // Provider.of<UserDB>(context,
                                          //         listen: false)
                                          //     .changeDate(
                                          //         widget.cat_id,
                                          //         widget.post_id,
                                          //         DateTime(
                                          //             value.year,
                                          //             value.month,
                                          //             value.day,
                                          //             time.hour,
                                          //             time.minute),
                                          //         time.format(context));
                                          //String id, String title, String body,
                                          //       DateTime scheduledTime, int not_id, int cat_id, int post_id
                                          Provider.of<UserDB>(context,
                                                  listen: false)
                                              .addReminder(
                                                  "1",
                                                  "Reminder from Savet",
                                                  "Category: ${widget.cat_id} ,Post: ${post['title']}",
                                                  DateTime(
                                                      value.year,
                                                      value.month,
                                                      value.day,
                                                      time.hour,
                                                      time.minute),
                                                  0,
                                                  widget.cat_id,
                                                  widget.post_id);
                                          scheduleNotification(
                                              notifsPlugin,
                                              " ",
                                              "Reminder from Savet",
                                              "category: ${widget.cat_id} ,post: ${post['title']}",
                                              DateTime(
                                                  value.year,
                                                  value.month,
                                                  value.day,
                                                  time.hour,
                                                  time.minute),
                                              0,
                                              "");
                                          setState(() {
                                            print(value);
                                            widget.date = value;
                                          });
                                        }
                                        print(value);
                                      }
                                    });
                                    Navigator.pop(context);
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
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .deepOrange)),
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
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .deepOrange)),
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
                            ])
                    : IconButton(
                        onPressed: () async {
                          await showDatePicker(
                                  context: context,
                                  initialDate: widget.date ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2050))
                              .then((value) async {
                            if (value != null) {
                              var time = await showTimePicker(
                                initialEntryMode: TimePickerEntryMode.input,
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                // Provider.of<UserDB>(context,
                                //         listen: false)
                                //     .changeDate(
                                //         widget.cat_id,
                                //         widget.post_id,
                                //         DateTime(
                                //             value.year,
                                //             value.month,
                                //             value.day,
                                //             time.hour,
                                //             time.minute),
                                //         time.format(context));
                                //String id, String title, String body,
                                //       DateTime scheduledTime, int not_id, int cat_id, int post_id
                                Provider.of<UserDB>(context, listen: false)
                                    .addReminder(
                                        "1",
                                        "Reminder from Savet",
                                        "Category: ${widget.cat_id} ,Post: ${post['title']}",
                                        DateTime(value.year, value.month,
                                            value.day, time.hour, time.minute),
                                        0,
                                        widget.cat_id,
                                        widget.post_id);
                                scheduleNotification(
                                    notifsPlugin,
                                    " ",
                                    "Reminder from Savet",
                                    "category: ${widget.cat_id} ,post: ${post['title']}",
                                    DateTime(value.year, value.month, value.day,
                                        time.hour, time.minute),
                                    0,
                                    "");
                                setState(() {
                                  print(value);
                                  widget.date = value;
                                });
                              }
                              print(value);
                            }
                          });
                        },
                        icon: Icon(Icons.add_alert)),
                const SizedBox(width: 10),
              ],
            ),
            body: SingleChildScrollView(
                child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  (post['videoFlag'] != null && post['videoFlag'] == true)
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
                        children:
                            List.generate(post['comments'].length + 1, (index) {
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
                        decoration:
                            InputDecoration(hintText: "Add a comment..."),
                        style: TextStyle(fontSize: 13))),
                TextButton(
                    onPressed: () async {
                      if (commentController.text.isNotEmpty) {
                        Map comment = {
                          'username':
                              Provider.of<UserDB>(context, listen: false)
                                  .username,
                          'avatar_path':
                              Provider.of<UserDB>(context, listen: false)
                                  .avatar_path,
                          'content': commentController.text
                        };
                        await Provider.of<UserDB>(context, listen: false)
                            .addCommentToPost(widget.user?['email'],
                                widget.post_id, widget.cat_id, comment);
                        post['comments'].add(comment);
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
        });
  }

  Future<void> getPost() async {
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
    for (var e in posts) {
      if (e['id'] == widget.post_id) {
        post = e;
        break;
      }
    }
  }
}
