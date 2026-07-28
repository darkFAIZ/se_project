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

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  final TextEditingController _signUpNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController = TextEditingController();

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

  void _showSnackBar(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  // 1. LOGIN WITH EMAIL
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
      _tabController.animateTo(1); // Redirect to Create Account tab
    }
  }

  // 2. CREATE ACCOUNT WITH EMAIL
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
      _tabController.animateTo(0);
    }
  }

  // 3. GOOGLE AUTH (STRICT CHECK)
  void _handleGoogleLogin() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.g_mobiledata, size: 36, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Select Google Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),

                // Registered Account 1
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF233B2B),
                    child: Text('F', style: TextStyle(color: Colors.white)),
                  ),
                  title: const Text('Faiz', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('faiz.user@gmail.com (Registered)'),
                  onTap: () {
                    Navigator.pop(context);
                    UserSession().login('faiz.user@gmail.com');
                    _navigateToHome();
                  },
                ),
                const Divider(height: 1),

                // Unregistered Account 2
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Text('A', style: TextStyle(color: Colors.white)),
                  ),
                  title: const Text('New Device User'),
                  subtitle: const Text('new.user@gmail.com (Not Registered)'),
                  onTap: () {
                    Navigator.pop(context);
                    if (!UserSession().userExists('new.user@gmail.com')) {
                      _showAccountNotFoundDialog('new.user@gmail.com', 'New Device User', 'google');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 4. APPLE AUTH (STRICT CHECK)
  void _handleAppleLogin() {
    const appleEmail = 'faiz.apple@icloud.com';
    if (UserSession().userExists(appleEmail)) {
      UserSession().login(appleEmail);
      _navigateToHome();
    } else {
      _showAccountNotFoundDialog(appleEmail, 'Faiz (Apple)', 'apple');
    }
  }

  // DIALOG FOR UNREGISTERED GOOGLE/APPLE ACCOUNTS
  void _showAccountNotFoundDialog(String email, String name, String authType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Not Found'),
        content: Text('No account associated with "$email". Would you like to create one now?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF233B2B)),
            onPressed: () {
              Navigator.pop(context);
              UserSession().registerAccount(
                name: name,
                email: email,
                authType: authType,
              );
              _navigateToHome();
            },
            child: const Text('Create Account', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
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

                // TAB SWITCHER
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

                SizedBox(
                  height: 250,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // SIGN IN FORM
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
                            obscureText: true,
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

                      // CREATE ACCOUNT FORM
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
                            obscureText: true,
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