import 'package:flutter/material.dart';
import 'main_shell_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Helper untuk navigasi langsung ke MainShellScreen setelah login sukses
  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainShellScreen()),
    );
  }

  // 1. STANDARD EMAIL LOGIN
  void _handleEmailLogin() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email and password.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    _navigateToHome();
  }

  // 2. GOOGLE ACCOUNT SELECTOR MODAL
  void _handleGoogleLogin() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.g_mobiledata, size: 36, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Choose an account',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'to continue to Kebunku App',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 20),
                const Divider(height: 1),

                // Mock Google Account 1
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE2EAD6),
                    child: Text('F', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  title: const Text('Faiz', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  subtitle: const Text('faiz.user@gmail.com', style: TextStyle(fontSize: 13)),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToHome();
                  },
                ),
                const Divider(height: 1),

                // Mock Google Account 2
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFE5D9),
                    child: Text('A', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  title: const Text('Aqiel Studio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  subtitle: const Text('aqiel.dev@gmail.com', style: TextStyle(fontSize: 13)),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToHome();
                  },
                ),
                const Divider(height: 1),

                // Add Another Account Option
                ListTile(
                  leading: const Icon(Icons.person_add_alt_1_outlined, color: Colors.black87),
                  title: const Text('Add another account', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToHome();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 3. APPLE SIGN-IN MODAL
  void _handleAppleLogin() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.apple, size: 52, color: Colors.black),
                const SizedBox(height: 12),
                const Text(
                  'Sign in with Apple ID',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Do you want to sign in to Kebunku using your Apple ID "faiz.user@icloud.com"?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 24),

                // Passcode/FaceID Button Simulation
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.fingerprint, color: Colors.white),
                    label: const Text(
                      'Continue with Passcode / Face ID',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _navigateToHome();
                    },
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo / Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF233B2B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.eco_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kebunku',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF233B2B),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Connect directly with local farmers',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),

                const SizedBox(height: 36),

                // Email Input
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email / Gmail Address',
                    hintText: 'name@gmail.com',
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Password Input
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF233B2B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _handleEmailLogin,
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Divider Or
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('OR', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),

                // Social Logins
                Row(
                  children: [
                    // Google Button
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.redAccent),
                        label: const Text(
                          'Google',
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                        ),
                        onPressed: _handleGoogleLogin,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Apple Button
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.apple, size: 22, color: Colors.white),
                        label: const Text(
                          'Apple',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: _handleAppleLogin,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}