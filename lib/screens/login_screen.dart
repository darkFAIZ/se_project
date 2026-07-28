import 'package:flutter/material.dart';
import '../models/user_session.dart';
import 'main_shell_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controller Sign In
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  // Controller Sign Up / Create Account
  final TextEditingController _signUpNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainShellScreen()),
    );
  }

  // 1. LOGIN DENGAN EMAIL/PASSWORD
  void _handleEmailLogin() {
    final email = _loginEmailController.text.trim();
    if (email.isEmpty || _loginPasswordController.text.isEmpty) {
      _showSnackBar('Please enter your email and password.');
      return;
    }

    UserSession().login(
      UserAccount(
        id: 'usr_custom',
        name: email.split('@').first,
        email: email,
        authType: 'email',
        avatarUrl: 'https://i.pravatar.cc/300?img=8',
      ),
    );
    _navigateToHome();
  }

  // 2. CREATE ACCOUNT BARU
  void _handleCreateAccount() {
    final name = _signUpNameController.text.trim();
    final email = _signUpEmailController.text.trim();
    final password = _signUpPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields.');
      return;
    }

    final success = UserSession().registerWithEmail(
      name: name,
      email: email,
      password: password,
    );

    if (success) {
      _navigateToHome();
    } else {
      _showSnackBar('Email already exists. Please sign in instead.');
    }
  }

  // 3. GOOGLE ACCOUNT SELECTOR (LOGIN / CREATE AUTOMATICALLY)
  void _handleGoogleLogin() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    Text('Choose or Create Google Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Data will be synced and saved automatically', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 16),
                const Divider(height: 1),

                // Akun Terdaftar 1
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF233B2B),
                    child: Text('F', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  title: const Text('Faiz', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('faiz.user@gmail.com', style: TextStyle(fontSize: 12)),
                  onTap: () {
                    UserSession().login(
                      UserAccount(
                        id: 'goog_1',
                        name: 'Faiz',
                        email: 'faiz.user@gmail.com',
                        authType: 'google',
                        avatarUrl: 'https://i.pravatar.cc/300?img=12',
                      ),
                    );
                    Navigator.pop(context);
                    _navigateToHome();
                  },
                ),
                const Divider(height: 1),

                // Akun Baru 2 (Otomatis dibuat jika belum ada)
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  title: const Text('Aqiel Studio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('aqiel.dev@gmail.com (Create new)', style: TextStyle(fontSize: 12)),
                  onTap: () {
                    UserSession().login(
                      UserAccount(
                        id: 'goog_2',
                        name: 'Aqiel Studio',
                        email: 'aqiel.dev@gmail.com',
                        authType: 'google',
                        avatarUrl: 'https://i.pravatar.cc/300?img=33',
                      ),
                    );
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

  // 4. APPLE SIGN-IN
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
                const Icon(Icons.apple, size: 48, color: Colors.black),
                const SizedBox(height: 12),
                const Text('Sign in with Apple ID', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('Sync posts, saved items, and cart to faiz.apple@icloud.com', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.fingerprint, color: Colors.white),
                    label: const Text('Continue with Face ID / Passcode', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      UserSession().login(
                        UserAccount(
                          id: 'apple_1',
                          name: 'Faiz (Apple)',
                          email: 'faiz.apple@icloud.com',
                          authType: 'apple',
                          avatarUrl: 'https://i.pravatar.cc/300?img=60',
                        ),
                      );
                      Navigator.pop(context);
                      _navigateToHome();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
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
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(color: Color(0xFF233B2B), shape: BoxShape.circle),
                  child: const Icon(Icons.eco_rounded, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text('Kebunku', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF233B2B))),
                const SizedBox(height: 20),

                // TAB SWITCHER (Sign In / Create Account)
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

                // TAB CONTENTS
                SizedBox(
                  height: 260,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Form Sign In
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
                            obscureText: !_isPasswordVisible,
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

                      // Form Create Account
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
                            obscureText: !_isPasswordVisible,
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
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('OR', style: TextStyle(color: Colors.grey, fontSize: 12))),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // Opsi Google & Apple Login
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                        icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.redAccent),
                        label: const Text('Google', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                        onPressed: _handleGoogleLogin,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.black,
                        ),
                        icon: const Icon(Icons.apple, size: 22, color: Colors.white),
                        label: const Text('Apple', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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