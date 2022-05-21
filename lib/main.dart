// @dart=2.9

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'auth/login_page.dart';
import 'auth/auth_repoitory.dart';
import 'Services/user_db.dart';

import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthRepository.instance(),
      ),
      StreamProvider(
        create: (context) => context.read<AuthRepository>().onAuthStateChanged,
      ),
      ChangeNotifierProvider(create: (context) => UserDB()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Savet',
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
            ),
            home: Splash2(),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}

class Splash2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrange,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
      child: SplashScreen(
        seconds: 3,
        useLoader: true,
        navigateAfterSeconds: Login(),
        title: new Text(
          '',
          textScaleFactor: 2,
          style: TextStyle(color: Colors.white),
        ),
        image: Image.asset("assets/image/splash.png"),
        backgroundColor: Colors.deepOrange,
        photoSize: 150.0,
        loaderColor: Colors.white,
      ),
    );
  }
}
