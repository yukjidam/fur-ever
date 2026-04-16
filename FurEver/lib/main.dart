import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const FurEverApp());
}

class FurEverApp extends StatelessWidget {
  const FurEverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FurEver',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SplashScreen(),
    );
  }
}
