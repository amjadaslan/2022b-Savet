import 'package:flutter/material.dart';

class similar_content_card extends StatefulWidget {
  const similar_content_card({Key? key, required this.post}) : super(key: key);
  final Map post;
  @override
  _similar_content_cardState createState() => _similar_content_cardState();
}

class _similar_content_cardState extends State<similar_content_card> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black12,
                  )),
              width: 200,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Image(
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(widget.post['image'])),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text(
                              "      " + widget.post['title'],
                              style: TextStyle(
                                  fontFamily: 'arial',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                  color: Colors.black54,
                                  fontSize: 15),
                            ),
                          ),
                          SizedBox(height: 5),
                          (!widget.post['description'].isEmpty)
                              ? Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Text(
                                    widget.post['description'],
                                    style: TextStyle(
                                        fontFamily: 'arial',
                                        decoration: TextDecoration.none,
                                        color: Colors.black54,
                                        fontSize: 15),
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                              height: (!widget.post['description'].isEmpty)
                                  ? 10
                                  : 0),
                          Row(
                            children: [
                              SizedBox(width: 5),
                              Icon(Icons.favorite, color: Colors.red, size: 20),
                              SizedBox(width: 5),
                              Text(
                                "1,828 Likes",
                                style: TextStyle(
                                    fontFamily: 'arial',
                                    decoration: TextDecoration.none,
                                    color: Colors.black54,
                                    fontSize: 15),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 5)
                    ],
                  ))),
        ),
      ],
    );
  }
}
