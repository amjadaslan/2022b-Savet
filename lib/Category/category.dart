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
    var t = cat['title'];
    TextEditingController _cont = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text(t),
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
          TextButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Change Title"),
                        content: TextField(
                            controller: _cont,
                            decoration: const InputDecoration(
                              hintText: 'new title',
                            )),
                        actions: [
                          TextButton(
                            child: Text("Confirm"),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.deepOrange)),
                            onPressed: () {
                              setState(() {
                                Provider.of<UserDB>(context, listen: false)
                                    .changeCategoryTitle(widget.id, _cont.text);
                                Navigator.pop(context);
                              });
                            },
                          ),
                          TextButton(
                            child: Text("Cancel"),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.deepOrange)),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    });
              },
              child: Text("$t",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 25))),
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
          SizedBox(height: 11),
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

  // void _getDialog() async {
  //   await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text("Change Title"),
  //           content: TextField(
  //               controller: _cont,
  //               decoration: const InputDecoration(
  //                 hintText: 'new title',
  //               )),
  //           actions: [
  //             TextButton(
  //               child: Text("Yes"),
  //               style: ButtonStyle(
  //                   foregroundColor: MaterialStateProperty.all(Colors.white),
  //                   backgroundColor:
  //                       MaterialStateProperty.all(Colors.deepOrange)),
  //               onPressed: () {
  //                 setState(() {
  //                   Provider.of<UserDB>(context)
  //                       .changeCategoryTitle(id, _cont.text);
  //                   Navigator.pop(context);
  //                 });
  //               },
  //             ),
  //             TextButton(
  //               child: Text("No"),
  //               style: ButtonStyle(
  //                   foregroundColor: MaterialStateProperty.all(Colors.white),
  //                   backgroundColor:
  //                       MaterialStateProperty.all(Colors.deepOrange)),
  //               onPressed: () => Navigator.pop(context),
  //             ),
  //           ],
  //         );
  //       });
  // }
}
