import 'package:flutter/material.dart';

class comment extends StatefulWidget {
  const comment({Key? key}) : super(key: key);

  @override
  _commentState createState() => _commentState();
}

class _commentState extends State<comment> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Flex(direction: Axis.horizontal, children: [
              Flexible(
                child: Row(
                  children: [
                    Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            const CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    'https://i.ibb.co/CwTL6Br/1.jpg')),
                            const SizedBox(width: 20),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("MichaelHendley",
                                      maxLines: 1,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 15,
                                          fontFamily: 'arial',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  SizedBox(height: 10),
                                  Text(
                                      "Hi, this message is too long, and thus it is going to  be cut",
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 12,
                                          fontFamily: 'arial',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45))
                                ],
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ]),
            Divider()
          ],
        ));
  }
}
