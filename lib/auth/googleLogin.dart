import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:savet/auth/anonymous.dart';

class Google extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? _currentUser;

  GoogleSignInAccount? currentUser() => _currentUser;

  Google.instance() {
    _googleSignIn.onCurrentUserChanged.listen((account) {});
    _googleSignIn.signInSilently();
    print("Google init");
  }

  Future signOut() async {
    print("Sign Out From Google account");
    _googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<void> signIn() async {
    try {
      var auth = FirebaseAuth.instance;
      var store = FirebaseFirestore.instance;
      print("SignIn Google");
      await _googleSignIn.signIn();
      _currentUser = _googleSignIn.currentUser;
      final googleAuth = await _currentUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      if (auth.currentUser != null) {
        final userCredential = await FirebaseAuth.instance.currentUser
            ?.linkWithCredential(credential);
        Anonymous.instance().signOut();
      }
      await auth.signInWithCredential(credential);
      var boo =
          await store.collection('users').doc(auth.currentUser?.email).get();

      if (!(boo).exists) {
        await store.collection('users').doc(auth.currentUser?.email).set({
          'username': auth.currentUser?.displayName,
          'avatar_path': auth.currentUser?.photoURL,
          'log_from': "Google",
        });
      }
    } catch (e) {
      print("ERROR signing in $e");
    }
  }
}
