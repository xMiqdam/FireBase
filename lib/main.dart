import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynoteapps/api/firebase_api.dart';
import 'package:mynoteapps/firebase_options.dart';
import 'package:mynoteapps/pages/home_page.dart';
import 'package:mynoteapps/pages/notification_page.dart';
import 'package:mynoteapps/screen/login_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
      navigatorKey: navigatorKey,
      routes: {
        'notification_screen': (context) => const NotificationPage(),
      },
    );
  }
}