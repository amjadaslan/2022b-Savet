import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:savet/Category/profileImage.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Posts/add_post.dart';
import '../Services/user_db.dart';
import 'add_category.dart';

class category extends StatefulWidget {
  const category({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  _categoryState createState() => _categoryState();
}

class _categoryState extends State<category> {
  @override
  Widget build(BuildContext context) {
    Map cat = Provider.of<UserDB>(context).categories[widget.id];
    var pWrap = pathWrapper(cat['image']);
    return Scaffold(
        appBar: AppBar(
          title: Text(cat['title']),
          //automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => add_post(
                    cat_id: this.widget.id,
                  ))),
          backgroundColor: Colors.deepOrange,
        ),
        body: Column(children: [
          SizedBox(height: 10),
          profileImage(
              pWrap: pWrap, shape: "square", network_flag: true, id: cat['id']),
          SizedBox(height: 10),
          Text(
            cat['title'],
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: AutoSizeText(
              cat['description'],
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),
          Flexible(
            child: SingleChildScrollView(
              child: StaggeredGrid.count(
                crossAxisCount: 3,
                children: List.generate(cat['posts'].length, (index) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: cat['posts'][index]['image'],
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ]));
  }
}
