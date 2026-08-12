import 'package:flutter/material.dart';
import 'models/user_session.dart';
import 'screens/login_screen.dart';

// Execution entry point of the Flutter application
Future<void> main() async {
  // Ensures Flutter framework is fully bound before executing async setup tasks
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-loads the user session singleton ensuring disk data is in memory before rendering UI
  await UserSession().loadSession();
  
  // Bootstraps the application tree
  runApp(const TerraKarsaApp());
}

// Root application widget establishing theme and routing
class TerraKarsaApp extends StatelessWidget {
  const TerraKarsaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kebunku',
      debugShowCheckedModeBanner: false, // Removes debug ribbon
      theme: ThemeData(
        primarySwatch: Colors.green, // Defines global accent color
        useMaterial3: true,          // Enforces modern Material 3 styling
        scaffoldBackgroundColor: const Color(0xFFF8F9F5), // Global off-white background
      ),
      home: const LoginScreen(), // Designates the authentication screen as the initial view
    );
  }
}