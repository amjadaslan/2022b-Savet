import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Category/add_category.dart';
import '../Category/profileImage.dart';
import '../Services/user_db.dart';

class edit_post extends StatefulWidget {
  edit_post({Key? key, required this.post_id, required this.cat_id})
      : super(key: key);
  var cat_id;
  var post_id;
  @override
  edit_postState createState() => edit_postState();
}

class edit_postState extends State<edit_post> {
  TextEditingController _desc = new TextEditingController();
  TextEditingController _name = new TextEditingController();

  var pWrap = new pathWrapper("");

  @override
  Widget build(BuildContext context) {
    print("Edit post");
    print(widget.cat_id);
    print(widget.post_id);
    // var cat = Provider.of<UserDB>(context)
    //     .categories
    //     .singleWhere((element) => element['id'] == widget.cat_id);
    // //  print(cat);
    var e = Provider.of<UserDB>(context)
        .categories
        .singleWhere((element) => element['id'] == widget.cat_id);
    var post = e?['posts'].singleWhere(
        (element) => element['id'] == widget.post_id); //print(posts);
    //var post = posts[0];
    //print(post);
    pWrap = pWrap.value == "" ? pathWrapper(post['image']) : pWrap;
    String name = post['title'].toString();
    String desc = post['description'].toString();
    _desc.text = _desc.text == "" ? desc : _desc.text;
    _name.text = _name.text == "" ? name : _name.text;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Edit Post"),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  pWrap.value == pathWrapper(post['image']).value
                      ? profileImage(
                          pWrap: pWrap,
                          shape: "square",
                          network_flag: true,
                          vid: true,
                        )
                      : profileImage(
                          pWrap: pWrap,
                          shape: "square",
                          network_flag: false,
                          vid: true,
                        ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                        controller: _name,
                        decoration: InputDecoration(
                            labelText: 'Post Title',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black38, width: 1.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black38, width: 1.0),
                                borderRadius: BorderRadius.circular(25.0)))),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                        maxLines: 10,
                        controller: _desc,
                        decoration: InputDecoration(
                            labelText: 'Description',
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black38, width: 1.0),
                                borderRadius: BorderRadius.circular(25.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black38, width: 1.0),
                                borderRadius: BorderRadius.circular(25.0)))),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * 0.4,
                                    50),
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.deepOrange),
                          ),
                          const SizedBox(width: 30),
                          TextButton(
                            onPressed: () {
                              if (_name.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please write a title for the Post")));
                              } else {
                                print(widget.cat_id);
                                print(widget.post_id);
                                Provider.of<UserDB>(context, listen: false)
                                    .editPost(
                                        widget.cat_id,
                                        widget.post_id,
                                        _name.text,
                                        _desc.text,
                                        pWrap.value,
                                        pWrap.videoFlag,
                                        null);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text("Submit"),
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * 0.4,
                                    50),
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.deepOrange),
                          )
                        ]),
                  )
                ],
              ),
            ),
          )),
        ));
  }
}
