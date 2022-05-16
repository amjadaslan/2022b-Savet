import 'package:flutter/material.dart';

import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:savet/Posts/Public_Post/public_post_comments.dart';
import 'package:savet/Posts/similar_content.dart';
import 'package:savet/Posts/similar_content_card.dart';

class public_post extends StatefulWidget {
  const public_post({Key? key}) : super(key: key);

  @override
  _public_postState createState() => _public_postState();
}

class _public_postState extends State<public_post> {
  List<String> arr = [
    'https://cdn.pixabay.com/photo/2019/03/15/09/49/girl-4056684_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/12/15/16/25/clock-5834193__340.jpg',
    'https://cdn.pixabay.com/photo/2020/09/18/19/31/laptop-5582775_960_720.jpg',
    'https://media.istockphoto.com/photos/woman-kayaking-in-fjord-in-norway-picture-id1059380230?b=1&k=6&m=1059380230&s=170667a&w=0&h=kA_A_XrhZJjw2bo5jIJ7089-VktFK0h0I4OWDqaac0c=',
    'https://cdn.pixabay.com/photo/2019/11/05/00/53/cellular-4602489_960_720.jpg',
    'https://cdn.pixabay.com/photo/2017/02/12/10/29/christmas-2059698_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/01/29/17/09/snowboard-4803050_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/02/06/20/01/university-library-4825366_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/11/22/17/28/cat-5767334_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/12/13/16/22/snow-5828736_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/12/09/09/27/women-5816861_960_720.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    bool isPressed = false;
    return Scaffold(
        appBar: AppBar(
          title: Text('Post Title'),
          actions: [
            IconButton(
                onPressed: () {
                  FlutterAlarmClock.createAlarm(23, 59);
                },
                icon: Icon(Icons.add_alert)),
            SizedBox(width: 20),
            Icon(Icons.share),
            SizedBox(width: 20)
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  color: Colors.lightBlue,
                  child: Row(
                    children: [
                      const SizedBox(height: 75),
                      const SizedBox(width: 20),
                      const CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage('https://i.ibb.co/CwTL6Br/1.jpg')),
                      const SizedBox(width: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Michael Hendley",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 13,
                                    fontFamily: 'arial',
                                    color: Colors.white)),
                            SizedBox(height: 5),
                            Text("270 Followers",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 10,
                                    fontFamily: 'arial',
                                    color: Colors.white))
                          ]),
                      const SizedBox(width: 50),
                      TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Following a user has not been implemented yet!')));
                          },
                          child: const AutoSizeText("Follow",
                              style: const TextStyle(fontSize: 10)),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              fixedSize: const Size(100, 20),
                              //shape: const StadiumBorder(),
                              backgroundColor: Colors.deepOrangeAccent))
                    ],
                  )),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                      fit: BoxFit.fitWidth,
                      image: NetworkImage(arr[5] != null
                          ? arr[5]
                          : 'https://i.ibb.co/kGwjjp0/1.png'))),
              Container(
                height: 80,
                color: Colors.deepOrangeAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 100),
                    Material(
                        color: Colors.transparent,
                        child: IconButton(
                            iconSize: 50,
                            onPressed: () {
                              setState(() {
                                isPressed = !isPressed;
                              });
                            },
                            icon: (!isPressed)
                                ? Icon(Icons.favorite_border,
                                    color: Colors.white)
                                : Icon(Icons.favorite, color: Colors.white))),
                    // const VerticalDivider(
                    //   color: Colors.white,
                    //   thickness: 3,
                    //   indent: 5,
                    //   endIndent: 5,
                    // ),
                    Material(
                        color: Colors.transparent,
                        child: IconButton(
                            iconSize: 40,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const public_post_comments()));
                            },
                            icon: Icon(Icons.mode_comment_outlined,
                                color: Colors.white))),
                    // const VerticalDivider(
                    //   color: Colors.white,
                    //   thickness: 3,
                    //   indent: 5,
                    //   endIndent: 5,
                    // ),
                    Material(
                        color: Colors.transparent,
                        child: IconButton(
                            iconSize: 40,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const public_post_comments()));
                            },
                            icon: Icon(Icons.send, color: Colors.white))),
                    SizedBox(height: 100)
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 20),
                  Icon(Icons.favorite, color: Colors.red, size: 20),
                  SizedBox(width: 5),
                  Text(
                    "1,828 Likes",
                    style: TextStyle(
                        fontFamily: 'arial',
                        decoration: TextDecoration.none,
                        color: Colors.black54,
                        fontSize: 15),
                  )
                ],
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: AutoSizeText(
                  "Post Description _______________________________________________________________________________________________________________________________________________",
                  style: TextStyle(
                      fontFamily: 'arial',
                      decoration: TextDecoration.none,
                      color: Colors.black54,
                      fontSize: 15),
                ),
              ),
              SizedBox(height: 30),
              Container(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "   Similar Content",
                        style: TextStyle(
                            fontFamily: 'arial',
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 15),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => similar_content()));
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
                            children: List.generate(10, (index) {
                              return similar_content_card(url: arr[index]);
                            }),
                          )))
                ],
              ))
            ],
          ),
        )));
  }
}
