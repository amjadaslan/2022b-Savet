import 'package:flutter/material.dart';

class test extends StatefulWidget {
  const test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  final String appTitle = 'Local Notifications';
  var date;
  /*
  Create new Alarms
Create new Timer
Open default Clock app showing Alarms
Open default Clock app showing Timers
   */
  @override
  Widget build(BuildContext context) {
    showDate();
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
                        const SizedBox(height: 100),
                        Center(
                            child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.yellow,
                            size: 24.0,
                          ),
                          label: const Text(
                            'Simple Notification',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: date ?? DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2050))
                                .then((value) {
                              setState(() {
                                if (value != null) date = value;
                              });
                            });
                          },
                        )),
                        const Text(''),
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

  void showDate() {
    print(date);
  }
}
