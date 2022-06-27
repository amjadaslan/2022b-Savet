import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class notification_card extends StatefulWidget {
  notification_card(
      {Key? key,
      required this.image,
      required this.username,
      required this.message})
      : super(key: key);
  String image = "";
  String username = "";
  String message = "";
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
                        CircleAvatar(
                            radius: 30,
                            backgroundImage: (widget.image == "")
                                ? AssetImage('assets/images/avatar.jpg')
                                    as ImageProvider
                                : CachedNetworkImageProvider(widget.image)),
                        const SizedBox(width: 20),
                        AutoSizeText(
                          '${widget.username}',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 14,
                              fontFamily: 'arial',
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          maxFontSize: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("${widget.message}",
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
