// @dart=2.9

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:savet/Services/CategoryDB.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Notifications/notificationsHelper.dart';
import 'Services/user_db.dart';
import 'auth/auth_repository.dart';
import 'auth/login_page.dart';

final FlutterLocalNotificationsPlugin notifsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationAppLaunchDetails notifLaunch =
      await notifsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(notifsPlugin);
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );
  await notifsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthRepository.instance(),
      ),
      StreamProvider(
        create: (context) => context.read<AuthRepository>().onAuthStateChanged,
      ),
      ChangeNotifierProvider(create: (context) => UserDB()),
      ChangeNotifierProvider(create: (context) => CategoryDB()),
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
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.20),
      child: SplashScreen(
        seconds: 3,
        useLoader: true,
        navigateAfterSeconds: const Login(),
        //navigateAfterSeconds: const test(), TODO:for tests
        title: const Text(
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
