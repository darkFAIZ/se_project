import 'package:flutter/material.dart';
import 'models/user_session.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSession().loadSession();
  runApp(const TerraKarsaApp());
}

class TerraKarsaApp extends StatelessWidget {
  const TerraKarsaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kebunku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9F5),
      ),
      home: const LoginScreen(),
    );
  }
}
