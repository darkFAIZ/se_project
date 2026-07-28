import 'package:flutter/material.dart';

class UserAccount {
  final String id;
  final String name;
  final String email;
  final String authType; // 'google', 'apple', 'email'
  final String avatarUrl;

  // Data tersimpan khusus per akun
  List<Map<String, dynamic>> userPosts;
  List<Map<String, dynamic>> savedItems;
  List<Map<String, dynamic>> cartItems;

  UserAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.authType,
    required this.avatarUrl,
    List<Map<String, dynamic>>? userPosts,
    List<Map<String, dynamic>>? savedItems,
    List<Map<String, dynamic>>? cartItems,
  })  : userPosts = userPosts ?? [],
        savedItems = savedItems ?? [],
        cartItems = cartItems ?? [];
}

class UserSession extends ChangeNotifier {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  // Database sementara di memori aplikasi
  final Map<String, UserAccount> _registeredUsers = {
    'faiz.user@gmail.com': UserAccount(
      id: 'usr_1',
      name: 'Faiz',
      email: 'faiz.user@gmail.com',
      authType: 'google',
      avatarUrl: 'https://i.pravatar.cc/300?img=12',
      userPosts: [
        {'title': 'Fresh Organic Tomatoes', 'price': '15000', 'description': 'Harvested today'}
      ],
      savedItems: [],
      cartItems: [],
    ),
  };

  UserAccount? _currentUser;

  UserAccount? get currentUser => _currentUser;

  // Login / Switch Account
  void login(UserAccount account) {
    if (!_registeredUsers.containsKey(account.email)) {
      _registeredUsers[account.email] = account;
    }
    _currentUser = _registeredUsers[account.email];
    notifyListeners();
  }

  // Register Baru (Email / Username / Password)
  bool registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) {
    if (_registeredUsers.containsKey(email)) {
      return false; // Email sudah terdaftar
    }

    final newAcc = UserAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      authType: 'email',
      avatarUrl: 'https://i.pravatar.cc/300?img=${name.length + 5}',
    );

    _registeredUsers[email] = newAcc;
    _currentUser = newAcc;
    notifyListeners();
    return true;
  }

  // Logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Tambah Post ke Akun Aktif
  void addPost(Map<String, dynamic> post) {
    if (_currentUser != null) {
      _currentUser!.userPosts.insert(0, post);
      notifyListeners();
    }
  }
}