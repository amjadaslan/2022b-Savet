import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class category_card extends StatefulWidget {
  const category_card({Key? key, required this.url, required this.title})
      : super(key: key);
  final String url;
  final String title;
  @override
  _category_cardState createState() => _category_cardState();
}

class _category_cardState extends State<category_card> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                flex: 10,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (Colors.black12),
                      )),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(this.widget.url)),
                    ),
                  ),
                )),
            SizedBox(height: 10),
            AutoSizeText(this.widget.title)
          ],
        ),
      ),
    );
  }
}
