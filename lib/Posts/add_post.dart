import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Category/profileImage.dart';
import '../Services/user_db.dart';

class add_post extends StatefulWidget {
  const add_post({Key? key, required this.cat_id}) : super(key: key);
  final cat_id;
  @override
  _add_postState createState() => _add_postState();
}

class _add_postState extends State<add_post> {
  TextEditingController _desc = new TextEditingController();
  TextEditingController _name = new TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Add Post"),
        ),
        body: Center(
            child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                profileImage(),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                      controller: _name,
                      decoration: InputDecoration(
                          labelText: 'Post Title',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black38, width: 1.0),
                              borderRadius: BorderRadius.circular(25.0)))),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                      maxLines: 10,
                      controller: _desc,
                      decoration: InputDecoration(
                          labelText: 'Description',
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black38, width: 1.0),
                              borderRadius: BorderRadius.circular(25.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black38, width: 1.0),
                              borderRadius: BorderRadius.circular(25.0)))),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.4, 50),
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.deepOrange),
                        ),
                        SizedBox(width: 30),
                        TextButton(
                          onPressed: () {
                            Provider.of<UserDB>(context, listen: false).addPost(
                                _name.text, _desc.text, "A", widget.cat_id);
                          },
                          child: Text("Submit"),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.4, 50),
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.deepOrange),
                        )
                      ]),
                )
              ],
            ),
          ),
        )));
  }
}
