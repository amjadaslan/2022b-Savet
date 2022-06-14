import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Category/add_category.dart';
import '../Category/profileImage.dart';
import '../Services/user_db.dart';

class edit_post extends StatefulWidget {
  edit_post({Key? key, required this.cat_id}) : super(key: key);
  var cat_id;
  @override
  edit_postState createState() => edit_postState();
}

class edit_postState extends State<edit_post> {
  TextEditingController _desc = new TextEditingController();
  TextEditingController _name = new TextEditingController();

  var pWrap = new pathWrapper("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Add Post"),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  profileImage(
                      pWrap: pWrap,
                      shape: "square",
                      network_flag: false,
                      vid: true),
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
                              if (_name.text.isEmpty || pWrap.value == "") {
                                if (pWrap.value == "") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please pick a post image")));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please write a title for the Post")));
                                }
                              } else {
                                Provider.of<UserDB>(context, listen: false)
                                    .addPost(
                                        _name.text,
                                        _desc.text,
                                        pWrap.value,
                                        widget.cat_id,
                                        pWrap.videoFlag,
                                        null);
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
