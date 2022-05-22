import 'dart:ffi';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:savet/Home/profile.dart';
import 'package:savet/auth/auth_repository.dart';
import '../Category/add_category.dart';
import '../Category/category_card.dart';
import '../Services/user_db.dart';
import '/Category/category.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class home extends StatefulWidget {
  home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userDB = Provider.of<UserDB>(context);

    List cats = userDB.categories;

    TextEditingController editingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          title: const Text('Home'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            (Provider.of<AuthRepository>(context).isAuthenticated)
                ? (IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => profile()));
                    },
                    icon: Icon(Icons.account_circle)))
                : (SizedBox()),
            SizedBox(width: 20)
          ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => add_category())),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
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
                child: StaggeredGrid.count(
                    crossAxisCount: 3,
                    children: List.generate(cats.length, (i) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => category(id: i)))
                              .then((_) => setState(() {}));
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.width / 2.5,
                            width: MediaQuery.of(context).size.width / 3.2,
                            child: category_card(
                                url: (Provider.of<UserDB>(context)
                                    .categories[i])['image'],
                                title: (cats[i])['title'])),
                      );
                    }))),
          ),
        ],
      ),
    );
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
    return Container(
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
        ],
      ),
    );
  }
}
