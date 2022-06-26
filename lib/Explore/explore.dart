import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<String> tags = [
    "Home décor",
    "DIY & crafts",
    "Entertainment",
    "Education",
    "Art",
    "Men’s fashion",
    "Women’s fashion",
    "Food & drinks",
    "Beauty",
    "Event planning",
    "Gardening",
    "Cars",
    "Fitness",
    "Movies & TV Shows"
  ];
  List<bool> clicked_flags = List.generate(14, (index) => true);
  List arr = [], users = [], curr_tags = [];
  bool pick_all = true;
  @override
  Widget build(BuildContext context) {
    curr_tags.clear();
    for (int i = 0; i < clicked_flags.length; i++) {
      if (clicked_flags[i] == true) {
        curr_tags.add(tags[i]);
      }
    }

    return FutureBuilder(
        future: getTagPosts(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
              endDrawer: Drawer(
                  child: Scaffold(
                appBar: AppBar(
                  title: const Text("Choose tags"),
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  actions: [
                    (pick_all)
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                for (int i = 0; i < clicked_flags.length; i++) {
                                  clicked_flags[i] = false;
                                }
                                pick_all = !pick_all;
                              });
                            },
                            child: const Text(
                              "clear all",
                              style: TextStyle(color: Colors.white),
                            ))
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                for (int i = 0; i < clicked_flags.length; i++) {
                                  clicked_flags[i] = true;
                                }
                                pick_all = !pick_all;
                              });
                            },
                            child: const Text(
                              "pick all",
                              style: TextStyle(color: Colors.white),
                            )),
                    SizedBox(width: 10)
                  ],
                ),
                body: Center(
                  child: ListView(
                      shrinkWrap: true,
                      children: List.generate(
                        tags.length,
                        (index) {
                          return Align(
                            heightFactor: 0.9,
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
                                    MediaQuery.of(context).size.width /
                                        (2 * clicked_flags.length),
                                  ),
                                  shape: const StadiumBorder(),
                                  backgroundColor: (clicked_flags[index])
                                      ? Colors.deepOrange
                                      : Colors.grey),
                            ),
                          );
                        },
                      )),
                ),
              )),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text('Explore', textAlign: TextAlign.center),
                actions: [
                  IconButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SearchPage())),
                      icon: const Icon(Icons.search)),
                  const SizedBox(
                    width: 10,
                  ),
                  Builder(
                      builder: (context) => IconButton(
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: const Icon(Icons.filter_list))),
                  const SizedBox(width: 20)
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
                                    return explore_card(
                                        post: arr[index]['post'],
                                        user: arr[index]['user']);
                                  }),
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(
                                      color: Colors.grey,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.2,
                                      image: const NetworkImage(
                                          "https://firebasestorage.googleapis.com/v0/b/savet-b9216.appspot.com/o/no_posts.png?alt=media&token=87d70511-20b2-4f8a-bcd5-77f61e02df9a")),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "No Posts Yet",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                      ))));
        });
  }

  Future<void> getTagPosts() async {
    arr.clear();
    var snapshot = (await FirebaseFirestore.instance.collection('users').get());
    users = snapshot.docs.map((doc) => doc.data()).toList();
    users.removeWhere((user) => (!user['email'].contains('@')));
    for (var user in users) {
      user['categories'].forEach((c) {
        if (c['id'] != 0 && curr_tags.contains(c['tag'])) {
          c['posts'].forEach((p) async {
            var post = {'post': p, 'user': user};
            arr.add(post);

            if ((await Provider.of<UserDB>(context, listen: false))
                .reported
                .contains(p['id'])) {
              arr.remove(post);
            }
          });
        }
      });
    }
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
    String? userName = Provider.of<UserDB>(context, listen: false).username;

    return FutureBuilder(
        future: getUserList(userName),
        builder: (context, snapshot) {
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
                  onChanged: (val) => setState(() {}),
                  controller: _userControl,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
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
                  userList.length, (id) => follower_card(user: userList[id])),
            ),
          );
        });
  }

  Future<void> getUserList(String? username) async {
    var snapshot = (await FirebaseFirestore.instance.collection('users').get());
    userList = snapshot.docs.map((doc) => doc.data()).toList();

    userList.removeWhere((user) =>
        (user['username'] == username) ||
        !user['email'].contains('@') ||
        (!RegExp('.*${_userControl.text}.*', caseSensitive: false)
            .hasMatch(user['username'])));
  }
}
