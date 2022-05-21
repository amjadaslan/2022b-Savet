import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class profileImage extends StatelessWidget {
  const profileImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        CircleAvatar(
            radius: 70.0,
            backgroundImage: NetworkImage("https://i.ibb.co/CwTL6Br/1.jpg")),
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

    //pickedFile!.path
  }
}
