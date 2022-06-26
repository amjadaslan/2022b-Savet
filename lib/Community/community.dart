import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savet/Community/community_post_card.dart';

import '../Services/user_db.dart';

class community extends StatefulWidget {
  const community({Key? key}) : super(key: key);

  @override
  _communityState createState() => _communityState();
}

class _communityState extends State<community> {
  List arr = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getTagPosts(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Community', textAlign: TextAlign.center),
            ),
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: (arr.length > 0)
                    ? ListView(
                        children: List.generate(arr.length, (index) {
                        return community_post(
                            post: arr[index]['post'],
                            user: arr[index]['user'],
                            token: arr[index]['token']);
                      }))
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.people, size: 70, color: Colors.grey),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "No Posts Yet",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          );
        });
  }

  Future<void> getTagPosts() async {
    arr.clear();
    List emails = [];
    Provider.of<UserDB>(context, listen: false).following.forEach((following) {
      emails.add(following['email']);
    });
    var snapshot = (await FirebaseFirestore.instance.collection('users').get());
    List users = snapshot.docs.map((doc) => doc.data()).toList();
    users.removeWhere((user) =>
        (!user['email'].contains('@') || (!emails.contains(user['email']))));
    for (var user in users) {
      user['categories'].forEach((c) {
        if (c['id'] != 0 && c['tag'] != "Private") {
          c['posts'].forEach((p) {
            var post = {'post': p, 'user': user, 'token': user['token']};
            arr.add(post);
          });
        }
      });
    }
    arr.sort((a, b) => (b['post']['id'].compareTo(a['post']['id'])));
  }
}
