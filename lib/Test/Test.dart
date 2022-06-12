import 'package:flutter/material.dart';
//import 'package:localpushnotifications/widget/local_notification_widget.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  final String appTitle = 'Local Notifications';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        const Text(''),
                        const SizedBox(height: 20),
                        Padding(
                            padding: const EdgeInsets.only(),
                            child: TextButton(
                                child: const Text(
                                  "local notification",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {})),
                      ],
                    )))));
  }
}
