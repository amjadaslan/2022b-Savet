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

  bool get isAuthenticated => status == Status.Authenticated;

  // Future<String> getDownloadUrl() async {
  //   return await _storage.ref('images').child(_user!.uid).getDownloadURL();
  // }
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
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
    print("sigOut");
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

  String? getUserEmail(){
    return _user!.email;
  }


  // Widget _showProfile(String? s) {
  //   String _imageURL;
  //   String? userID = AuthRepository.instance().user?.uid;
  //   return Container(
  //       color: Colors.white,
  //       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
  //       child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //         FutureBuilder(
  //             future: FirebaseStorage.instance
  //                 .ref()
  //                 .child('$userID/profilePic')
  //                 .getDownloadURL(),
  //             builder: (context, AsyncSnapshot<String> snapshot) {
  //               _imageURL = snapshot.data ??
  //                   'https://cdn-icons-png.flaticon.com/512/847/847969.png';
  //               return CircleAvatar(
  //                   backgroundImage: NetworkImage(_imageURL), radius: 40);
  //             }),
  //         const SizedBox(width: 20),
  //         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //           AutoSizeText('$s',
  //               style: const TextStyle(fontSize: 20), maxLines: 1),
  //           const SizedBox(height: 8),
  //           TextButton(
  //               child: const AutoSizeText("Change avatar",
  //                   style: TextStyle(fontSize: 10), maxLines: 1),
  //               style: TextButton.styleFrom(
  //                   primary: Colors.white,
  //                   fixedSize: const Size(120, 10),
  //                   backgroundColor: Colors.lightBlue),
  //               onPressed: _imagePicker)
  //         ])
  //       ]));
  // }
  //
  // void _imagePicker() async {
  //   final picker = ImagePicker();
  //   XFile? pickedImage;
  //
  //   pickedImage =
  //   await picker.pickImage(source: ImageSource.gallery, maxWidth: 1920);
  //
  //   if (pickedImage == null) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text('No image selected')));
  //     return;
  //   }
  //
  //   File imageFile = File(pickedImage.path);
  //
  //   // Uploading the selected image
  //   final user = AuthRepository.instance();
  //   String? userID = user.user?.uid;
  //   await FirebaseStorage.instance.ref('$userID/profilePic').putFile(imageFile);
  // }


}