// @dart=2.9

import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:savet/Services/CategoryDB.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Notifications/notificationsHelper.dart';
import 'Services/user_db.dart';
import 'auth/auth_repository.dart';
import 'auth/login_page.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin notifsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

// Future<void> findTokenByEmail(String email) async {
//   String t ="";
//   var s =  FirebaseFirestore.instance.collection('tokens').doc(email);
//   DocumentSnapshot userSnapshot = await s.get();
//   Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
//   t = userData['token'];
//
//   return t;
//       }


void sendPushMessage(String token, String body, String title) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAEAQEpaU:APA91bGMa8MAgGTYp3i0lGV7dxSIY_EctODZP_70Fa_U6ucsDVPyeT11iw70RcPT1GCWP_F8zjTNNjQM0tx-mij2xhxoYGmxpgvjbjEW-nzJfiv2QsP-4eNdlStx_4-TQpn3J9KOBrgY',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          "to": token,
        },
      ),
    );
  } catch (e) {
    print("error push notification");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initNotifications(notifsPlugin);
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );

  // await notifsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await Firebase.initializeApp();
  // await FirebaseMessaging.instance.getToken();
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   RemoteNotification notification = message.notification;
  //   AndroidNotification android = message.notification?.android;
  //
  //   // If `onMessage` is triggered with a notification, construct our own
  //   // local notification to show to users using the created channel.
  //   if (notification != null && android != null ) {
  //     notifsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             priority: Priority.max,
  //             icon: android.smallIcon,
  //           ),
  //         ));
  //   }
  // });

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
