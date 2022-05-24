import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_repository.dart';

//
// class Chat {
//   String avatar = '';
//   String username = '';
//   List<String> from_user = [];
//   List<String> to_user = [];
// }
//
// class userwithFollowers_Following {
//   int followers = 0;
//   int following = 0;
//   String username = '';
//   String avatar_path = '';
//
//   userwithFollowers_Following(int a, int b, String c, String d)
//       : followers = a,
//         following = b,
//         username = c,
//         avatar_path = d {}
// }
//
// class Comment {
//   String avatar_path = '';
//   String username = '';
//   String content = '';
//
//   Comment(String a_p, String u, String c)
//       : avatar_path = a_p,
//         username = u,
//         content = c {}
// }
//
// class Public_Part {
//   int likes = 0;
//   List<Comment> comments = [];
//   List<String> tag = [];
// }
//
// class Post {
//   bool public = false;
//   late Public_Part public_part;
//   String content_path = '';
//   String title = 'untitled';
//   String description = '';
//   int cat_id = 0;
//   int post_id = 0;
//
//   Post(String t, String d, String c_p, bool p, int c_i)
//       : title = t,
//         description = d,
//         content_path = c_p,
//         public = p,
//         cat_id = c_i {
//     if (p) public_part = Public_Part();
//     post_id = p_id;
//     p_id++;
//   }
// }
//
// class Category {
//   int cat_id = 1;
//   String title = '';
//   String description = '';
//   String profile_image = '';
//   List<Post> posts = [];
//
//   Category(String t, String d, String p_i)
//       : title = t,
//         description = d,
//         profile_image = p_i {}
// }

class UserDB extends ChangeNotifier {
  int category_id = 0;
  int p_id = 0;
  int tot_posts = 0;

  String? username = "";
  String avatar_path = "";
  String? user_email = "";

  List notifications = [];

  List recently_added = [];

  List followers = [];
  int followers_count = 0;
  List following = [];
  int following_count = 0;

  List categories = [
    {
      'title': "Recently Added",
      'description': "Most Recent 20 Posts",
      'image':
          "https://firebasestorage.googleapis.com/v0/b/savet-b9216.appspot.com/o/recently_added.png?alt=media&token=0b4a0d57-c19f-4f7a-bb49-ce67a6a20386",
      'posts': [],
      'id': 0
    }
  ];

  late DocumentReference userDocument;

  fetchData() async {
    final auth = AuthRepository.instance();
    user_email = auth.user?.email;

    print("Fetching Data");
    userDocument =
        FirebaseFirestore.instance.collection('users').doc(user_email);
    DocumentSnapshot userSnapshot = await userDocument.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    if (userData.length == 1) {
      String username = userData['username'];
      await userDocument.set({
        'avatar_path': avatar_path,
        'notifications': notifications,
        'followers': followers,
        'followers_count': followers_count,
        'following': following,
        'following_count': followers_count,
        'categories': categories,
        'username': username
      });
    } else {
      //fetching username & avatarImage
      username = userData['username'];
      avatar_path = userData['avatar_path'];
      categories = userData['categories'];
      //fetching Notifications
      List<dynamic> notif = userData['notifications'];
      notifications = notif;

      //notif.forEach((e) => {notifications.add(e)});

      //fetching list of followers
      // List<dynamic> flwrs = userData['followers'];

      //   flwrs.forEach((e) => {
      //         followers.add(userwithFollowers_Following(e['followers'],
      //             e['following'], e['username'], e['avatar_path']))
      //       });
      //
      //   //fetching list of followers
      //   List<dynamic> flwng = userData['following'];
      //
      //   flwng.forEach((e) => {
      //         following.add(userwithFollowers_Following(e['followers'],
      //             e['following'], e['username'], e['avatar_path']))
      //       });
      // }
    }
  }

  void addNotification(String s) {
    notifications.add(s);
    userDocument.update({'notifications': notifications});
    notifyListeners();
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
  }

  void changeCategoryTitle(int cat_id, String new_title) async {
    print("changing Category title");

    categories.forEach((e) {
      if (e['id'] == cat_id) {
        e['title'] = new_title;
      }
    });
    userDocument.update({'categories': categories});
    notifyListeners();
  }

  void changeProfileImage(String new_img) async {
    print("changing Profile Image");
    File imageFile = File(new_img);
    String c = new_img.hashCode.toString();
    await FirebaseStorage.instance.ref('$c').putFile(imageFile);
    String path =
        await FirebaseStorage.instance.ref().child('$c').getDownloadURL();

    avatar_path = path;
    userDocument.update({'avatar_path': avatar_path});
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

  void addPost(String t, String d, String image_path, int c_i) async {
    File imageFile = File(image_path);
    String c = image_path.hashCode.toString();
    await FirebaseStorage.instance.ref('$c').putFile(imageFile);
    String path =
        await FirebaseStorage.instance.ref().child('$c').getDownloadURL();
    categories.forEach((e) {
      if (e['id'] == c_i) {
        int post_id = e['posts'].length;
        e['posts']
            .add({'title': t, 'description': d, 'image': path, 'id': post_id});
        tot_posts++;
        print(tot_posts);
        categories[0]['posts'].insert(
            0, {'title': t, 'description': d, 'image': path, 'id': post_id});
        if (tot_posts > 20) {
          categories[0]['posts'].removeLast();
        }
      }
    });

    userDocument.update({'categories': categories});
    notifyListeners();
  }

  // void addFollower() {}

  // void addComment(
  //     int c_id, int post_id, String a_p, String us, String content) {
  //   bool flag = false;
  //   categories.forEach((e) {
  //     if (e.cat_id == c_id) {
  //       e.posts.forEach((p) {
  //         if (p.post_id == post_id) {
  //           p.public_part.comments.add(Comment(a_p, us, content));
  //           flag = true;
  //         }
  //       });
  //     }
  //   });
  //   ;
  //   notifyListeners();
  //   assert(flag);
  // }

}
