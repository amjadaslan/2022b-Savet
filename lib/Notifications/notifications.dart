import 'package:flutter/material.dart';
import 'package:savet/Notifications/notification_card.dart';

class notifications extends StatefulWidget {
  const notifications({Key? key}) : super(key: key);

  @override
  _notificationsState createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Notifications'),
        actions: [Icon(Icons.filter_alt), SizedBox(width: 20)],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: ListView(
            children: List.generate(20, (index) {
          return notification_card();
        })),
      ),
    );
  }
}
