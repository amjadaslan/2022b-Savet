import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:savet/auth/anonymous.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User? _user;
  Status _status = Status.Uninitialized;

  AuthRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    _user = _auth.currentUser;
    _onAuthStateChanged(_user);
  }
  Status get status => _status;
  // LogFrom get logFtom => _logFrom;
  User? get user => _user;

  bool get isAuthenticated => status == Status.Authenticated;

  Stream<User?> get onAuthStateChanged {
    return _auth.authStateChanges();
  }

  Future<UserCredential?> signUp(
      String email, String password, String userName) async {
    try {
      _status = Status.Authenticating;

      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      print("Debug");
      print(_auth.currentUser);
      if (_auth.currentUser != null) {
        final userCredential = await FirebaseAuth.instance.currentUser
            ?.linkWithCredential(credential);
        if (userCredential != null) {
          Anonymous.instance().signOut();
        } else {
          return null;
        }
      }
      var temp = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _status = Status.Authenticated;
      print("Debug2");
      print(_auth.currentUser);


      return temp;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();

      rethrow;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      if (credential != null) {
        Anonymous.instance().signOut();
      }
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

  Future resetPassword({required String email}) async {
    print("resetPassword");
    print(email);
    await _auth.sendPasswordResetEmail(email: email);
    return null;
    //_auth.sendPasswordResetEmail(email: email);
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
    }
    notifyListeners();
  }

  String? getUserEmail() {
    return _user!.email;
  }
}
