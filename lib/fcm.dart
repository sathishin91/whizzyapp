import 'package:WHIZZYPCS/constants/theme_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/preference_helper.dart';
import 'routes/route_generator.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
FirebaseMessaging messaging = FirebaseMessaging.instance;

dynamic appToken = "";

Future<void> fcmToken() async {
  FirebaseMessaging.instance.getToken().then((newToken) {
    print("FCM Token:");
    appToken = newToken;
    print(newToken);
  });
  FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
    print("New token: $token");
    appToken = token;
    // sync token to server
  });
}

Future<void> notificationCame() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPushNotificationCame', false);
  } catch (e) {}
}

Future<void> notificationInfo() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPushNotificationInfo', false);
  } catch (e) {}
}

Future<void> fcmNotifications([message]) async {
  print("message ${message.toString()}");

  // Get the initial message data
  // RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    print("Initial message received");

    if (notification != null && android != null) {
      showLocalNotification(notification);
    }
  }
  // Listen for subsequent messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    print("Subsequent message received");

    if (notification != null && android != null) {
      showLocalNotification(notification);
    }
  });
}

Future<void> storeMessageLocallyPref(RemoteMessage message) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    if (message.notification != null) {
      await prefs.setString('target_action', message.data['target_action']);
      await prefs.setString('target_value', message.data['target_value']);
      await prefs.setString('param1', message.data['param1']);
      await prefs.setBool('isPushNotificationCame', true);
      await prefs.setBool('isPushNotificationRoutes', true);
    }
  } catch (e) {}
  await getStoredMessageSharePref();
}

Future<RemoteMessage?> getStoredMessageSharePref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? target_action, target_value, param1;
  bool? isPushNotificationCame, isMpinVerified;
  try {
    target_action = prefs.getString('target_action');
    target_value = prefs.getString('target_value');
    param1 = prefs.getString('param1');
    isPushNotificationCame = prefs.getBool('isPushNotificationCame');
    isMpinVerified = prefs.getBool('isMpinVerified') ?? false;
  } catch (e) {}
  bool? accountCreated = await PreferenceHelper.checkIfAccountCreated;
  print("checkIfAccountCreated $accountCreated");
  if (accountCreated == true) {
    if (isMpinVerified! &&
        isPushNotificationCame != null &&
        isPushNotificationCame) {
      if (target_action == "launch_page") {
      } else {
        goHome();
      }
    } else {
      goHome();
    }
  } else {
    Navigator.pushReplacementNamed(
        navigatorKey.currentState!.context, Routes.loginScreen);
  }
}

void goHome() {
  Navigator.pushReplacementNamed(
      navigatorKey.currentState!.context, Routes.dashboard);
}

void showLocalNotification(RemoteNotification notification) {
  flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        color: ThemeConstants.primaryColor,
        playSound: true,
        icon: '@drawable/notification_icon',
      ),
    ),
  );
}

// not using this methods
fcmNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);
  return channel;
}

void showFlutterNotification(RemoteMessage message) async {
  AndroidNotificationChannel channel = await fcmNotificationChannel();
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          color: Colors.blue,
          playSound: true,
          icon: '@mipmap/launcher_icon',
        ),
      ),
    );
  }
}

Future<void> fcmAppNotifications(BuildContext context) async {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title!),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body!)],
                ),
              ),
            );
          });
    }
  });
}

bool isFlutterLocalNotificationsInitialized = false;
Future<void> setupFlutterNotifications() async {
  AndroidNotificationChannel channel = await fcmNotificationChannel();
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showNotification() async {
  AndroidNotificationChannel channel = await fcmNotificationChannel();
  flutterLocalNotificationsPlugin.show(
      0,
      "Testing",
      "How you doing?",
      NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher')));
}
