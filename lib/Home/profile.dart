import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:savet/auth/auth_repoitory.dart';

import '../Chat/message_card.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    final user = AuthRepository.instance();
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    user.signOut();
                    Navigator.of(context).pop();
                  });
                },
                icon: Icon(Icons.logout)),
            SizedBox(width: 20)
          ],
        ),
        body: Container(
            color: Colors.white,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              SizedBox(height: 20),
              imageProfile(context),
              SizedBox(height: 10),
              Container(
                child: Text(
                  'John',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
              SizedBox(height: 10),
              DefaultTabController(
                length: 2,
                child: Column(children: [
                  TabBar(
                    labelColor: Colors.black,
                    tabs: [
                      Tab(
                        text: "Followers",
                      ),
                      Tab(
                        text: "Following",
                      ),
                    ],
                  ),
                  LimitedBox(
                      maxHeight: MediaQuery.of(context).size.height * 0.542,
                      child: Container(
                        color: Colors.transparent,
                        child: TabBarView(
                          children: [
                            ListView(
                              shrinkWrap: true,
                              children: [
                                SizedBox(height: 10),
                                message_card(),
                                message_card(),
                                message_card(),
                                message_card(),
                                message_card(),
                                message_card(),
                                message_card(),
                                message_card(),
                                message_card()
                              ],
                            ),
                            ListView(
                              shrinkWrap: true,
                              children: [
                                SizedBox(height: 10),
                                message_card(),
                                message_card(),
                                message_card(),
                                message_card(),
                                message_card(),
                                message_card(),
                                message_card(),
                                message_card(),
                                message_card(),
                                message_card()
                              ],
                            ),
                          ],
                        ),
                      ))
                ]),
              )
            ])));
  }

  Widget imageProfile(BuildContext context) {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile == null
              ? AssetImage('assets/images/avatar.jpg') as ImageProvider
              : FileImage(File(_imageFile!.path)),
        ),
        Positioned(
          bottom: 13.0,
          right: 15.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet(context)),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.black87,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
    Navigator.pop(context);
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Category photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }
}
