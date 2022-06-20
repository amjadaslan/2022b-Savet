import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserDB extends ChangeNotifier {
  int tot_posts = 0;

  String? username = "";
  String avatar_path = "";
  String? user_email = "";
  String? log_from = "";
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
      'id': 0,
      'tag': "Private"
    }
  ];

  late DocumentReference userDocument;

  fetchData() async {
    try {
      print("Fetching Data...");
      final auth = FirebaseAuth.instance.currentUser;

      user_email = !(auth!.isAnonymous) ? auth.email : auth.uid;
      userDocument =
          FirebaseFirestore.instance.collection('users').doc(user_email);

      DocumentSnapshot userSnapshot = await userDocument.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      if (userData.length <= 3) {
        if (userData.length == 3) {
          avatar_path = userData['avatar_path'];
        }
        log_from = userData['log_from'];
        username = userData['username'];
        await userDocument.set({
          'avatar_path': avatar_path,
          'notifications': notifications,
          'followers': followers,
          'followers_count': followers_count,
          'following': following,
          'following_count': followers_count,
          'categories': categories,
          'username': username,
          'email': user_email,
          'log_from': log_from
        });
      } else {
        username = userData['username'];
        log_from = userData['log_from'];
        avatar_path = userData['avatar_path'];
        categories = userData['categories'];
        following_count = userData['following_count'];
        following = userData['following'];
        followers = userData['followers'];
        followers_count = userData['followers_count'];

        //fetching Notifications
        // List<dynamic> notif = userData['notifications'];
        // notifications = notif;

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
    } catch (e) {
      print("ERROR Facebook login $e");
    }
  }

  fetchDataAfterAnonymous(var x) async {
    try {
      final auth = FirebaseAuth.instance.currentUser;
      user_email = auth?.email;
      userDocument =
          FirebaseFirestore.instance.collection('users').doc(user_email);
      var userDocumentAnony =
          FirebaseFirestore.instance.collection('users').doc(x);
      DocumentSnapshot userSnapshot = await userDocument.get();
      DocumentSnapshot userSnapshotAno = await userDocumentAnony.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> userDataAno =
          userSnapshot.data() as Map<String, dynamic>;
      print("fetchDataAfterAnonymous");
      categories = userDataAno['categories'];
      print(userData.length);
      if (userData.length <= 3) {
        if (userData.length == 3) {
          avatar_path = userData['avatar_path'];
        }
        username = userData['username'];
        //log_from = userData['log_from'];
        await userDocument.set({
          'avatar_path': avatar_path,
          'notifications': notifications,
          'followers': followers,
          'followers_count': followers_count,
          'following': following,
          'following_count': followers_count,
          'categories': categories,
          'username': username,
          'email': user_email,
          //'log_from': log_from
        });
      } else {
        //fetching username & avatarImage
        username = userData['username'];
        avatar_path = userData['avatar_path'];
        following_count = userData['following_count'];
        following = userData['following'];
        followers = userData['followers'];
        followers_count = userData['followers_count'];
        //log_from = userData['log_from'];

        //fetching Notifications
        // List<dynamic> notif = userData['notifications'];
        // notifications = notif;

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
    } catch (e) {
      print("ERROR Facebook login $e");
    }
  }

  resetFetchData() async {
    tot_posts = 0;

    username = "";
    avatar_path = "";
    user_email = "";
    log_from = "";
    notifications = [];

    recently_added = [];

    followers = [];
    followers_count = 0;
    following = [];
    following_count = 0;

    categories = [
      {
        'title': "Recently Added",
        'description': "Most Recent 20 Posts",
        'image':
            "https://firebasestorage.googleapis.com/v0/b/savet-b9216.appspot.com/o/recently_added.png?alt=media&token=0b4a0d57-c19f-4f7a-bb49-ce67a6a20386",
        'posts': [],
        'id': 0,
        'tag': "Private"
      }
    ];
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
    notifyListeners();
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

  void editCategory(int cat_id, String new_img, String new_title, String tag,
      String dec) async {
    try {
      String path = "";
      print("edit Category");
      File imageFile = File(new_img);
      bool temp = imageFile.absolute.existsSync();
      if (temp) {
        String c = new_img.hashCode.toString();
        await FirebaseStorage.instance.ref('$c').putFile(imageFile);
        path =
            await FirebaseStorage.instance.ref().child('$c').getDownloadURL();
      }
      categories.forEach((e) {
        if (e['id'] == cat_id) {
          if (temp) {
            e['image'] = path;
          }
          e['title'] = new_title;
          e['tag'] = tag;
          e['description'] = dec;
        }
      });
      userDocument.update({'categories': categories});
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void editPost(int cat_id, int post_id, String title, String discr,
      String image_path, bool videoFlag, DateTime? date) async {
    final file = File(image_path);
    String path = "";
    bool temp = file.absolute.existsSync();
    if (temp) {
      String c = image_path.hashCode.toString();
      final ref = await FirebaseStorage.instance.ref('$c');
      (videoFlag)
          ? await ref.putFile(file, SettableMetadata(contentType: 'video/mp4'))
          : await ref.putFile(file);

      path = await FirebaseStorage.instance.ref().child('$c').getDownloadURL();
    }
    print(cat_id);
    print(post_id);
    categories.forEach((e) {
      if (e['id'] == cat_id) {
        if (temp) {
          e['posts'][post_id]['image'] = path;
        }
        e['posts'][post_id]['title'] = title;
        e['posts'][post_id]['description'] = discr;
      }
    });

    categories[0]['posts'].forEach((e) {
      if (e['cat_id'] == cat_id && e['id'] == post_id) {
        if (temp) {
          e['image'] = path;
        }
        e['title'] = title;
        e['description'] = discr;
      }
    });
    userDocument.update({'categories': categories});

    notifyListeners();
  }

  /*
   String? pathToDelete = "";
    categories.forEach((e) {
      if (e['id'] == c_id) {
        categories[c_id]['posts'].forEach((p) {
          if (p_id == p['id']) {
            pathToDelete = p['image'];
          }
        });
        categories[c_id]['posts'].removeWhere((p) => p_id == p['id']);
      }
    });
    categories[0]['posts'].removeWhere((p) => p_id == p['id'], tot_posts--);
    pathToDelete = RegExp('\/o\/([0-9]*)').firstMatch(pathToDelete!)?.group(1);
    await FirebaseStorage.instance.ref('$pathToDelete').delete();

    userDocument.update({'categories': categories});
    notifyListeners();
   */
  void changeProfileImage(String new_img) async {
    print("changing Profile Image");
    File imageFile = File(new_img);
    String c = new_img.hashCode.toString();
    await FirebaseStorage.instance.ref('$c').putFile(imageFile);
    String path =
        await FirebaseStorage.instance.ref().child('$c').getDownloadURL();

    avatar_path = path;
    userDocument.update({'avatar_path': avatar_path});
    notifyListeners();
  }

  Future<void> addCategory(
      String title, String desc, String profile_img, String tag) async {
    String path;
    if (profile_img.isEmpty) {
      path = await FirebaseStorage.instance
          .ref()
          .child('default.jpg')
          .getDownloadURL();
    } else {
      File imageFile = File(profile_img);
      String c = profile_img.hashCode.toString();
      await FirebaseStorage.instance.ref('$c').putFile(imageFile);
      path = await FirebaseStorage.instance.ref().child('$c').getDownloadURL();
    }
    int category_id = DateTime.now().microsecondsSinceEpoch;
    categories.add({
      'title': title,
      'description': desc,
      'image': path,
      'posts': [],
      'id': category_id,
      'tag': tag
    });
    userDocument.update({'categories': categories});
    notifyListeners();
  }

  void addPost(String t, String d, String image_path, int c_i, bool videoFlag,
      DateTime? date) async {
    final file = File(image_path);
    String c = image_path.hashCode.toString();
    final ref = await FirebaseStorage.instance.ref('$c');
    (videoFlag)
        ? await ref.putFile(file, SettableMetadata(contentType: 'video/mp4'))
        : await ref.putFile(file);
    int post_id = DateTime.now().microsecondsSinceEpoch;
    String path =
        await FirebaseStorage.instance.ref().child('$c').getDownloadURL();
    categories.forEach((e) {
      if (e['id'] == c_i) {
        e['posts'].add({
          'title': t,
          'description': d,
          'image': path,
          'id': post_id,
          'cat_id': c_i,
          'videoFlag': videoFlag,
          'reminder': date,
          'comments': {},
          'likes': 0,
          'likers': {}
        });
        tot_posts++;
        categories[0]['posts'].insert(0, {
          'title': t,
          'description': d,
          'image': path,
          'id': post_id,
          'cat_id': c_i,
          'videoFlag': videoFlag,
          'reminder': date,
          'comments': {},
          'likes': 0,
          'likers': {}
        });
        if (tot_posts > 20) {
          categories[0]['posts'].removeLast();
          tot_posts--;
        }
      }
    });
    userDocument.update({'categories': categories});

    notifyListeners();
  }

  Future<void> removeCategory(int c_id) async {
    String? pathToDelete = "";
    for (var e in categories) {
      if (e['id'] == c_id) {
        pathToDelete = e['image'];
        pathToDelete =
            RegExp('\/o\/([0-9]*)').firstMatch(pathToDelete!)?.group(1);
        await FirebaseStorage.instance.ref('$pathToDelete').delete();
        for (var p in e['posts']) {
          pathToDelete = p['image'];
          pathToDelete =
              RegExp('\/o\/([0-9]*)').firstMatch(pathToDelete!)?.group(1);
          await FirebaseStorage.instance.ref('$pathToDelete').delete();
        }
      }
    }
    categories.removeWhere((c) => c_id == c['id']);

    //removes all deleted posts from recently added category
    categories[0]['posts'].removeWhere((p) => p['cat_id'] == c_id, tot_posts--);

    userDocument.update({'categories': categories});
    notifyListeners(); //TODO: hi
  }

  Future<void> removePost(int p_id, int c_id) async {
    String? pathToDelete = "";
    categories.forEach((e) {
      if (e['id'] == c_id) {
        categories[c_id]['posts'].forEach((p) {
          if (p_id == p['id']) {
            pathToDelete = p['image'];
          }
        });
        categories[c_id]['posts'].removeWhere((p) => p_id == p['id']);
      }
    });
    categories[0]['posts'].removeWhere((p) => p_id == p['id'], tot_posts--);
    pathToDelete = RegExp('\/o\/([0-9]*)').firstMatch(pathToDelete!)?.group(1);
    await FirebaseStorage.instance.ref('$pathToDelete').delete();

    userDocument.update({'categories': categories});
    notifyListeners();
  }

  Future<Map> getUserByEmail(String email) async {
    var s = FirebaseFirestore.instance.collection('users').doc(email);
    DocumentSnapshot userSnapshot = await s.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

    return userData;
  }

  //TODO: change date
  void changeDate(Timestamp t, int id) async {
    print("changeDate");
    var s = FirebaseFirestore.instance.collection('users').doc(user_email);
    DocumentSnapshot userSnapshot = await s.get();
    var userData = userSnapshot.data() as Map;
    var posts = userData['categories'][2]['posts'][0];
    print(posts);
    posts.insert({'reminder': t});
    notifyListeners();
  }

  Future<void> addFollower(String email, Map him) async {
    print("Adding a follow");
    var s = FirebaseFirestore.instance.collection('users').doc(email);
    DocumentSnapshot userSnapshot = await s.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    var followers_list = userData['followers'];

    int followers_cnt = userData['followers_count'];
    followers_list.add({
      'username': username,
      'followers_count': followers_count,
      'following_count': following_count + 1,
      'avatar_path': avatar_path,
      'email': user_email
    });

    s.update(
        {'followers': followers_list, 'followers_count': followers_cnt + 1});

    userSnapshot = await userDocument.get();
    userData = userSnapshot.data() as Map<String, dynamic>;
    int myFollowing_cnt = userData['following_count'];
    var myFollowing_list = userData['following'];
    var to_add = {
      'username': him['username'],
      'followers_count': him['followers_count'] + 1,
      'following_count': him['following_count'],
      'avatar_path': him['avatar_path']
    };
    myFollowing_list.add(to_add);
    following.add(to_add);
    following_count++;
    userDocument.update({
      'following': myFollowing_list,
      'following_count': myFollowing_cnt + 1
    });

    fetchData();
  }

  Future<void> removeFollower(String email, Map him) async {
    print("removing a follow");
    var s = FirebaseFirestore.instance.collection('users').doc(email);
    DocumentSnapshot userSnapshot = await s.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    var followers_list = userData['followers'];
    int followers_cnt = userData['followers_count'];
    followers_list.removeWhere((user) => (user['username'] == username));
    s.update(
        {'followers': followers_list, 'followers_count': followers_cnt - 1});

    userSnapshot = await userDocument.get();
    userData = userSnapshot.data() as Map<String, dynamic>;
    int myFollowing_cnt = userData['following_count'];
    var myFollowing_list = userData['following'];
    myFollowing_list
        .removeWhere((user) => (user['username'] == him['username']));
    following.removeWhere((user) => (user['username'] == him['username']));
    following_count--;
    userDocument.update({
      'following': myFollowing_list,
      'following_count': myFollowing_cnt - 1
    });
    fetchData();
  }

  Future<void> addCommentToPost(
      String? email, int post_id, int cat_id, Map comment) async {
    print("Adding a comment!");
    if (email == null) {
      categories
          .singleWhere((element) => element['id'] == cat_id)['posts']
          .singleWhere((element) => element['id'] == post_id)['comments']
          .add(comment);
      updateData();
    } else {
      var s = FirebaseFirestore.instance.collection('users').doc(email);
      DocumentSnapshot userSnapshot = await s.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      userData['categories']
          .singleWhere((element) => element['id'] == cat_id)['posts']
          .singleWhere((element) => element['id'] == post_id)['comments']
          .add(comment);
    }
  }

  Future<void> updateData() async {
    print("updating data");
    await userDocument.update({
      'avatar_path': avatar_path,
      'notifications': notifications,
      'followers': followers,
      'followers_count': followers_count,
      'following': following,
      'following_count': followers_count,
      'categories': categories,
      'username': username,
      //'log_from': log_from
    });
  }

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

  Future<void> addLike(String? email, Map like , int post_id, int cat_id,) async {
    print("Adding like");

    if (email == null) {
      categories
          .singleWhere((element) => element['id'] == cat_id)['posts']
          .singleWhere((element) => element['id'] == post_id)['likers']
          .add(like);
      updateData();
    } else {
      var s = FirebaseFirestore.instance.collection('users').doc(email);
      DocumentSnapshot userSnapshot = await s.get();
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

      print(like);
      print(cat_id);
      print(post_id);
      userData['categories']
          .singleWhere((element) => element['id'] == cat_id)['posts']
          .singleWhere((element) => element['id'] == post_id)['likers']
          .add(like);

     // s.update({'categories': categories});
      updateData();
    }
//    updateData();
    fetchData();
  }

  Future<void> removeLike(String? email, Map like , int post_id, int cat_id,) async {
    print("Removing like");

    if (email == null) {
      categories
          .singleWhere((element) => element['id'] == cat_id)['posts']
          .singleWhere((element) => element['id'] == post_id)['likers']
          .remove(like);
      updateData();
    } else {
      var s = FirebaseFirestore.instance.collection('users').doc(email);
      DocumentSnapshot userSnapshot = await s.get();
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

      userData['categories']
          .singleWhere((element) => element['id'] == cat_id)['posts']
          .singleWhere((element) => element['id'] == post_id)['likers']
          .remove(like);

      //s.update({'categories': categories});

    }
//    updateData();
   // fetchData();
  }
}
