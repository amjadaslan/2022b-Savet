import 'package:flutter/material.dart';

class similar_content_card extends StatefulWidget {
  const similar_content_card({Key? key, required this.url}) : super(key: key);
  final String url;
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
                              image: NetworkImage(this.widget.url)),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text(
                              "Post Title",
                              style: TextStyle(
                                  fontFamily: 'arial',
                                  decoration: TextDecoration.none,
                                  color: Colors.black54,
                                  fontSize: 15),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text(
                              "Partial Description",
                              style: TextStyle(
                                  fontFamily: 'arial',
                                  decoration: TextDecoration.none,
                                  color: Colors.black54,
                                  fontSize: 15),
                            ),
                          ),
                          SizedBox(height: 10),
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
