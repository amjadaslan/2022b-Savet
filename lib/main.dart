// @dart=2.9

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'auth/login_page.dart';
import 'package:flutter/src/services/asset_bundle.dart';
import 'package:flutter/src/painting/image_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savet',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Splash2(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class Splash2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 6,
      navigateAfterSeconds: new Login(),
      title: new Text('Savet',textScaleFactor: 2,style: TextStyle(color: Colors.white),),
      image: Image.asset("assets/image/splash.png"),
      backgroundColor: Colors.deepOrange,
      loadingText: Text("Loading",style: TextStyle(color: Colors.white),),
      photoSize: 100.0,
      loaderColor: Colors.white,
    );
  }
}

