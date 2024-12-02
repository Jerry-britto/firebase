import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/api/auth/AuthenticationWrapper.dart';
import 'package:frontend/api/firebase_api.dart';
import 'package:frontend/pages/notification_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'dart:io' show Platform; // for Platform check

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Check if the app is running on Android or iOS
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    print("mobile app");
    await FirebaseApi().initNotifications();
  }
  else{
    print("non mobile app");
  }
  runApp(const MainApp());  
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: AuthenticationWrapper()
      ),
      navigatorKey: navigatorKey,
      routes: {
        NotificationScreen.route:(_) => const NotificationScreen()
      },
    );
  }
}
