import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:savet/Category/add_category.dart';
import 'package:savet/Posts/videoPlayer.dart';

import '../Services/user_db.dart';
import 'add_category.dart';

class profileImage extends StatefulWidget {
  profileImage(
      {Key? key,
      required this.pWrap,
      required this.shape,
      required this.network_flag,
      this.id = -1,
      this.profile_pic = false,
      this.vid = false,
      this.outsider = false})
      : super(key: key);
  pathWrapper pWrap;
  bool vid;
  bool network_flag, outsider;
  int id;
  bool profile_pic;
  String shape;
  @override
  _profileImageState createState() => _profileImageState();
}

class _profileImageState extends State<profileImage> {
  late String path;
  String type = "Image";

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
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera, _picker, "Image");
                Navigator.pop(context);
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery, _picker, "Image");
                Navigator.pop(context);
              },
              label: const Text("Gallery"),
            ),
            (widget.vid)
                ? TextButton.icon(
                    icon: const Icon(Icons.smart_display),
                    onPressed: () {
                      takePhoto(ImageSource.gallery, _picker, "Video");
                      Navigator.pop(context);
                    },
                    label: const Text("Video"),
                  )
                : SizedBox()
          ])
        ],
      ),
    );

    return Center(
      child: Stack(children: <Widget>[
        if (type == "Image" && widget.shape == "circle")
          CircleAvatar(
              radius: 70.0,
              backgroundImage: ((path == "")
                  ? const AssetImage('assets/images/avatar.jpg')
                  : ((widget.network_flag)
                      ? NetworkImage(path)
                      : FileImage(File(path)) as ImageProvider)))
        else if (type == "Image" && widget.shape == "square")
          Container(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
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
                                ? const AssetImage('assets/images/default.jpg')
                                    as ImageProvider
                                : FileImage(File(path)))),
                  ),
                ),
              ))
        else if (type == "Video" && widget.shape == "square")
          Container(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (Colors.black12),
                    )),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: (path == "")
                        ? const Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/default.jpg'))
                        : FittedBox(
                            fit: BoxFit.fill,
                            child: VideoPlayerScreen(
                                networkFlag: widget.network_flag,
                                url: path,
                                addPost: true),
                          ),
                  ),
                ),
              )),
        (widget.outsider)
            ? const SizedBox()
            : Positioned(
                bottom: 10.0,
                right: 15.0,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder) => bottomSheet),
                    ).then((value) => setState(() {}));
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.black87,
                    size: 28.0,
                  ),
                ),
              ),
      ]),
    );
  }

  void takePhoto(ImageSource source, ImagePicker picker, String val) async {
    final pickedFile = (val == 'Image')
        ? await picker.pickImage(
            source: source,
            imageQuality: 80,
          )
        : await picker.pickVideo(source: source);
    type = val;
    if (pickedFile?.path != null) {
      widget.pWrap.value = pickedFile?.path;
      widget.pWrap.videoFlag = (val == "Video");
      path = widget.pWrap.value;
      widget.network_flag = false;
      if (widget.id != -1) {
        Provider.of<UserDB>(context, listen: false)
            .changeCategoryProfile(widget.id, widget.pWrap.value);
      }
      if (widget.profile_pic) {
        Provider.of<UserDB>(context, listen: false)
            .changeProfileImage(widget.pWrap.value);
      }
    }
    setState(() {});
  }
}
