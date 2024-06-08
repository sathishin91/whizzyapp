import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'di/get_it.dart';
import 'fcm.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    unawaited(init());

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    fcmToken();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    FirebaseMessaging.onMessage.listen(onMessage);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]).then((value) => runApp(const MyApp()));
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

// Define the method for handling push notifications when the app is open
Future<dynamic> onMessage(RemoteMessage message) async {
  print("first time");
  // await fcmNotifications(message);
}

Future<dynamic> onMessageOpenedApp(RemoteMessage message) async {
  print('onMessageOpenedApp: ${message.toMap()}');
  // await fcmNotifications(message);
  await storeMessageLocallyPref(message);
  // Do something with the notification payload, such as showing a specific screen or displaying some content
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {
  print('onBackgroundMessage: ${message.notification?.title}');
  await Firebase.initializeApp();
  //await fcmNotifications(message);
  await storeMessageLocallyPref(message);
  // Do something with the notification payload, such as showing a notification to the user or updating app data
}
