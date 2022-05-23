import 'dart:io';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User? _user;
  String? _username;
  Status _status = Status.Uninitialized;
  //FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //FirebaseStorage _storage = FirebaseStorage.instance;

  AuthRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    _user = _auth.currentUser;
    _onAuthStateChanged(_user);
  }

  Status get status => _status;

  User? get user => _user;

  String? get username => _username;

  bool get isAuthenticated => status == Status.Authenticated;

  Stream<User?> get onAuthStateChanged {
    return _auth.authStateChanges();
  }

  // Future<String> getDownloadUrl() async {
  //   return await _storage.ref('images').child(_user!.uid).getDownloadURL();
  // }
  Future<UserCredential?> signUp(String email, String password,String username) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      _username=username;
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<bool> signIn(String email, String password) async {
    //_auth.signIn("facebook", )
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _status = Status.Authenticated;
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    print("signOut");
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future resetPassword() async {
    print("resetPassword");
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      // await getfavourites();
    }
    notifyListeners();
  }

  String? getUserEmail() {
    return _user!.email;
  }
}
