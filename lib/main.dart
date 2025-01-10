import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dataku',
      theme: ThemeData(
        primarySwatch: Colors.amber,  // Mengatur warna utama menjadi hitam
        scaffoldBackgroundColor: Colors.black, // Background scaffold hitam
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,  // Warna background app bar hitam
          titleTextStyle: TextStyle(color: Colors.white),  // Warna teks app bar putih
        ),
      ),
    );
  }
}
