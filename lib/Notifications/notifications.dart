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
  @override
  Widget build(BuildContext context) {
    int len = Provider.of<UserDB>(context, listen: false).notifications.length;
    print('hi soo');
    print(Provider.of<UserDB>(context, listen: false).notifications);print('hi soo');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Notifications'),
        actions: [Icon(Icons.filter_alt), SizedBox(width: 20)],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: (len > 0)
            ? ListView(
                shrinkWrap: true,
                children: List.generate(
                    Provider.of<UserDB>(context, listen: false)
                            .notifications
                            .length -
                        1,
                    (index) => notification_card(
                        image: Provider.of<UserDB>(context, listen: false)
                            .notifications[index]['avatar_path'],
                        username: Provider.of<UserDB>(context, listen: false)
                            .notifications[index]['username'],
                        message: Provider.of<UserDB>(context, listen: false)
                            .notifications[index]['noti'])))
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.notifications, size: 70, color: Colors.grey),
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
  }
}
