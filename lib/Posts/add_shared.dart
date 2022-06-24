import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:savet/homepage.dart';
import 'dart:async';
import '../Category/add_category.dart';
import '../Category/category.dart';
import '../Category/category_card.dart';
import '../Posts/add_post.dart';
import '../Services/user_db.dart';
import '../auth/AnonymousLogin.dart';
import '../auth/login_page.dart';

class add_shared extends StatefulWidget {
  add_shared({Key? key, required this.sharedFiles}) : super(key: key);
  List? sharedFiles;
  @override
  _add_sharedState createState() => _add_sharedState();
}

class _add_sharedState extends State<add_shared> {
  TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser;
    List cats = Provider.of<UserDB>(context).categories.toList();
    cats.removeWhere((cat) =>
        (!RegExp('.*${_editingController.text}.*', caseSensitive: false)
            .hasMatch(cat['title'])));
    List<Widget> categories = List.generate(cats.length, (i) {
      var cat = cats[i];
      return InkWell(
        key: Key('$i'),
        onTap: () {
          print("home");
          print(cat['id']);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => add_post(
                        cat_id: cat['id'],
                        image_path: widget.sharedFiles?.first.path,
                      )));
        },
        child: Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.width / 2.5,
            width: MediaQuery.of(context).size.width / 3.2,
            child: category_card(url: cat['image'], title: cat['title'])),
      );
    });
    bool isAnonymous = auth!.isAnonymous;

    return Scaffold(
        appBar: AppBar(
          title: const Text("pick category"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  widget.sharedFiles?.clear();
                  ReceiveSharingIntent.reset();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) => false);
                },
                icon: const Icon(Icons.close))
          ],
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (val) {
                setState(() {});
              },
              controller: _editingController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _editingController.text = "";
                    },
                  ),
                  hintText: 'Search...',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
          ),
          // FloatingSearchAppBarExample(),
          const SizedBox(height: 10),
          Center(
              child: Container(
                  child: GridView.count(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            children: categories,
            childAspectRatio: 0.8,
          )))
        ]));
  }
}
