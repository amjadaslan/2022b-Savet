import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Google extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? _currentUser;

  GoogleSignInAccount? cureentUser() => _currentUser;

  Google.instance() {
    _googleSignIn.onCurrentUserChanged.listen((account) {});
    _googleSignIn.signInSilently();
    print("Google init");
  }
  Future signOut() async {
    notifyListeners();
    print("Sign Out From Google account");
    _googleSignIn.disconnect();
    _currentUser = null;
    await FirebaseAuth.instance.signOut();
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> signIn() async {
    try {
      notifyListeners();
      print("SignIn Google");
      await _googleSignIn.signIn();

      _currentUser = _googleSignIn.currentUser;
      final googleAuth = await _currentUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      notifyListeners();
      if (!(await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.email)
              .get())
          .exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.email)
            .set({
          'username': FirebaseAuth.instance.currentUser?.displayName,
          'avatar_path': FirebaseAuth.instance.currentUser?.photoURL
        });
        notifyListeners();
        return Future.delayed(Duration(seconds: 2));
      }
    } catch (e) {
      print("ERROR signing in $e");
    }
  }
}
