import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:savet/Category/add_category.dart';
import 'package:savet/auth/auth_repository.dart';

import '../Services/user_db.dart';
import 'add_category.dart';

class profileImage extends StatefulWidget {
  profileImage(
      {Key? key,
      required this.pWrap,
      required this.shape,
      required this.network_flag,
      this.id = -1})
      : super(key: key);
  pathWrapper pWrap;
  bool network_flag;
  int id;
  String shape;
  @override
  _profileImageState createState() => _profileImageState();
}

class _profileImageState extends State<profileImage> {
  late String path;

  @override
  Widget build(BuildContext context) {
    path = widget.pWrap.value;
    final _picker = ImagePicker();
    var bottomSheet = Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
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
                takePhoto(ImageSource.camera, _picker);
                Navigator.pop(context);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery, _picker);
                Navigator.pop(context);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );

    return Center(
      child: Stack(children: <Widget>[
        if (widget.shape == "circle")
          CircleAvatar(
              radius: 70.0,
              backgroundImage: ((path == "")
                  ? const AssetImage('assets/images/avatar.jpg')
                  : ((widget.network_flag)
                      ? NetworkImage(path)
                      : FileImage(File(path)) as ImageProvider)))
        else if (widget.shape == "square")
          Container(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (Colors.black12),
                    )),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Image(
                        fit: BoxFit.cover,
                        image: (widget.network_flag)
                            ? NetworkImage(path)
                            : ((path == "")
                                ? const AssetImage('assets/images/avatar.jpg')
                                    as ImageProvider
                                : FileImage(File(path)))),
                  ),
                ),
              )),
        Positioned(
          bottom: 10.0,
          right: 15.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet),
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

  void takePhoto(ImageSource source, ImagePicker picker) async {
    final pickedFile = await picker.pickImage(
      source: source,
    );
    widget.pWrap.value = pickedFile?.path;
    path = widget.pWrap.value;
    widget.network_flag = false;
    if (widget.id != -1) {
      Provider.of<UserDB>(context, listen: false)
          .changeCategoryProfile(widget.id, widget.pWrap.value);
    }
    setState(() {});
  }
}
