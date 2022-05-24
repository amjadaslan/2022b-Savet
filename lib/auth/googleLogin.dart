import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLogin extends StatefulWidget {
  const GoogleLogin({Key? key}) : super(key: key);

  @override
  State<GoogleLogin> createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? _currentUser;
  FirebaseAuth? _auth = FirebaseAuth.instance;
  bool isUserSignedIn = false;

  void initStart() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
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
    if (user != null) {
      return Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            ListTile(
              leading: GoogleUserCircleAvatar(
                identity: user,
              ),
              title: Text(user.displayName ?? ''),
              subtitle: Text(user.email),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Sign in Successfully",
                style: TextStyle(
                  fontSize: 20,
                )),
            ElevatedButton(onPressed: signOut, child: const Text('Sign out')),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "you are not signed in",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: signIn, child: const Text("Sign In")),
          ],
        ),
      );
    }
  }

  void signOut() {
    print("Sign Out Google");
    _googleSignIn.disconnect();
    setState(() {
      _currentUser = null;
    });
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
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("ERROR signing in $e");
    }
  }
}
