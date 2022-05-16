import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '/app_data/app_data.dart';
import '/models/category.dart';
import 'package:image_picker/image_picker.dart';
import '/pages/category_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> imageList = [
    'https://cdn.pixabay.com/photo/2019/03/15/09/49/girl-4056684_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/12/15/16/25/clock-5834193__340.jpg',
    'https://cdn.pixabay.com/photo/2020/09/18/19/31/laptop-5582775_960_720.jpg',
    'https://media.istockphoto.com/photos/woman-kayaking-in-fjord-in-norway-picture-id1059380230?b=1&k=6&m=1059380230&s=170667a&w=0&h=kA_A_XrhZJjw2bo5jIJ7089-VktFK0h0I4OWDqaac0c=',
    'https://cdn.pixabay.com/photo/2019/11/05/00/53/cellular-4602489_960_720.jpg',
    'https://cdn.pixabay.com/photo/2017/02/12/10/29/christmas-2059698_960_720.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white24,
            body: Center(
                child: Container(
                    margin: EdgeInsets.all(12),
                    child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        children: List.generate(10, (index) {
                          return FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: imageList[index],
                            fit: BoxFit.cover,
                          );
                        }))))));

    // StaggeredGrid.count(
    //     crossAxisCount: 2,
    //     crossAxisSpacing: 10,
    //     mainAxisSpacing: 12,
    //     children:[ Container(
    //         decoration: BoxDecoration(
    //             color: Colors.transparent,
    //             borderRadius: BorderRadius.all(
    //                 Radius.circular(15))
    //         ),
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.all(
    //               Radius.circular(15)),
    //           child: FadeInImage.memoryNetwork(
    //             placeholder: kTransparentImage,
    //             image: imageList[index], fit: BoxFit.cover,),
    //         ),
    //       )])
    //           ),
    //     ),
    //   ),
    // );
  }
}

class UserProfilePage extends StatefulWidget {
  UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController editingController = TextEditingController();

    final duplicateItems = List<String>.generate(
        AppData.categories.length, (i) => AppData.categories[i].CategoryName);
    var items = <String>[];
    void filterSearchResults(String query) {
      List<String> dummySearchList = <String>[];
      dummySearchList.addAll(duplicateItems);
      if (query.isNotEmpty) {
        // List<String> dummyListData = <String>[];
        List<String> dummyListData = <String>[];
        dummySearchList.forEach((item) {
          if (item.contains(query)) {
            dummyListData.add(item);
          }
        });
        setState(() {
          items.clear();
          items.addAll(dummyListData);
        });
        return;
      } else {
        setState(() {
          items.clear();
          items.addAll(duplicateItems);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), actions: <Widget>[
        IconButton(onPressed: () {}, icon: Icon(Icons.send)),
        SizedBox(width: 20)
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Category new_category = new Category(
            imageUrl: 'assets/images/new.jpg',
            CategoryName: 'New Category',
            Description: 'newww',
            imagesList: [],
          );
          AppData.categories.add(new_category);
          setState(() {});
        },
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 25),
          Container(
            child: HeaderSection(),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: TextField(
              // onChanged: (value) {
              //   filterSearchResults(value);
              // },
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Search category",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
          ),
          // FloatingSearchAppBarExample(),
          SizedBox(height: 10),
          Center(
            child: Container(
              child: Wrap(
                spacing: 6,
                runSpacing: 25,
                children: <Widget>[
                  for (int i = 0; i < AppData.categories.length; i++)
                    GestureDetector(
                      onTap: () => {},
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 3.2,
                            width: MediaQuery.of(context).size.width / 3.2,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  // showCategory(i, context);
                                });
                              },
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                child: Ink(
                                  child: Image.asset(
                                    AppData.categories[i].imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Column(children: [
                            Text(AppData.categories[i].CategoryName,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16))
                          ])
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderSection extends StatefulWidget {
  HeaderSection({
    Key? key,
  }) : super(key: key);
  @override
  _HeaderSectionState createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  //TextEditingController _bioController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

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

  @override
  Widget build(BuildContext context) {
    return Container(
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
}

class SearchBar extends StatefulWidget {
  SearchBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _SearchBarState createState() => new _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = <String>[];

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  var foo = <int>[];
  void filterSearchResults(String query) {
    List<String> dummySearchList = <String>[];
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: items.length,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         title: Text('${items[index]}'),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
