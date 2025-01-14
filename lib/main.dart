import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mynoteapps/api/firebase_api.dart';
import 'package:mynoteapps/firebase_options.dart';
import 'package:mynoteapps/pages/home_page.dart';
import 'package:mynoteapps/pages/login_page.dart';
import 'package:mynoteapps/pages/notification_page.dart';
import 'package:mynoteapps/routes/mynote_routes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'myapp',
      initialRoute: MyappRoute.login,
      getPages: AppPages.pages,
    );
  }
}