import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:savet/Profile/profile.dart';
import 'package:savet/auth/auth_repository.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '/Category/category.dart';
import '../Category/add_category.dart';
import '../Category/category_card.dart';
import '../Profile/profile.dart';
import '../Services/user_db.dart';
import '../auth/login_page.dart';

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

  @override
  Widget build(BuildContext context) {
    print("rebuilding");
    List cats = Provider.of<UserDB>(context).categories;
    List<Widget> categories = List.generate(cats.length, (i) {
      var cat = cats[i];
      return InkWell(
        key: Key('$i'),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      category(id: cat['id'])));
        },
        child: Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.width / 2.5,
            width: MediaQuery.of(context).size.width / 3.2,
            child: category_card(
                url: cat['image'], title: cat['title'])),
      );
    });
    TextEditingController editingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          title: const Text('Home'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            (Provider.of<AuthRepository>(context) != null)
                ? (IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              profile(LoginFrom: widget.LoginFrom)));
                    },
                    icon: Icon(Icons.account_circle)))
                : (IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Login()));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please login')));
                    },
                    icon: Icon(Icons.account_circle))),
            SizedBox(width: 15)
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
    child: ReorderableGridView.count(shrinkWrap: true,
    crossAxisCount: 3,
    onReorder: (int oldIndex, int newIndex)  async {
    var oldp = categories[oldIndex];
    categories.removeAt(oldIndex);
    categories.insert(newIndex, oldp);

    var t = Provider.of<UserDB>(context,listen: false).categories[oldIndex];

    Provider.of<UserDB>(context,listen: false).categories[oldIndex] = Provider.of<UserDB>(context,listen: false).categories[newIndex];
    Provider.of<UserDB>(context,listen: false).categories[newIndex]=t;

    await Provider.of<UserDB>(context,listen:false).updateData();
    setState(() {
    });
    },
    children: categories,childAspectRatio: 0.8,)
    )
    )
  ]
  )
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
