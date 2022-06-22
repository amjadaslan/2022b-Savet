import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CategoryDB extends ChangeNotifier {
  late DocumentReference userDocument;

  void changeCategoryProfile(int cat_id, String new_img) async {
    final auth = FirebaseAuth.instance.currentUser;
    var user_email = !(auth!.isAnonymous) ? auth.email : auth.uid;
    userDocument =
        FirebaseFirestore.instance.collection('users').doc(user_email);
    DocumentSnapshot userSnapshot = await userDocument.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    var categories = userData['categories'];
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
    final auth = FirebaseAuth.instance.currentUser;
    var user_email = !(auth!.isAnonymous) ? auth.email : auth.uid;
    userDocument =
        FirebaseFirestore.instance.collection('users').doc(user_email);
    DocumentSnapshot userSnapshot = await userDocument.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    var categories = userData['categories'];
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
      final auth = FirebaseAuth.instance.currentUser;
      var user_email = !(auth!.isAnonymous) ? auth.email : auth.uid;
      userDocument =
          FirebaseFirestore.instance.collection('users').doc(user_email);
      DocumentSnapshot userSnapshot = await userDocument.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      var categories = userData['categories'];
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
      final auth = FirebaseAuth.instance.currentUser;
      var user_email = !(auth!.isAnonymous) ? auth.email : auth.uid;
      userDocument =
          FirebaseFirestore.instance.collection('users').doc(user_email);
      DocumentSnapshot userSnapshot = await userDocument.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      var categories = userData['categories'];

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
    final auth = FirebaseAuth.instance.currentUser;
    var user_email = !(auth!.isAnonymous) ? auth.email : auth.uid;
    userDocument =
        FirebaseFirestore.instance.collection('users').doc(user_email);
    DocumentSnapshot userSnapshot = await userDocument.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    var categories = userData['categories'];
    File imageFile = File(new_img);
    String c = new_img.hashCode.toString();
    await FirebaseStorage.instance.ref('$c').putFile(imageFile);
    String path =
        await FirebaseStorage.instance.ref().child('$c').getDownloadURL();

    var avatar_path = path;
    userDocument.update({'avatar_path': avatar_path});
    notifyListeners();
  }

  Future<void> addCategory(
      String title, String desc, String profile_img, String tag) async {
    final auth = FirebaseAuth.instance.currentUser;
    var user_email = !(auth!.isAnonymous) ? auth.email : auth.uid;
    userDocument =
        FirebaseFirestore.instance.collection('users').doc(user_email);
    DocumentSnapshot userSnapshot = await userDocument.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    var categories = userData['categories'];
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
    final auth = FirebaseAuth.instance.currentUser;
    var user_email = !(auth!.isAnonymous) ? auth.email : auth.uid;
    userDocument =
        FirebaseFirestore.instance.collection('users').doc(user_email);
    DocumentSnapshot userSnapshot = await userDocument.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    var categories = userData['categories'];
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
          'likers': []
        });
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
          'likers': []
        });
        if (categories[0]['posts'].length() > 20) {
          categories[0]['posts'].removeLast();
        }
      }
    });
    userDocument.update({'categories': categories});
    notifyListeners();
  }

  Future<void> removeCategory(int c_id) async {
    final auth = FirebaseAuth.instance.currentUser;
    var user_email = !(auth!.isAnonymous) ? auth.email : auth.uid;
    userDocument =
        FirebaseFirestore.instance.collection('users').doc(user_email);
    DocumentSnapshot userSnapshot = await userDocument.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    var categories = userData['categories'];

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
    categories[0]['posts'].removeWhere((p) => p['cat_id'] == c_id);

    userDocument.update({'categories': categories});
    notifyListeners();
  }

  Future<void> removePost(int p_id, int c_id) async {
    final auth = FirebaseAuth.instance.currentUser;
    var user_email = !(auth!.isAnonymous) ? auth.email : auth.uid;
    userDocument =
        FirebaseFirestore.instance.collection('users').doc(user_email);
    DocumentSnapshot userSnapshot = await userDocument.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    var categories = userData['categories'];
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
    categories[0]['posts'].removeWhere((p) => p_id == p['id']);
    pathToDelete = RegExp('\/o\/([0-9]*)').firstMatch(pathToDelete!)?.group(1);
    await FirebaseStorage.instance.ref('$pathToDelete').delete();

    userDocument.update({'categories': categories});
    notifyListeners();
  }

  void changeDate(int cat_id, int post_id, String date, String _time) async {
    final auth = FirebaseAuth.instance.currentUser;
    var user_email = !(auth!.isAnonymous) ? auth.email : auth.uid;
    userDocument =
        FirebaseFirestore.instance.collection('users').doc(user_email);
    DocumentSnapshot userSnapshot = await userDocument.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    var categories = userData['categories'];
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
}
