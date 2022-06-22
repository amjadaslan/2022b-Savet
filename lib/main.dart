// @dart=2.9

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    'High Importance Notifications', '', // title
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
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile> _sharedFiles;

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        print("Shared:" + (_sharedFiles.map((f) => f.path).join(",")));
        _sharedFiles = value ?? [];
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value ?? [];
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    ReceiveSharingIntent.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("\n\n\n\n\n\n\n\n\n");
    print(_sharedFiles);

    print("\n\n\n\n\n\n\n\n\n");
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Savet',
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
            ),
            home: Splash2(sharedFiles: _sharedFiles),
            debugShowCheckedModeBanner: false,
          );
        });
  }
}

class Splash2 extends StatefulWidget {
  Splash2({this.sharedFiles});
  List sharedFiles;

  @override
  State<Splash2> createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  @override
  Widget build(BuildContext context) {
    print("\n\n\n\n\n\n\n\n\n");
    print("main");
    print(widget.sharedFiles);
    print("\n\n\n\n\n\n\n\n\n");
    return Container(
      color: Colors.deepOrange,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.20),
      child: SplashScreen(
        seconds: 3,
        useLoader: true,
        navigateAfterSeconds: Login(sharedFiles: widget.sharedFiles),
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
