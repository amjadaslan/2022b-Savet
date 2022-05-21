import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:savet/auth/Register.dart';
import 'package:savet/homepage.dart';
import '../Services/user_db.dart';
import 'ResetPassword.dart';
import 'auth_repoitory.dart';
import 'package:provider/provider.dart';
import 'Register.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'facebookLogin.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AccessToken? _accessToken;
  UserModel? _currentUser;
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _password = new TextEditingController();
  TextEditingController _email = new TextEditingController();

  @override
  void initState() {
    super.initState();
    AuthRepository.instance();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return (Provider.of<AuthRepository>(context).isAuthenticated)
        ? homepage()
        : Scaffold(
            appBar: AppBar(
              title: Text('Login'),
              centerTitle: false,
              automaticallyImplyLeading: false,
            ),
            body: FutureBuilder(
                future: _initializeFirebase(),
                builder: (context, snapshot) {
                  return FutureBuilder(
                      future: Provider.of<UserDB>(context).fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return LoginScreen();
                        }
                        return Center(child: CircularProgressIndicator());
                      });
                }));
  }

  Widget LoginScreen() {
    final user = Provider.of<AuthRepository>(context);
    UserModel? userModel = _currentUser;
    // if(user.isAuthenticated)
    //   user.signOut();
    if (userModel != null) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: userModel.picture!.width! / 6,
                backgroundImage: NetworkImage(userModel.picture!.url!),
              ),
              title: Text(userModel.name!),
              subtitle: Text(userModel.email!),
            ),
            const SizedBox(height: 20),
            const Text('sign in successfully', style: TextStyle(fontSize: 20)),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: signOutFace, child: Text('sign out'))
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Center(
            child: SizedBox(
          // width:  height: MediaQuery.of(context).size.width*0.1,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              const Text(''),
              const SizedBox(height: 20),

              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Material(
                  elevation: 3,
                  shadowColor: Colors.black,
                  child: TextField(
                    controller: _email,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
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
                      contentPadding:
                          EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
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
                      child: Text("forgot password?"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ResetPassword()));
                      })),

              const Text(''),
              user.status == Status.Authenticating
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.width * 0.1,
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        child: const Text(
                          'Log in',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        onPressed: () async {
                          await user.signIn(_email.text, _password.text);
                          (user.isAuthenticated)
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => homepage()))
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Incorrect credentials. Try again.')));
                        },
                      ),
                      decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(20)),
                    ),

              Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  //padding:  EdgeInsets.symmetric(horizontal: 15),
                  child: TextButton(
                      child: const Text(
                        "Login as a guest",
                        style: TextStyle(color: Colors.black54),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => homepage()));
                      })),

              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 80.0),
                child: Row(children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: loginFace,
                        child: Image.asset(
                          'assets/image/facebook.png',
                          width: 80,
                          height: 80,
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => homepage()));
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
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 120),
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
                                            const Register()));
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
    }
  }

  Future<void> loginFace() async {
    final LoginResult login_res = await FacebookAuth.i.login();
    if (login_res.status == LoginStatus.success) {
      _accessToken = login_res.accessToken;
      final data = await FacebookAuth.i.getUserData();
      UserModel model = UserModel.fromJson(data);
      final facebook =
          FacebookAuthProvider.credential(login_res.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebook);
      //await FirebaseFiretore.instance.
      _currentUser = model;
      setState(() {});
    }
  }

  Future<void> signOutFace() async {
    await FacebookAuth.i.logOut();
    _currentUser = null;
    _accessToken = null;
    setState(() {});
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
/*
  {
 {
  "id": "USER-ID",
  "name": "EXAMPLE NAME",
  "email": "EXAMPLE@EMAIL.COM",
  "picture": {
    "data": {
      "height": 50,
      "is_silhouette": false,
      "url": "URL-FOR-USER-PROFILE-PICTURE",
      "width": 50
    }
  }
}
   */

}
