import 'package:flutter/material.dart';

import 'follower_card.dart';

class fol_list extends StatefulWidget {
  fol_list({Key? key, required this.flag, required this.list})
      : super(key: key);
  List list;
  bool flag;
  @override
  _fol_listState createState() => _fol_listState();
}

class _fol_listState extends State<fol_list> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (widget.flag) ? Text('Followers') : Text('Following'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: ListView(
            children: List.generate(widget.list.length, (index) {
          print(widget.list[index]);
          return follower_card(user: widget.list[index], flag: false);
        })),
      ),
    );
  }
}
