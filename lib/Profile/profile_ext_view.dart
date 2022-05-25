import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:savet/Profile/followers_following_list.dart';

import '../Category/category.dart';
import '../Category/category_card.dart';
import '../Chat/chat.dart';
import '../Services/user_db.dart';

class profile_ext_view extends StatefulWidget {
  profile_ext_view({Key? key, required this.user}) : super(key: key);
  Map user;

  @override
  _profile_ext_viewState createState() => _profile_ext_viewState();
}

class _profile_ext_viewState extends State<profile_ext_view> {
  int clicked = 0;
  bool flag = false;
  @override
  Widget build(BuildContext context) {
    Provider.of<UserDB>(context).following.forEach((e) {
      if (e['username'] == widget.user['username']) {
        flag = true;
      }
    });
    List cats = widget.user['categories']
        .where((c) => (c['tag'] != "Private"))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user['username']}', textAlign: TextAlign.center),
        actions: [
          IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => chat()));
              }),
          SizedBox(width: 20)
        ],
      ),
      body: Center(
        child: Container(
            child: Column(children: <Widget>[
          SizedBox(height: 20),
          (widget.user['avatar_path'] == "")
              ? CircleAvatar(
                  radius: 80,
                  backgroundImage: const AssetImage('assets/images/avatar.jpg'))
              : CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(widget.user['avatar_path'])),
          SizedBox(height: 10),
          Container(
            child: Text(
              '${widget.user['username']}',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              clicked = 1 - clicked;
              flag = !flag;
              if (clicked == 1 || flag) {
                await Provider.of<UserDB>(context, listen: false)
                    .addFollower(widget.user['email'], widget.user);
                widget.user['followers'].add({
                  'avatar_path':
                      Provider.of<UserDB>(context, listen: false).avatar_path,
                  'username':
                      Provider.of<UserDB>(context, listen: false).username,
                  'followers_count': Provider.of<UserDB>(context, listen: false)
                      .followers_count,
                  'following_count': Provider.of<UserDB>(context, listen: false)
                      .following_count,
                });
              } else {
                await Provider.of<UserDB>(context, listen: false)
                    .removeFollower(widget.user['email'], widget.user);
                widget.user['followers'].where((f) => (f['username'] ==
                    Provider.of<UserDB>(context, listen: false).username));
              }
              setState(() {});
            },
            child: (!flag && clicked == 0) ? Text("Follow") : Text("Unfollow"),
            style: TextButton.styleFrom(
                primary: Colors.white,
                fixedSize: Size(
                  MediaQuery.of(context).size.width * 0.4,
                  MediaQuery.of(context).size.width * 0.1,
                ),
                shape: const StadiumBorder(),
                backgroundColor: (!flag && clicked == 0)
                    ? Colors.deepOrange
                    : Colors.lightBlue),
          ),
          SizedBox(height: 10),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => fol_list(
                                flag: true, list: widget.user['followers'])),
                      );
                    },
                    child: Container(
                        width: 100,
                        child: Text(
                          '${widget.user['followers_count'] + clicked}\nFollowers',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepOrange),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  TextButton(
                    // Within the `FirstRoute` widget
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => fol_list(
                                flag: false, list: widget.user['following'])),
                      );
                    },
                    child: Container(
                        width: 100,
                        child: Text(
                          '${widget.user['following_count']}\nFollowing',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.deepOrange),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ],
              )),
          SizedBox(height: 10),
          Divider(thickness: 2),
          Center(
            child: Container(
                child: StaggeredGrid.count(
                    crossAxisCount: 3,
                    children: List.generate(cats.length, (i) {
                      var cat = cats[i];
                      return InkWell(
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
                    }))),
          ),
        ])),
      ),
    );
  }
}
