import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }
//enum LogFrom { Anonymous, Facebook, Google, Email }

class AuthRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User? _user;
  Status _status = Status.Uninitialized;
  //LogFrom _logFrom = LogFrom.Anonymous;

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
      // _logFrom = LogFrom.Email;
      _status = Status.Authenticating;
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
      //   }
      // }else if (status == LogFrom.Facebook) {
      //   try {
      //     _logFrom = LogFrom.Facebook;
      //     _status = Status.Authenticating;
      //     return await _auth.createUserWithEmailAndPassword(
      //         email: email, password: password);
      //   } catch (e) {
      //     print(e);
      //     _status = Status.Unauthenticated;
      //     notifyListeners();
      //     return null;
      //   }
      // }else{
      //   if (status == LogFrom.Google) {
      //     try {
      //       _logFrom = LogFrom.Google;
      //       _status = Status.Authenticating;
      //       return await _auth.createUserWithEmailAndPassword(
      //           email: email, password: password);
      //     } catch (e) {
      //       print(e);
      //       _status = Status.Unauthenticated;
      //       notifyListeners();
      //       return null;
      //     }
      // }

    }
  }

  Future<bool> signIn(String email, String password) async {
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
