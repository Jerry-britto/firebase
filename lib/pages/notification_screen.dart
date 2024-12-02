import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static const route = "/notification-screen";

  @override
  Widget build(BuildContext context) {
    final message =
        ModalRoute.of(context)!.settings.arguments as RemoteMessage?;
    ;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notification screen",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Notification Title: ${message?.notification?.title}"),
            Text("Notification body: ${message?.notification?.body}"),
            Text("${message?.data}"),
          ],
        ),
      ),
    );
  }
}
