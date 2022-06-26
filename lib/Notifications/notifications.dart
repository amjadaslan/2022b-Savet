import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Notifications/notification_card.dart';

import '../Services/user_db.dart';

class notifications extends StatefulWidget {
  const notifications({Key? key}) : super(key: key);

  @override
  _notificationsState createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  List<String> notifs = [
    " commented on your post.",
    " reacted to your post.",
    " started following you."
  ];
  List<String> text_notifs = ["Comments", "Reactions", "Follows"];
  List<bool> clicked_flags = List.generate(3, (index) => true);
  List arr = [], users = [], curr_notifs = [];
  bool pick_all = true;
  List notifications = [];

  @override
  Widget build(BuildContext context) {
    curr_notifs.clear();
    for (int i = 0; i < clicked_flags.length; i++) {
      if (clicked_flags[i] == true) {
        curr_notifs.add(notifs[i]);
      }
    }
    notifications =
        Provider.of<UserDB>(context, listen: false).notifications.toList();
    print(notifications);
    return FutureBuilder(
        future: getNotifs(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
            endDrawer: Drawer(
                child: Scaffold(
              appBar: AppBar(
                title: const Text("Notifications"),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  (pick_all)
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              for (int i = 0; i < clicked_flags.length; i++) {
                                clicked_flags[i] = false;
                              }
                              pick_all = !pick_all;
                            });
                          },
                          child: const Text(
                            "clear all",
                            style: TextStyle(color: Colors.white),
                          ))
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              for (int i = 0; i < clicked_flags.length; i++) {
                                clicked_flags[i] = true;
                              }
                              pick_all = !pick_all;
                            });
                          },
                          child: const Text(
                            "pick all",
                            style: TextStyle(color: Colors.white),
                          )),
                  SizedBox(width: 10)
                ],
              ),
              body: Center(
                child: ListView(
                    shrinkWrap: true,
                    children: List.generate(
                      text_notifs.length,
                      (index) {
                        return Align(
                          heightFactor: 1.5,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                clicked_flags[index] = !clicked_flags[index];
                              });
                            },
                            child: Text(text_notifs[index]),
                            style: TextButton.styleFrom(
                                primary: (clicked_flags[index])
                                    ? Colors.white
                                    : Colors.black,
                                fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.width /
                                      (2 * clicked_flags.length),
                                ),
                                shape: const StadiumBorder(),
                                backgroundColor: (clicked_flags[index])
                                    ? Colors.deepOrange
                                    : Colors.grey),
                          ),
                        );
                      },
                    )),
              ),
            )),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Notifications'),
              actions: [
                Builder(
                    builder: (context) => IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: const Icon(Icons.filter_alt))),
              ],
            ),
            body: Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: (notifications.length > 0)
                  ? ListView(
                      shrinkWrap: true,
                      children: List.generate(
                          notifications.length,
                          (index) => notification_card(
                              image: notifications[index]['avatar_path'],
                              username: notifications[index]['username'],
                              message: notifications[index]['noti'])))
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.notifications,
                              size: 70, color: Colors.grey),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "No Notifications Yet",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        });
  }

  Future<void> getNotifs() async {
    notifications.removeWhere((notif) => !curr_notifs.contains(notif['noti']));
  }
}
