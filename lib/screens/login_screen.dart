import 'package:flutter/material.dart';
import '../models/user_session.dart';
import 'main_shell_screen.dart';

// LoginScreen acts as the authentication gateway, handling Email, Google, and Apple sign-ins.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  // Controls the switching animation and state between the "Sign In" and "Create Account" tabs
  late TabController _tabController;

  // Controllers to capture user input for the login form
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  // Controllers to capture user input for the registration form
  final TextEditingController _signUpNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the TabController with 2 tabs (Sign In, Create Account)
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Clean up all controllers to prevent memory leaks when this screen is destroyed
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    super.dispose();
  }

  // Helper method to transition the user to the main app interface upon successful authentication
  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainShellScreen()),
    );
  }

  // Helper method to display temporary feedback messages (errors or success) at the bottom of the screen
  void _showSnackBar(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  // --- 1. LOGIN WITH EMAIL ---
  // Validates inputs and attempts to log the user in via the session manager
  void _handleEmailLogin() {
    final email = _loginEmailController.text.trim();
    if (email.isEmpty || _loginPasswordController.text.isEmpty) {
      _showSnackBar('Please enter email and password.');
      return;
    }

    final success = UserSession().login(email);
    if (success) {
      _navigateToHome();
    } else {
      _showSnackBar('Account does not exist! Please create an account first.');
      _tabController.animateTo(1); // Redirects the UI to the "Create Account" tab
    }
  }

  // --- 2. CREATE ACCOUNT WITH EMAIL ---
  // Validates inputs and registers a new user session
  void _handleCreateAccount() {
    final name = _signUpNameController.text.trim();
    final email = _signUpEmailController.text.trim();
    final password = _signUpPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields.');
      return;
    }

    final success = UserSession().registerAccount(
      name: name,
      email: email,
      authType: 'email',
    );

    if (success) {
      _navigateToHome();
    } else {
      _showSnackBar('Account already exists! Please Sign In instead.');
      _tabController.animateTo(0); // Redirects the UI to the "Sign In" tab
    }
  }

  // --- 3. GOOGLE AUTH ---
  // Triggers the Google Sign-In flow
  Future<void> _handleGoogleLogin() async {
    final ok = await UserSession().signInWithGoogle();
    if (!mounted) return;

    if (ok) {
      _navigateToHome();
    } else {
      _showSnackBar('Google sign-in is not configured for this app yet. Add the Android/iOS Google configuration and google-services.json before using Google login.');
    }
  }

  // --- 4. APPLE AUTH ---
  // Triggers the Sign-In with Apple flow
  Future<void> _handleAppleLogin() async {
    final ok = await UserSession().signInWithApple();
    if (!mounted) return;

    if (ok) {
      _navigateToHome();
    } else {
      _showSnackBar('Apple sign-in is unavailable on this device or configuration.');
    }
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
              children: [
                const SizedBox(height: 20),
                
                // App Logo / Icon Header
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(color: Color(0xFF233B2B), shape: BoxShape.circle),
                  child: const Icon(Icons.eco_rounded, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 12),
                
                // App Title & Subtitle
                const Text('Kebunku', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF233B2B))),
                const SizedBox(height: 6),
                const Text(
                  'Secure farm marketplace access',
                  style: TextStyle(fontSize: 13, color: Colors.grey, letterSpacing: 0.3),
                ),
                const SizedBox(height: 20),

                // TAB SWITCHER UI (Sign In / Create Account)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xFF233B2B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black54,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: 'Sign In'),
                      Tab(text: 'Create Account'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // TAB VIEWS (The actual forms mapped to the tabs above)
                SizedBox(
                  height: 250,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // VIEW 1: SIGN IN FORM
                      Column(
                        children: [
                          TextField(
                            controller: _loginEmailController,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _loginPasswordController,
                            obscureText: true, // Hides password characters
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF233B2B),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _handleEmailLogin,
                              child: const Text('Sign In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),

                      // VIEW 2: CREATE ACCOUNT FORM
                      Column(
                        children: [
                          TextField(
                            controller: _signUpNameController,
                            decoration: InputDecoration(
                              labelText: 'Username / Full Name',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _signUpEmailController,
                            decoration: InputDecoration(
                              labelText: 'Gmail / Email Address',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _signUpPasswordController,
                            obscureText: true, // Hides password characters
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF233B2B),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _handleCreateAccount,
                              child: const Text('Create Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                
                // OR DIVIDER
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('OR', style: TextStyle(color: Colors.grey, fontSize: 12))),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // SOCIAL AUTHENTICATION BUTTONS
                Row(
                  children: [
                    // Google Login Button
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                        icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.redAccent),
                        label: const Text('Google', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          await _handleGoogleLogin();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Apple Login Button
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.black,
                        ),
                        icon: const Icon(Icons.apple, size: 22, color: Colors.white),
                        label: const Text('Apple', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          await _handleAppleLogin();
                        },
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