import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    return Container(
        color: Colors.white,
        child: Column(children: <Widget>[
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
          Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text('')
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Container(
                        width: 70,
                        child: Text(
                          'Followers 1024',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepOrange),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Container(
                        width: 70,
                        child: Text(
                          'Following 1300',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepOrange),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text('')
                    ],
                  ),
                ],
              )),
        ]));
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
