import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

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

  List<String> tags = ["Private", "Clothes", "Cars", "Food"];
  List<bool> clicked_flags = List.generate(4, (index) => true);
  @override
  Widget build(BuildContext context) {
    List curr_tags = [];
    for (int i = 0; i < clicked_flags.length; i++) {
      if (clicked_flags[i] == true) curr_tags.add(tags[i]);
    }
    List arr = [];
    Provider.of<UserDB>(context).categories.forEach((c) {
      if (curr_tags.contains(c['tag']))
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
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
                                ? Colors.black
                                : Colors.white,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            TextButton(
              onPressed: () {},
              child: Text("Confirm"),
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.3,
                    MediaQuery.of(context).size.width * 0.1,
                  ),
                  shape: const StadiumBorder(),
                  backgroundColor: Colors.deepOrange),
            )
          ],
        )),
      )),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Explore', textAlign: TextAlign.center),
        actions: [
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
                child: SingleChildScrollView(
                  child: StaggeredGrid.count(
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 2,
                    // Generate 100 widgets that display their index in the List.
                    children: List.generate(arr.length, (index) {
                      return explore_card(url: arr[index]['image']);
                    }),
                  ),
                ),
              ))),
    );
  }
}
