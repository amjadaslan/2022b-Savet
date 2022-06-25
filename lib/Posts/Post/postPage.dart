import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:savet/Posts/Post/post_comment_section.dart';
import 'package:savet/Posts/similar_content_card.dart';
import 'package:savet/Posts/videoPlayer.dart';
//import 'package:schedule_local_notification/notificationservice.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../Notifications/notificationsHelper.dart';
import '../../Services/user_db.dart';
import '../../main.dart';
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

String token = "";

class _postPageState extends State<postPage> {
  bool isPressed = false;
  List arr = [];

  String _setTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  void initState() {
    super.initState();

    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    bool isHappy = false, isLoved = false;
    var postsIliked = Provider.of<UserDB>(context, listen: false).postsIliked;
    var postsIloved = Provider.of<UserDB>(context, listen: false).postsIloved;
    for (var e in postsIliked) {
      if (e == widget.post_id) {
        isHappy = true;
        break;
      }
    }

    for (var e in postsIloved) {
      if (e == widget.post_id) {
        print("hi");
        isLoved = true;
        break;
      }
    }
    Future<bool> onLikeButtonTapped(bool x) async {
      /// send your request here
      if (!isHappy) {
        await Provider.of<UserDB>(context, listen: false).addLike(
            Provider.of<UserDB>(context, listen: false).user_email,
            widget.user?['email'],
            widget.post_id,
            widget.cat_id);
        Provider.of<UserDB>(context, listen: false)
            .addNotification(widget.user?['email'], ' reacted to your post.');
        sendPushMessage(
            token,
            '',
            '${Provider.of<UserDB>(context, listen: false).username}'
                ' reacted to your post.');
      } else {
        await Provider.of<UserDB>(context, listen: false).removeLike(
            Provider.of<UserDB>(context, listen: false).user_email,
            widget.user?['email'],
            widget.post_id,
            widget.cat_id);
      }
      isHappy = !isHappy;
      return isHappy;
    }

    Future<bool> onLoveButtonTapped(bool x) async {
      /// send your request here
      if (!isLoved) {
        await Provider.of<UserDB>(context, listen: false).addLove(
            Provider.of<UserDB>(context, listen: false).user_email,
            widget.user?['email'],
            widget.post_id,
            widget.cat_id);
        sendPushMessage(
            token,
            '',
            '${Provider.of<UserDB>(context, listen: false).username}'
                ' reacted to your post.');
        Provider.of<UserDB>(context, listen: false)
            .addNotification(widget.user?['email'], ' reacted to your post.');
      } else {
        await Provider.of<UserDB>(context, listen: false).removeLove(
            Provider.of<UserDB>(context, listen: false).user_email,
            widget.user?['email'],
            widget.post_id,
            widget.cat_id);
      }

      isLoved = !isLoved;

      return isLoved;
    }

    String tag;
    List posts;
    String _cat = " ";
    if (widget.user != null) {
      var cat = widget.user!['categories']
          .singleWhere((element) => element['id'] == widget.cat_id);
      posts = cat['posts'];
      tag = cat['tag'];
      _cat = cat['title'];
    } else {
      var cat = Provider.of<UserDB>(context)
          .categories
          .singleWhere((element) => element['id'] == widget.cat_id);
      posts = cat['posts'];
      tag = cat['tag'];
      _cat = cat['title'];
    }
    Map post = {
      'title': "",
      'image':
          "https://cdn.pixabay.com/photo/2020/12/09/09/27/women-5816861_960_720.jpg",
      'cat_id': widget.cat_id,
      'id': widget.post_id,
      'description': "",
      'date': widget.date,
      'time': _setTime,
    };
    for (var e in posts) {
      if (e['id'] == widget.post_id) {
        post = e;
        var te = e['date'];
        print(e);
        print(te);
        if (te != null && te != "" && widget.date == null) {
          try {
            widget.date = te.toDate();
          } catch (e) {
            widget.date = DateTime.now();
          }
          String t = e['time'];
          if (t != null) _setTime = t;
          // widget.date = DateFormat.yMd().format(e['reminder']);
          //DateTime.tryParse(te);
          print(widget.date);
          break;
        }
      }
    }

    return FutureBuilder(
        future: Future.wait(
            [getTagPosts(tag), findTokenByEmail(widget.user?['email'])]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: Text(post['title']),
                actions: [
                  if (widget.user == null)
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
                                    //print(widget.date);
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
                                            initialTime: TimeOfDay(
                                              hour: int.parse(
                                                  _setTime.split(":")[0]),
                                              minute: int.parse(_setTime
                                                  .split(":")[1]
                                                  .split(" ")[0]),
                                            ));
                                        if (time != null) {
                                          Provider.of<UserDB>(context,
                                                  listen: false)
                                              .changeDate(
                                                  widget.cat_id,
                                                  widget.post_id,
                                                  DateTime(
                                                      value.year,
                                                      value.month,
                                                      value.day,
                                                      time.hour,
                                                      time.minute),
                                                  time.format(context));

                                          var image = Image(
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              image:
                                                  NetworkImage(post['image']));

                                          Provider.of<UserDB>(context,
                                                  listen: false)
                                              .addReminder(
                                                  "1",
                                                  "Reminder from Savet",
                                                  "category: $_cat ,post: ${post['title']}",
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
                                              "Category: $_cat ,Post: ${post['title']}",
                                              DateTime(
                                                  value.year,
                                                  value.month,
                                                  value.day,
                                                  time.hour,
                                                  time.minute),
                                              0,
                                              "");
                                          setState(() {
                                            _setTime = time.format(context);
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
                                                  // setState(() async {
                                                  try {
                                                    Provider.of<UserDB>(context,
                                                            listen: false)
                                                        .removePost(post['id'],
                                                            post['cat_id']);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                  // });
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
                            ]),
                  if (widget.user != null)
                    IconButton(
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
                                        "Category: ${_cat} ,Post: ${post['title']},User: ${post['username']}",
                                        DateTime(value.year, value.month,
                                            value.day, time.hour, time.minute),
                                        0,
                                        widget.cat_id,
                                        widget.post_id);
                                scheduleNotification(
                                    notifsPlugin,
                                    " ",
                                    "Reminder from Savet",
                                    "category: ${_cat} ,post: ${post['title']},User: ${post['username']}",
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
                    (post['videoFlag'])
                        ? VideoPlayerScreen(
                            networkFlag: true, url: post['image'])
                        : Image(
                            fit: BoxFit.cover,
                            width: double.infinity,
                            image: NetworkImage(post['image'])),
                    (widget.public_flag)
                        ? Container(
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.deepOrange)),
                                // width: 120,
                                child: (widget.user?['email'] != null)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          LikeButton(
                                            size: 50,
                                            circleColor: CircleColor(
                                                start: Colors.deepOrange,
                                                end: Colors.deepOrange),
                                            bubblesColor: BubblesColor(
                                              dotPrimaryColor:
                                                  Colors.deepOrange,
                                              dotSecondaryColor:
                                                  Colors.deepOrange,
                                            ),
                                            likeBuilder: (isLiked) {
                                              return Icon(
                                                Icons.favorite,
                                                color: (isLoved)
                                                    ? Colors.deepOrange
                                                    : Colors.grey,
                                                size: 40,
                                              );
                                            },
                                            likeCount: post['loves'],
                                            onTap: onLoveButtonTapped,
                                          ),
                                          LikeButton(
                                            size: 50,
                                            circleColor: CircleColor(
                                                start: Colors.deepOrange,
                                                end: Colors.deepOrange),
                                            bubblesColor: BubblesColor(
                                              dotPrimaryColor:
                                                  Colors.deepOrange,
                                              dotSecondaryColor:
                                                  Colors.deepOrange,
                                            ),
                                            likeBuilder: (isLiked) {
                                              return Icon(
                                                Icons.insert_emoticon_sharp,
                                                color: (isHappy)
                                                    ? Colors.deepOrange
                                                    : Colors.grey,
                                                size: 40,
                                              );
                                            },
                                            likeCount: post['likes'],
                                            onTap: onLikeButtonTapped,
                                            // countBuilder: () {}
                                          ),
                                          Container(
                                            width: 120,
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            post_comment_section(
                                                              post_id: widget
                                                                  .post_id,
                                                              cat_id:
                                                                  widget.cat_id,
                                                              user: widget.user,
                                                              token: token,
                                                            )));
                                              },
                                              color: Colors.white,
                                              textColor: Colors.deepOrange,
                                              padding: EdgeInsets.all(13.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.comment),
                                                  Text(" Comment")
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.favorite,
                                                  color: Colors.deepOrange),
                                              Text(' ${post['loves']}')
                                            ],
                                          ),
                                          FlatButton(
                                            onPressed: () {},
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                    Icons.insert_emoticon_sharp,
                                                    color: Colors.deepOrange),
                                                Text(' ${post['likes']}')
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 65,
                                            child: FlatButton(
                                              onPressed: () {},
                                              color: Colors.white,
                                              textColor: Colors.deepOrange,
                                              padding: EdgeInsets.all(13.0),
                                              child: Row(
                                                // Replace with a Row for horizontal icon + text
                                                children: <Widget>[
                                                  Icon(Icons.comment),
                                                  Text(
                                                      ' ${post['comments'].length}')
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )))
                        : const SizedBox(),
                    const SizedBox(height: 10),
                    (!post['description'].isEmpty)
                        ? Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: Text(
                              post['description'],
                              style: const TextStyle(
                                  fontFamily: 'arial',
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: 15),
                            ),
                          )
                        : const SizedBox(height: 30),

                    //  const SizedBox(height: 20),

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

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }

    return time;
  }
}

Future<void> findTokenByEmail(String email) async {
  var s = FirebaseFirestore.instance.collection('tokens').doc(email);
  DocumentSnapshot userSnapshot = await s.get();
  Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
  token = userData['token'];
}
