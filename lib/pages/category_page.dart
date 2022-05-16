// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
// import '/app_data/app_data.dart';
// import 'package:transparent_image/transparent_image.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//
// void takePhoto(ImageSource source, ImagePicker _picker, int i) async {
//   final pickedFile = await _picker.pickImage(
//     source: source,
//   );
// //  setState(() {
//   //   _imageFile = pickedFile;
//   AppData.categories[i].imageUrl = pickedFile!.path;
//   // });
// }
//
// Widget bottomSheet(BuildContext context, ImagePicker _picker, int i) {
//   return Container(
//     height: 100.0,
//     width: MediaQuery.of(context).size.width,
//     margin: const EdgeInsets.symmetric(
//       horizontal: 20,
//       vertical: 20,
//     ),
//     child: Column(
//       children: <Widget>[
//         const Text(
//           "Choose Profile photo",
//           style: TextStyle(
//             fontSize: 20.0,
//           ),
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//           TextButton.icon(
//             icon: Icon(Icons.camera),
//             onPressed: () {
//               takePhoto(ImageSource.camera, _picker, i);
//               Navigator.pop(context);
//             },
//             label: Text("Camera"),
//           ),
//           TextButton.icon(
//             icon: Icon(Icons.image),
//             onPressed: () {
//               takePhoto(ImageSource.gallery, _picker, i);
//               Navigator.pop(context);
//             },
//             label: Text("Gallery"),
//           ),
//         ])
//       ],
//     ),
//   );
// }
//
// Widget imageProfile(BuildContext context, int i, ImagePicker _picker) {
//   return Center(
//     child: Stack(children: <Widget>[
//       CircleAvatar(
//           radius: 70.0,
//           backgroundImage: AssetImage(AppData.categories[i].imageUrl)),
//       Positioned(
//         bottom: 13.0,
//         right: 15.0,
//         child: InkWell(
//           onTap: () {
//             showModalBottomSheet(
//               context: context,
//               builder: ((builder) => bottomSheet(context, _picker, i)),
//             );
//           },
//           child: Icon(
//             Icons.camera_alt,
//             color: Colors.black87,
//             size: 28.0,
//           ),
//         ),
//       ),
//     ]),
//   );
// }
//
// void showCategory(int i, BuildContext context) {
//   TextEditingController _descriptionController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//
//   Navigator.of(context).push(
//     MaterialPageRoute<void>(builder: (context) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text(AppData.categories[i].CategoryName),
//           automaticallyImplyLeading: false,
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: const Icon(Icons.add),
//           onPressed: () {},
//           backgroundColor: Colors.deepOrange,
//         ),
//         body: Column(children: [
//           SizedBox(height: 10),
//           imageProfile(context, i, _picker),
//           SizedBox(height: 10),
//           Text(
//             AppData.categories[i].CategoryName,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
//           ),
//           TextFormField(
//             textAlign: TextAlign.center,
//             controller: _descriptionController,
//             decoration: InputDecoration(labelText: 'Description'),
//             maxLines: 2,
//           ),
//           SizedBox(height: 10),
//           Expanded(
//             child: StaggeredGrid.count(
//                 shrinkWrap: true,
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 12,
//                 itemCount: AppData.categories[i].imagesList.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     decoration: const BoxDecoration(
//                         color: Colors.transparent,
//                         borderRadius: BorderRadius.all(Radius.circular(15))),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.all(Radius.circular(15)),
//                       child: FadeInImage.memoryNetwork(
//                         placeholder: kTransparentImage,
//                         image: AppData.categories[i].imagesList[index],
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   );
//                 },
//                 staggeredTileBuilder: (index) {
//                   return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
//                 }),
//           ),
//         ]),
//       );
//     }),
//   );
// }
