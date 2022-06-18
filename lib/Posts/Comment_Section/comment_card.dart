import 'package:flutter/material.dart';

class comment extends StatefulWidget {
  comment({Key? key, required this.content}) : super(key: key);
  Map? content;

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
                            CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    widget.content!['avatar_path'])),
                            const SizedBox(width: 20),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.content!['username'],
                                      maxLines: 1,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 15,
                                          fontFamily: 'arial',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  SizedBox(height: 10),
                                  Text(widget.content!['content'],
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
