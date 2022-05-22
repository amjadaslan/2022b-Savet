import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_repository.dart';

int category_id = 0;
int p_id = 0;

class Chat {
  String avatar = '';
  String username = '';
  List<String> from_user = [];
  List<String> to_user = [];
}

class userwithFollowers_Following {
  int followers = 0;
  int following = 0;
  String username = '';
  String avatar_path = '';

  userwithFollowers_Following(int a, int b, String c, String d)
      : followers = a,
        following = b,
        username = c,
        avatar_path = d {}
}

class Comment {
  String avatar_path = '';
  String username = '';
  String content = '';

  Comment(String a_p, String u, String c)
      : avatar_path = a_p,
        username = u,
        content = c {}
}

class Public_Part {
  int likes = 0;
  List<Comment> comments = [];
  List<String> tag = [];
}

class Post {
  bool public = false;
  late Public_Part public_part;
  String content_path = '';
  String title = 'untitled';
  String description = '';
  int cat_id = 0;
  int post_id = 0;

  Post(String t, String d, String c_p, bool p, int c_i)
      : title = t,
        description = d,
        content_path = c_p,
        public = p,
        cat_id = c_i {
    if (p) public_part = Public_Part();
    post_id = p_id;
    p_id++;
  }
}

class Category {
  int cat_id = 0;
  String title = '';
  String description = '';
  String profile_image = '';
  List<Post> posts = [];

  Category(String t, String d, String p_i)
      : title = t,
        description = d,
        profile_image = p_i {}
}

class UserDB extends ChangeNotifier {
  String username = "";
  String avatar_path = "";

  List notifications = [];

  List followers = [];
  int followers_count = 0;
  List following = [];
  int following_count = 0;

  List categories = [];

  late DocumentReference userDocument;

  fetchData() async {
    final user = AuthRepository.instance();
    String uid = user.user!.uid;

    print("Fetching Data");
    print(uid);
    userDocument = FirebaseFirestore.instance.collection('userID').doc(uid);
    DocumentSnapshot userSnapshot = await userDocument.get();
    if (!userSnapshot.exists) {
      await userDocument.set({
        'username': username,
        'avatar_path': avatar_path,
        'notifications': notifications,
        'followers': followers,
        'followers_count': followers_count,
        'following': following,
        'following_count': followers_count,
        'categories': categories
      });
    } else {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      //fetching username & avatarImage
      username = userData['username'];
      avatar_path = userData['avatar_path'];
      categories = userData['categories'];

      //fetching Notifications
      List<dynamic> notif = userData['notifications'];
      notifications = notif;

      //notif.forEach((e) => {notifications.add(e)});

      //fetching list of followers
      List<dynamic> flwrs = userData['followers'];

      flwrs.forEach((e) => {
            followers.add(userwithFollowers_Following(e['followers'],
                e['following'], e['username'], e['avatar_path']))
          });

      //fetching list of followers
      List<dynamic> flwng = userData['following'];

      flwng.forEach((e) => {
            following.add(userwithFollowers_Following(e['followers'],
                e['following'], e['username'], e['avatar_path']))
          });
    }
  }

  void addNotification(String s) {
    notifications.add(s);
    userDocument.update({'notifications': notifications});
    notifyListeners();
  }

  Map getCategory(int id) {
    return categories[id];
  }

  void changeCategoryProfile(int cat_id, String new_img) async {
    print("changing Category Profile");
    File imageFile = File(new_img);
    String c = new_img.hashCode.toString();
    await FirebaseStorage.instance.ref('$c').putFile(imageFile);
    String path =
        await FirebaseStorage.instance.ref().child('$c').getDownloadURL();

    categories.forEach((e) {
      if (e['id'] == cat_id) {
        e['image'] = path;
      }
    });
    userDocument.update({'categories': categories});
    notifyListeners();
  }

  void changeCategorytitle(int cat_id, String new_title) async {
    print("changing Category title");

    categories.forEach((e) {
      if (e['id'] == cat_id) {
        e['title'] = new_title;
      }
    });
    userDocument.update({'categories': categories});
    notifyListeners();
  }

  void addCategory(String title, String desc, String profile_img) async {
    File imageFile = File(profile_img);
    String c = profile_img.hashCode.toString();
    await FirebaseStorage.instance.ref('$c').putFile(imageFile);
    String path =
        await FirebaseStorage.instance.ref().child('$c').getDownloadURL();
    int cat_id = categories.length;
    categories.add({
      'title': title,
      'description': desc,
      'image': path,
      'posts': [],
      'id': cat_id
    });
    userDocument.update({'categories': categories});
    notifyListeners();
  }

  void addPost(String t, String d, String image_path, int c_i) {
    categories.forEach((e) {
      if (e['id'] == c_i) {
        int post_id = e['posts'].length;
        e['posts'].add(
            {'title': t, 'description': d, 'image': image_path, 'id': post_id});
      }
    });
    notifyListeners();
  }

  void addFollower() {}

  void addComment(
      int c_id, int post_id, String a_p, String us, String content) {
    bool flag = false;
    categories.forEach((e) {
      if (e.cat_id == c_id) {
        e.posts.forEach((p) {
          if (p.post_id == post_id) {
            p.public_part.comments.add(Comment(a_p, us, content));
            flag = true;
          }
        });
      }
    });
    ;
    notifyListeners();
    assert(flag);
  }
}
