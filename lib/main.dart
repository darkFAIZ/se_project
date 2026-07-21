import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const TerraKarsaApp());
}

class TerraKarsaApp extends StatelessWidget {
  const TerraKarsaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Farm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const LoginScreen(), // FIXED: Starts on the Sign-Up screen
    );
  }
}