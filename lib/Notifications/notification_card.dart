import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class notification_card extends StatefulWidget {
  const notification_card({Key? key}) : super(key: key);

  @override
  _notification_cardState createState() => _notification_cardState();
}

class _notification_cardState extends State<notification_card> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        const CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage('https://i.ibb.co/CwTL6Br/1.jpg')),
                        const SizedBox(width: 20),
                        Text("MichaelHendley",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 15,
                                fontFamily: 'arial',
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        SizedBox(
                          width: 5,
                        ),
                        Text("started following you.",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 12,
                                fontFamily: 'arial',
                                fontWeight: FontWeight.bold,
                                color: Colors.black45))
                      ],
                    ))
              ],
            ),
            Divider()
          ],
        ));
  }
}
