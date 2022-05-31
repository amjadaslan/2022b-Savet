import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'package:savet/auth/Register.dart';
import 'package:savet/auth/anonymous.dart';
import 'package:savet/homepage.dart';

import '../Services/user_db.dart';
import '../homepage.dart';
import 'Register.dart';
import 'auth_repository.dart';
import 'googleLogin.dart';

class LoginAnonymous extends StatefulWidget {
  const LoginAnonymous({Key? key}) : super(key: key);

  @override
  State<LoginAnonymous> createState() => _LoginAnonymousState();
  Future signOut() => _LoginAnonymousState().signOutFace();
}

class _LoginAnonymousState extends State<LoginAnonymous> {
  AccessToken? _accessToken;
  UserModel? _currentUser;
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _password = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  String LogFrom = "";

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    print("Anonymous login");
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: false,
        ),
        body: FutureBuilder(builder: (context, snapshot) {
          return LoginScreen();
        }));
  }

  Widget LoginScreen() {
    final user = Provider.of<AuthRepository>(context);
    var auth = FirebaseAuth.instance;
    var last = auth.currentUser?.uid;
    return SingleChildScrollView(
      child: Center(
          child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(''),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Material(
                elevation: 3,
                shadowColor: Colors.black,
                child: TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                    labelText: 'Email',
                    fillColor: Colors.black12,
                    filled: true,
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Please enter your Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: Material(
                elevation: 3,
                shadowColor: Colors.black,
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Enter your password',
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            Padding(
                padding: const EdgeInsets.only(left: 215.0),
                child: TextButton(
                    child: const Text("Forgot password?"),
                    onPressed: () {
                      //TODO: need to implement it
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const ResetPassword()));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Not implemented yet')));
                    })),

            const Text(''),

            Container(
              height: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                  child: const Text(
                    'Log in',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () async {
                    if ((await user.signIn(_email.text, _password.text))) {
                      LogFrom = "Email";
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FutureBuilder(
                                  future:
                                      Provider.of<UserDB>(context).fetchData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text(snapshot.error.toString()));
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return homepage(LoginFrom: LogFrom);
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  })));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Incorrect credentials. Try again.')));
                    }
                    ;
                  }),
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(20)),
            ),

            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 80.0),
              child: Row(children: <Widget>[
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        print('Facebook Tap');
                        LogFrom = "Facebook";
                        await loginFace();
                        if (auth.currentUser != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FutureBuilder(
                                      future: Provider.of<UserDB>(context)
                                          .fetchData(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  snapshot.error.toString()));
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return homepage(LoginFrom: LogFrom);
                                        }
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      })));
                        }
                      },
                      child: Image.asset(
                        'assets/image/facebook.png',
                        width: 80,
                        height: 80,
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        print('Google Tap Anonymous');
                        LogFrom = "Google";
                        var x = Google.instance();
                        Anonymous.instance().signOut();
                        await x.signIn();
                        var boo = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(auth.currentUser?.email)
                            .get();
                        if (x.currentUser() != null && boo.exists) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FutureBuilder(
                                      future: Provider.of<UserDB>(context)
                                          .fetchData(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return homepage(LoginFrom: LogFrom);
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  snapshot.error.toString()));
                                        }
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      })));
                        }
                      }, // Image tapped
                      child: Image.asset(
                        'assets/image/google.png',
                        width: 100,
                        height: 100,
                      ),
                    )),
              ]),
            ),

            //Register
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 120),
              //padding:  EdgeInsets.symmetric(horizontal: 15),

              child: RichText(
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(
                        text: "Don't have an account ? ",
                        style: TextStyle(color: Colors.black)),
                    TextSpan(
                        text: 'Register',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('Register Tap');
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Register(LogFrom: "Email")));
                            });
                          }),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
    // }
  }

  Future<void> loginFace() async {
    final LoginResult login_res = await FacebookAuth.i.login();
    var auth = FirebaseAuth.instance;
    //final googleAuth = await login_res?.authentication;
    try {
      if (login_res.status == LoginStatus.success) {
        _accessToken = login_res.accessToken;
        final data = await FacebookAuth.i.getUserData();
        UserModel model = UserModel.fromJson(data);

        final facebook =
            FacebookAuthProvider.credential(login_res.accessToken!.token);
        if (auth.currentUser != null) {
          final userCredential = await FirebaseAuth.instance.currentUser
              ?.linkWithCredential(facebook);
          Anonymous.instance().signOut();
        }
        await auth.signInWithCredential(facebook);
        if (!(await FirebaseFirestore.instance
                .collection('users')
                .doc(auth.currentUser?.email)
                .get())
            .exists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(auth.currentUser?.email)
              .set({
            'username': auth.currentUser?.displayName,
            'avatar_path': model.picture?.url
          });
        }
        _currentUser = model;
        LogFrom = "Facebook";
      }
    } catch (e) {
      print("ERROR Facebook login $e");
    }
  }

  Future signOutFace() async {
    var auth = FirebaseAuth.instance;
    await FacebookAuth.i.logOut();
    _currentUser = null;
    _accessToken = null;
    await auth.signOut();
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
}
