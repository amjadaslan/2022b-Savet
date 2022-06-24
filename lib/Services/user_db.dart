import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserDB extends ChangeNotifier {
  int tot_posts = 0;

  String? username = " ";
  String avatar_path = "";
  String? user_email = "";
  String? log_from = "";
  List notifications = [];
  List recently_added = [];
  List followers = [];
  int followers_count = 0;
  List following = [];
  int following_count = 0;
  List postsIliked = [];
  List postsIloved = [];
  static List reminders = [
    {
      'date': DateTime.now(),
      'cat_id': 2,
      'post_id': 2,
      'not_id': 0,
      'body': "Nothing, just want to say Hi",
      'title': "Hi ^___^",
      'id': "id",
      'ref': null
    }
  ];
  List reported = [];
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
          'log_from': log_from,
          'postsIliked': postsIliked,
          'postsIloved': postsIloved,
          'reminders': reminders
          'reported': reported
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
        postsIliked = userData['postsIliked'];
        postsIloved = userData['postsIloved'];
        reminders = userData['reminders'];

        //fetching Notifications
        List<dynamic> notif = userData['notifications'];
        notifications = notif;

        notif.forEach((e) => {notifications.add(e)});

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

        reported = userData['reported'];
      }
    } catch (e) {
      print("ERROR Facebook login $e");
    }
  }

  List gitCate() {
    return categories;
  }

  //
  // fetchDataPosts() async {
  //   try {
  //     print("Fetching Data Posts...");
  //     final auth = FirebaseAuth.instance.currentUser;
  //     user_email = !(auth!.isAnonymous) ? auth.email : auth.uid;
  //     userDocument =
  //         FirebaseFirestore.instance.collection('users').doc(user_email);
  //     DocumentSnapshot userSnapshot = await userDocument.get();
  //     Map<String, dynamic> userData =
  //     userSnapshot.data() as Map<String, dynamic>;
  //     if (userData.length <= 3) {
  //       if (userData.length == 3) {
  //         avatar_path = userData['avatar_path'];
  //       }
  //       log_from = userData['log_from'];
  //       username = userData['username'];
  //       await userDocument.set({
  //         'avatar_path': avatar_path,
  //         'notifications': notifications,
  //         'followers': followers,
  //         'followers_count': followers_count,
  //         'following': following,
  //         'following_count': followers_count,
  //         'categories': categories,
  //         'username': username,
  //         'email': user_email,
  //         'log_from': log_from
  //       });
  //     } else {
  //       username = userData['username'];
  //       log_from = userData['log_from'];
  //       avatar_path = userData['avatar_path'];
  //       categories = userData['categories'];
  //       following_count = userData['following_count'];
  //       following = userData['following'];
  //       followers = userData['followers'];
  //       followers_count = userData['followers_count'];
  //
  //       //fetching Notifications
  //       List<dynamic> notif = userData['notifications'];
  //       notifications = notif;
  //
  //       notif.forEach((e) => {notifications.add(e)});
  //
  //       //fetching list of followers
  //       // List<dynamic> flwrs = userData['followers'];
  //
  //       //   flwrs.forEach((e) => {
  //       //         followers.add(userwithFollowers_Following(e['followers'],
  //       //             e['following'], e['username'], e['avatar_path']))
  //       //       });
  //       //
  //       //   //fetching list of followers
  //       //   List<dynamic> flwng = userData['following'];
  //       //
  //       //   flwng.forEach((e) => {
  //       //         following.add(userwithFollowers_Following(e['followers'],
  //       //             e['following'], e['username'], e['avatar_path']))
  //       //       });
  //       // }
  //     }
  //   } catch (e) {
  //     print("ERROR Facebook login $e");
  //   }
  // }
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
    postsIliked = [];
    postsIloved = [];
    reminders = [
      {
        'date': DateTime.now(),
        'cat_id': 2,
        'post_id': 2,
        'not_id': 0,
        'body': "Nothing, just want to say Hi",
        'title': "Hi ^___^",
        'id': "id",
        'ref': null
      }
    ];
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

  Future<void> addNotification(String email, String noti) async {
    print('adding noti');
    var s = FirebaseFirestore.instance.collection('users').doc(email);
    DocumentSnapshot userSnapshot = await s.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    var notifications = userData['notifications'];

    notifications.add({
      'username': username,
      'avatar_path': avatar_path,
      'email': user_email,
      'noti': noti
    });

    s.update({'notifications': notifications});
    fetchData();
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
    try {
      final file = File(image_path);
      String path = "";
      bool temp = file.absolute.existsSync();
      if (temp) {
        String c = image_path.hashCode.toString();
        final ref = await FirebaseStorage.instance.ref('$c');
        (videoFlag)
            ? await ref.putFile(
                file, SettableMetadata(contentType: 'video/mp4'))
            : await ref.putFile(file);

        path =
            await FirebaseStorage.instance.ref().child('$c').getDownloadURL();
      }
      print(cat_id);
      print(post_id);
      var e = categories.singleWhere((element) => element['id'] == cat_id);
      var p = e?['posts'].singleWhere((element) => element['id'] == post_id);
      if (p != null) if (temp) {
        p['image'] = path;
      }
      p['title'] = title;
      p['description'] = discr;

      var t = categories[0]['posts'].singleWhere(
          (element) => element['cat_id'] == cat_id && element['id'] == post_id);
      if (t['cat_id'] == cat_id && t['id'] == post_id) {
        if (temp) {
          t['image'] = path;
        }
        t['title'] = title;
        t['description'] = discr;
      }
      userDocument.update({'categories': categories});

      notifyListeners();
    } catch (e) {
      print(e);
      print("cat id does not exist");
    }
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
      DateTime? date, String? time) async {
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
          'date': date,
          'time': time,
          'comments': {},
          'likes': 0,
          'likers': [],
          'loves': 0,
          'lovers': [],
          'username': username,
          'email': user_email
        });
        tot_posts++;
        categories[0]['posts'].insert(0, {
          'title': t,
          'description': d,
          'image': path,
          'id': post_id,
          'cat_id': c_i,
          'videoFlag': videoFlag,
          'date': date,
          'time': time,
          'comments': {},
          'likes': 0,
          'likers': [],
          'loves': 0,
          'lovers': [],
          'username': username,
          'email': user_email
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
        if (e['image'] !=
            "https://firebasestorage.googleapis.com/v0/b/savet-b9216.appspot.com/o/default.jpg?alt=media&token=4afdedfe-bd76-46fd-b878-8bed3f269d7c") {
          pathToDelete = e['image'];
          pathToDelete =
              RegExp('\/o\/([0-9]*)').firstMatch(pathToDelete!)?.group(1);
          await FirebaseStorage.instance.ref('$pathToDelete').delete();
        }
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
    List s = categories[0]['posts'].where((p) => p['cat_id'] == c_id).toList();
    tot_posts -= s.length;
    var set1 = Set.from(s);
    var set2 = Set.from(categories[0]['posts']);
    categories[0]['posts'] = List.from(set1.difference(set2));
    categories[0]['posts'] = userDocument.update({'categories': categories});
    notifyListeners();
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
  }

  Future<Map> getUserByEmail(String _email) async {
    var s = FirebaseFirestore.instance.collection('users').doc(_email);
    DocumentSnapshot userSnapshot = await s.get();
    Map<String, dynamic> _userData =
        userSnapshot.data() as Map<String, dynamic>;

    return _userData;
  }

  //TODO: I don't know why need this, but okay i want to continue working to fix the reminder Please check it
  void changeDate2(Timestamp t, int id) async {
    print("changeDate");
    var s = FirebaseFirestore.instance.collection('users').doc(user_email);
    DocumentSnapshot userSnapshot = await s.get();
    var userData = userSnapshot.data() as Map;
    var posts = userData['categories'][2]['posts'][0];
    print(posts);
    posts.insert({'reminder': t});
    notifyListeners();
  }

  void changeDate(int cat_id, int post_id, DateTime date, String _time) async {
    print("changeDate");
    print(_time);

    var e = categories.singleWhere((element) => element['id'] == cat_id);
    var p = null;
    if (e != null) {
      p = e['posts'].singleWhere((element) => element['id'] == post_id);
    }
    if (p != null) {
      p['date'] = date;
      p['time'] = _time;
    }
    userDocument.update({'categories': categories});
    notifyListeners();
  }

  Future<void> addReminder(String id, String title, String body,
      DateTime scheduledTime, int not_id, int cat_id, int post_id) async {
    print("Adding a Reminder");
    bool e = true;
    reminders.forEach((element) {
      if (element['cat_id'] == cat_id && element['post_id'] == post_id) {
        element['date'] = scheduledTime;
        e = false;
      }
    });

    print(reminders);
    if (e) {
      reminders.add({
        'date': scheduledTime,
        'cat_id': cat_id,
        'post_id': post_id,
        'not_id': not_id + 1,
        'body': body,
        'title': title,
        'id': id,
        'ref': null
      });
    }
    userDocument.update({'categories': categories, 'reminders': reminders});
    notifyListeners();
  }

  Future<void> removeReminder() async {
    if (reminders != null && reminders.length > 1) {
      reminders.toList().forEach((e) {
        if (DateTime.now().isAfter(e['date'].toDate()) && e['not_id'] != 0) {
          UserDB.reminders.remove(e);
        }
      });
      userDocument.update({'reminders': reminders});
      notifyListeners();
    }
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
      'email': user_email,
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
      'avatar_path': him['avatar_path'],
      'email': him['email']
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
      var cats = userData['categories'];
      cats
          .singleWhere((element) => element['id'] == cat_id)['posts']
          .singleWhere((element) => element['id'] == post_id)['comments']
          .add(comment);
      s.update({'categories': cats});
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
      'postsIliked': postsIliked,
      'postsIloved': postsIloved,
      'reminders': reminders
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

  Future<bool?> addLike(
    String? myEmail,
    String? email,
    int post_id,
    int cat_id,
  ) async {
    print("Adding like");

    var s = FirebaseFirestore.instance.collection('users').doc(email);
    DocumentSnapshot userSnapshot = await s.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

    var me = FirebaseFirestore.instance.collection('users').doc(myEmail);
    DocumentSnapshot userSnapshot2 = await me.get();
    Map<String, dynamic> myData = userSnapshot2.data() as Map<String, dynamic>;

    userData['categories']
        .singleWhere((element) => element['id'] == cat_id)['posts']
        .singleWhere((element) => element['id'] == post_id)['likers']
        .add(username);

    userData['categories']
        .singleWhere((element) => element['id'] == cat_id)['posts']
        .singleWhere((element) => element['id'] == post_id)['likes']++;

    myData['postsIliked'].add(post_id);
    //s.update({'likes': userData['categories'][cat_id]['posts'][post_id]['likes']});
    s.update({'categories': userData['categories']});
    me.update({'postsIliked': myData['postsIliked']});

    //fetchData();updateData(); notifyListeners();
  }

//
  Future<bool?> removeLike(
    String? myEmail,
    String? email,
    int post_id,
    int cat_id,
  ) async {
    print("Removing like");

    if (email == null) {
      categories
          .singleWhere((element) => element['id'] == cat_id)['posts']
          .singleWhere((element) => element['id'] == post_id)['likers']
          .add(email);

      updateData();
    } else {
      var s = FirebaseFirestore.instance.collection('users').doc(email);
      DocumentSnapshot userSnapshot = await s.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      var me = FirebaseFirestore.instance.collection('users').doc(myEmail);
      DocumentSnapshot userSnapshot2 = await me.get();
      Map<String, dynamic> myData =
          userSnapshot2.data() as Map<String, dynamic>;

      var likers = userData['categories']
          .singleWhere((element) => element['id'] == cat_id)['posts']
          .singleWhere((element) => element['id'] == post_id)['likers'];

      userData['categories']
          .singleWhere((element) => element['id'] == cat_id)['posts']
          .singleWhere((element) => element['id'] == post_id)['likes']--;

      likers.remove(userData['username']);

      myData['postsIliked'].remove(post_id);
      s.update({'categories': userData['categories']});
      me.update({'postsIliked': myData['postsIliked']});
    }
  }

  Future<bool?> addLove(
    String? myEmail,
    String? email,
    int post_id,
    int cat_id,
  ) async {
    print("Adding love");

    var s = FirebaseFirestore.instance.collection('users').doc(email);
    DocumentSnapshot userSnapshot = await s.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

    var me = FirebaseFirestore.instance.collection('users').doc(myEmail);
    DocumentSnapshot userSnapshot2 = await me.get();
    Map<String, dynamic> myData = userSnapshot2.data() as Map<String, dynamic>;

    userData['categories']
        .singleWhere((element) => element['id'] == cat_id)['posts']
        .singleWhere((element) => element['id'] == post_id)['lovers']
        .add(username);

    userData['categories']
        .singleWhere((element) => element['id'] == cat_id)['posts']
        .singleWhere((element) => element['id'] == post_id)['loves']++;

    myData['postsIloved'].add(post_id);
    //s.update({'likes': userData['categories'][cat_id]['posts'][post_id]['likes']});
    s.update({'categories': userData['categories']});
    me.update({'postsIloved': myData['postsIloved']});

    //fetchData();updateData(); notifyListeners();
  }

  void addToReported(int post_id) async {
    print("adding to Reported");
    reported.add(post_id);
    await userDocument.update({'reported': reported});
  }

//
  Future<bool?> removeLove(
    String? myEmail,
    String? email,
    int post_id,
    int cat_id,
  ) async {
    print("Removing love");

    if (email == null) {
      categories
          .singleWhere((element) => element['id'] == cat_id)['posts']
          .singleWhere((element) => element['id'] == post_id)['likers']
          .add(email);

      updateData();
    } else {
      var s = FirebaseFirestore.instance.collection('users').doc(email);
      DocumentSnapshot userSnapshot = await s.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      var me = FirebaseFirestore.instance.collection('users').doc(myEmail);
      DocumentSnapshot userSnapshot2 = await me.get();
      Map<String, dynamic> myData =
          userSnapshot2.data() as Map<String, dynamic>;

      var likers = userData['categories']
          .singleWhere((element) => element['id'] == cat_id)['posts']
          .singleWhere((element) => element['id'] == post_id)['lovers'];

      userData['categories']
          .singleWhere((element) => element['id'] == cat_id)['posts']
          .singleWhere((element) => element['id'] == post_id)['loves']--;

      likers.remove(userData['username']);

      myData['postsIloved'].remove(post_id);
      s.update({'categories': userData['categories']});
      me.update({'postsIloved': myData['postsIloved']});
    }
  }
}
