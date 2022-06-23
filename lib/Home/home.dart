import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:savet/Profile/profile.dart';

import '/Category/category.dart';
import '../Category/add_category.dart';
import '../Category/category_card.dart';
import '../Profile/profile.dart';
import '../Services/user_db.dart';
import '../auth/AnonymousLogin.dart';

class home extends StatefulWidget {
  home({Key? key, required this.LoginFrom}) : super(key: key);
  String LoginFrom;

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController _editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //Provider.of<UserDB>(context).updateData();
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => category(id: cat['id'])));
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
            title: const Text('Home'),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              (!(isAnonymous))
                  ? (IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                profile(LoginFrom: widget.LoginFrom)));
                      },
                      icon: const Icon(
                        Icons.account_circle,
                        size: 30,
                      )))
                  : (IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginAnonymous()));
                      },
                      icon: const Icon(
                        Icons.login,
                        //color: Colors.white,
                      ),
                    )),
              const SizedBox(width: 15)
            ]),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const add_category()));
          },
          backgroundColor: Colors.deepOrange,
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
                  child: SingleChildScrollView(
                      child: ReorderableGridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            onReorder: (int oldIndex, int newIndex) async {
              if (newIndex == 0 || oldIndex == 0) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.grey[300],
                    content: const Text("Cannot Move Recently Added Category!",
                        style: TextStyle(color: Colors.black54))));
                return;
              }
              var oldp = categories[oldIndex];
              categories.removeAt(oldIndex);
              categories.insert(newIndex, oldp);

              var t = Provider.of<UserDB>(context, listen: false)
                  .categories[oldIndex];
              print(t);

              Provider.of<UserDB>(context, listen: false).categories[oldIndex] =
                  Provider.of<UserDB>(context, listen: false)
                      .categories[newIndex];
              Provider.of<UserDB>(context, listen: false).categories[newIndex] =
                  t;

              await Provider.of<UserDB>(context, listen: false).updateData();
              setState(() {});
            },
            children: categories,
            childAspectRatio: 0.8,
          ))))
        ]));
  }
}
