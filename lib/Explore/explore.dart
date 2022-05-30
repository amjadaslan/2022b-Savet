import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:savet/Profile/follower_card.dart';

import '../Services/user_db.dart';
import 'explore_card.dart';

class explore extends StatefulWidget {
  const explore({Key? key}) : super(key: key);

  @override
  _exploreState createState() => _exploreState();
}

class _exploreState extends State<explore> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<String> tags = [
    "Home décor",
    "DIY and crafts",
    "Entertainment",
    "Education",
    "Art",
    "Men’s fashion",
    "Women’s fashion",
    "Food and drinks",
    "Beauty",
    "Event planning",
    "Gardening",
    "Cars"
  ];
  List<bool> clicked_flags = List.generate(12, (index) => true);
  @override
  Widget build(BuildContext context) {
    List curr_tags = [];
    for (int i = 0; i < clicked_flags.length; i++) {
      if (clicked_flags[i] == true) {
        curr_tags.add(tags[i]);
      }
    }
    List arr = [];
    Provider.of<UserDB>(context).categories.forEach((c) {
      if (c['id'] != 0 && curr_tags.contains(c['tag']))
        c['posts'].forEach((p) {
          arr.add(p);
        });
    });

    return Scaffold(
      endDrawer: Drawer(
          child: Scaffold(
        appBar: AppBar(
          title: Text("Choose tags"),
          leading: IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView(
                shrinkWrap: true,
                children: List.generate(
                  tags.length,
                  (index) {
                    return Align(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            clicked_flags[index] = !clicked_flags[index];
                          });
                        },
                        child: Text(tags[index]),
                        style: TextButton.styleFrom(
                            primary: (clicked_flags[index])
                                ? Colors.white
                                : Colors.black,
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.4,
                              MediaQuery.of(context).size.width * 0.1,
                            ),
                            shape: const StadiumBorder(),
                            backgroundColor: (clicked_flags[index])
                                ? Colors.deepOrange
                                : Colors.grey),
                      ),
                    );
                  },
                )),
            TextButton(
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < clicked_flags.length; i++)
                      clicked_flags[i] = false;
                  });
                },
                child: Text("Unpick all tags"))
          ],
        )),
      )),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Explore', textAlign: TextAlign.center),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SearchPage())),
              icon: Icon(Icons.search)),
          SizedBox(
            width: 10,
          ),
          Builder(
              builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(Icons.filter_list))),
          SizedBox(width: 20)
        ],
      ),
      body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.98,
              child: Center(
                child: (arr.length > 0)
                    ? SingleChildScrollView(
                        child: StaggeredGrid.count(
                          // Create a grid with 2 columns. If you change the scrollDirection to
                          // horizontal, this produces 2 rows.
                          crossAxisCount: 2,
                          // Generate 100 widgets that display their index in the List.
                          children: List.generate(arr.length, (index) {
                            return explore_card(url: arr[index]['image']);
                          }),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                              color: Colors.grey,
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.width * 0.2,
                              image: NetworkImage(
                                  "https://firebasestorage.googleapis.com/v0/b/savet-b9216.appspot.com/o/no_posts.png?alt=media&token=87d70511-20b2-4f8a-bcd5-77f61e02df9a")),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "No Posts Yet",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
              ))),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _userControl = TextEditingController();
  List userList = [];

  @override
  Widget build(BuildContext context) {
    getUserList();

    return Scaffold(
      appBar: AppBar(
          // The search area here
          title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: TextField(
            controller: _userControl,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _userControl.text = "";
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none),
          ),
        ),
      )),
      body: ListView(
        children: List.generate(
            userList.length, (id) => follower_card(user: userList[id].data())),
      ),
    );
  }

  void getUserList() async {
    userList =
        (await FirebaseFirestore.instance.collection('users').snapshots().first)
            .docs
            .toList();
    userList.removeWhere((user) =>
        (!RegExp('.*${_userControl.text}.*', caseSensitive: false)
            .hasMatch(user['username'])) ||
        (user['username'] ==
            Provider.of<UserDB>(context, listen: false).username));

    setState(() {});
  }
}
