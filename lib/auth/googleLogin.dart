import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:savet/auth/auth_repository.dart';

import '../Services/user_db.dart';
import '../homepage.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class GoogleLogin extends StatefulWidget {
  const GoogleLogin({Key? key}) : super(key: key);

  @override
  State<GoogleLogin> createState() => _GoogleLoginState();
  Future signOut() => _GoogleLoginState().signOut();
  //GoogleLogin.instance() : _auth = FirebaseAuth.instance {

}

class _GoogleLoginState extends State<GoogleLogin> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? _currentUser;
  Status _status = Status.Uninitialized;

  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    print("Google init");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google sign in Test"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: _bulidWidget(),
      ),
    );
  }

  Widget _bulidWidget() {
    GoogleSignInAccount? user = _currentUser;
    print(Provider.of<AuthRepository>(context).user);
    if (user != null) {
      return FutureBuilder(
          future: Provider.of<UserDB>(context).fetchDataGoogleFacebook(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.connectionState == ConnectionState.done) {
              return const homepage();
            }
            return const Center(child: CircularProgressIndicator());
          });
    } else {
      signIn();
      //Navigator.pop(context);
      return SizedBox.shrink();
    }
  }

  Future signOut() async {
    print("Sign Out Google");
    _googleSignIn.disconnect();
    setState(() {
      _currentUser = null;
    });
    return Future.delayed(Duration.zero);
  }

  Future<void> signIn() async {
    try {
      print("SignIn Google");
      await _googleSignIn.signIn();
      setState(() {
        _currentUser = _googleSignIn.currentUser;
      });
      final googleAuth = await _currentUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      if (FirebaseAuth.instance == null) print("Null FireBase");
      _status = Status.Authenticating;
      await FirebaseAuth.instance.signInWithCredential(credential);
      _status = Status.Authenticated;
    } catch (e) {
      print("ERROR signing in $e");
    }
  }
}
