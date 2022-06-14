import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:savet/Category/profileImage.dart';
import 'package:savet/Posts/videoPlayer.dart';
import 'package:transparent_image/transparent_image.dart';

import '../Posts/Private_Post/private_post.dart';
import '../Posts/add_post.dart';
import '../Services/user_db.dart';
import 'add_category.dart';
import 'edit_category.dart';

class category extends StatefulWidget {
  category({Key? key, required this.id, this.user}) : super(key: key);
  Map? user;
  final int id;
  @override
  _categoryState createState() => _categoryState();
}

class _categoryState extends State<category> {
  @override
  Widget build(BuildContext context) {
    Map cat = {
      'title': "",
      'image':
          "https://cdn.pixabay.com/photo/2020/12/09/09/27/women-5816861_960_720.jpg",
      'id': widget.id,
      'posts': [],
      'description': ""
    };
    List categories = (widget.user != null)
        ? widget.user!['categories']
        : Provider.of<UserDB>(context).categories;

    categories.forEach((e) {
      if (e['id'] == widget.id) cat = e;
    });

    var pWrap = pathWrapper(cat['image']);
    var t = cat['title'];
    TextEditingController _cont = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text(t),
          actions: (widget.id != 0 && widget.user == null)
              ? [
                  IconButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    edit_category(id: widget.id)));
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Delete Category"),
                                content: const Text(
                                    "Are you sure you want to delete this Category?"),
                                actions: [
                                  TextButton(
                                    child: const Text("Yes"),
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.deepOrange)),
                                    onPressed: () {
                                      setState(() {
                                        Provider.of<UserDB>(context,
                                                listen: false)
                                            .removeCategory(widget.id);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("No"),
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.deepOrange)),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.delete)),
                  const SizedBox(width: 15)
                ]
              : [],
          //automaticallyImplyLeading: false,
        ),
        floatingActionButton: (widget.user == null && widget.id != 0)
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => add_post(
                          cat_id: this.widget.id,
                        ))),
                backgroundColor: Colors.deepOrange,
              )
            : SizedBox(),
        body: Column(children: [
          const SizedBox(height: 10),
          profileImage(
              pWrap: pWrap,
              shape: "square",
              network_flag: true,
              id: cat['id'],
              outsider: true),
          const SizedBox(height: 10),
          TextButton(
              onPressed: (widget.user != null)
                  ? () {}
                  : () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Change Title"),
                              content: TextField(
                                  controller: _cont,
                                  decoration: const InputDecoration(
                                    hintText: 'new title',
                                  )),
                              actions: [
                                TextButton(
                                  child: const Text("Confirm"),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.deepOrange)),
                                  onPressed: () {
                                    setState(() {
                                      Provider.of<UserDB>(context,
                                              listen: false)
                                          .changeCategoryTitle(
                                              widget.id, _cont.text);
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                TextButton(
                                  child: const Text("Cancel"),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.deepOrange)),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            );
                          });
                    },
              child: Text("$t",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 25))),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: AutoSizeText(
              cat['description'],
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          Flexible(
            child: SingleChildScrollView(
              child: StaggeredGrid.count(
                crossAxisCount: 3,
                children: List.generate(cat['posts'].length, (index) {
                  return InkWell(
                      onTap: () {
                        if (index < cat.length) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => private_post(
                                      cat_id: cat['id'],
                                      post_id: cat['posts'][index]['id'],
                                      user: widget.user)));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: (cat['posts'][index]['videoFlag'])
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  //height: 200,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: VideoPlayerScreen(
                                        networkFlag: true,
                                        url: cat['posts'][index]['image']),
                                  ),
                                )
                              : FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: cat['posts'][index]['image'],
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ));
                }),
              ),
            ),
          ),
        ]));
  }
}
