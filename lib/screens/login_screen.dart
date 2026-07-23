import 'package:flutter/material.dart';
import 'main_shell_screen.dart'; // Reroutes to shell holding bottom nav bar

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _navigateToMainShell() {
    // Route to MainShellScreen and remove LoginScreen from back stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShellScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              
              // App Name
              const Text(
                'Kebunku',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),

              // Plant Icon
              const Icon(
                Icons.eco_rounded,
                size: 56,
                color: Color(0xFF1B5E20),
              ),
              const SizedBox(height: 20),

              // Title & Subtitle
              const Text(
                'Create an account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Enter your email to sign up for this app',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // Email Input Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'email@domain.com',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _navigateToMainShell,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // OR Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'or',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),
              const SizedBox(height: 20),

              // Google Sign-In
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    side: BorderSide(color: Colors.grey[200]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _navigateToMainShell,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'G',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Apple Sign-In
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    side: BorderSide(color: Colors.grey[200]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _navigateToMainShell,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.apple, color: Colors.black, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Continue with Apple',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Terms & Privacy
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4),
                  children: const [
                    TextSpan(text: 'By clicking continue, you agree to our '),
                    TextSpan(
                      text: 'Terms of Service\n',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    TextSpan(text: 'and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Footer Logo & Brand
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: const Icon(
                        Icons.eco,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Kebunku Company',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}