import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:savet/Posts/similar_content_card.dart';

class similar_content extends StatefulWidget {
  similar_content({Key? key, required this.arr}) : super(key: key);
  List arr;

  @override
  _similar_contentState createState() => _similar_contentState();
}

class _similar_contentState extends State<similar_content> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Similar Content')),
        body: Center(
            child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Center(
                  child: SingleChildScrollView(
                    child: StaggeredGrid.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 2,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(widget.arr.length, (index) {
                        return similar_content_card(post: widget.arr[index]);
                      }),
                    ),
                  ),
                ))));
  }
}
