import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/notification_screen.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}

class FirebaseApi {
  // ignore: non_constant_identifier_names
  final _firebaseMessaging = FirebaseMessaging.instance;

  final AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
    'high_importance_channel', // Channel ID
    'High Importance Notifications', // Channel name
    description:
        'This channel is used for important notifications.', // Description
    importance: Importance.high, // Importance level
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState
        ?.pushNamed(NotificationScreen.route, arguments: message);
  }

  Future initLocalNotifications() async {
  const android = AndroidInitializationSettings("@drawable/ic_launcher");
  const settings = InitializationSettings(android: android);

  await _localNotifications.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null) {
        final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
        handleMessage(message);
      }
    },
  );

  final platform = _localNotifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  await platform?.createNotificationChannel(androidChannel);
}


  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) {
        return;
      }
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  androidChannel.id, androidChannel.name,
                  channelDescription: androidChannel.description,
                  icon: "@drawable/ic_launcher")),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("Token $fCMToken");

    initPushNotifications();
    initLocalNotifications();
  }
}
