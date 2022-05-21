import 'package:flutter/material.dart';

class follower_card extends StatefulWidget {
  const follower_card({Key? key}) : super(key: key);

  @override
  _follower_cardState createState() => _follower_cardState();
}

class _follower_cardState extends State<follower_card> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(height: 5),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("1.3k followers",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontSize: 12,
                                              fontFamily: 'arial',
                                              color: Colors.black45)),
                                      SizedBox(width: 40),
                                      Text("524 following",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontSize: 12,
                                              fontFamily: 'arial',
                                              color: Colors.black45))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ]),
            SizedBox(height: 5),
            Divider()
          ],
        ));
  }
}
