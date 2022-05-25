import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

//TODO: until now all the function for login&& logout form facebook i call from Loginpage

class FacebookLogin extends ChangeNotifier {
  AccessToken? _accessToken;
  UserModel? _currentUser;
  FacebookLogin.instance() {}

  Future<void> loginFace() async {
    notifyListeners();
    final LoginResult login_res = await FacebookAuth.i.login();
    if (login_res.status == LoginStatus.success) {
      _accessToken = login_res.accessToken;
      final data = await FacebookAuth.i.getUserData();
      UserModel model = UserModel.fromJson(data);
      final facebook =
          FacebookAuthProvider.credential(login_res.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebook);
      _currentUser = model;
    }
    notifyListeners();
  }

  Future signOutFace() async {
    notifyListeners();
    await FacebookAuth.i.logOut();
    _currentUser = null;
    _accessToken = null;
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}

class PictureModel {
  final String? url;
  final int? height;
  final int? width;

  const PictureModel({this.width, this.height, this.url});
  factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
      url: json['url'], width: json['width'], height: json['height']);
}

class UserModel {
  final String? name;
  final String? id;
  final String? email;
  final PictureModel? picture;
  const UserModel({this.name, this.picture, this.email, this.id});
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      email: json['email'],
      id: json['id'] as String?,
      name: json['name'],
      picture: PictureModel.fromJson(json['picture']['data']));
/*
  {
 {
  "id": "USER-ID",
  "name": "EXAMPLE NAME",
  "email": "EXAMPLE@EMAIL.COM",
  "picture": {
    "data": {
      "height": 50,
      "is_silhouette": false,
      "url": "URL-FOR-USER-PROFILE-PICTURE",
      "width": 50
    }
  }
}
   */

}

Future signOutFace() async {
await FacebookAuth.i.logOut();
_currentUser = null;
_accessToken = null;
setState(() {});
}
}

class PictureModel {
  final String? url;
  final int? height;
  final int? width;

  const PictureModel({this.width, this.height, this.url});
  factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
      url: json['url'], width: json['width'], height: json['height']);
}

class UserModel {
  final String? name;
  final String? id;
  final String? email;
  final PictureModel? picture;
  const UserModel({this.name, this.picture, this.email, this.id});
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      email: json['email'],
      id: json['id'] as String?,
      name: json['name'],
      picture: PictureModel.fromJson(json['picture']['data']));
/*
  {
 {
  "id": "USER-ID",
  "name": "EXAMPLE NAME",
  "email": "EXAMPLE@EMAIL.COM",
  "picture": {
    "data": {
      "height": 50,
      "is_silhouette": false,
      "url": "URL-FOR-USER-PROFILE-PICTURE",
      "width": 50
    }
  }
}
   */

}
}