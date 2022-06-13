import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Anonymous extends ChangeNotifier {
  Anonymous.instance() {
    print("Anonymous init");
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<void> signIn() async {
    var auth = FirebaseAuth.instance;
    var store = FirebaseFirestore.instance;
    try {
      print("SignIn Anonymous");
      await auth.signInAnonymously();
      await store
          .collection('users')
          .doc(auth.currentUser?.uid)
          .set({'username': 'Anonymous', 'log_from': "Anonymous"});
    } catch (e) {
      print("ERROR signing in $e");
    }
  }
}
