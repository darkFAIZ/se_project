import 'package:flutter/material.dart';

class UserAccount {
  final String id;
  final String name;
  final String email;
  final String authType; // 'google', 'apple', 'email'
  final String avatarUrl;

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

  // In-memory mock database for registered users
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
    ),
  };

  UserAccount? _currentUser;
  UserAccount? get currentUser => _currentUser;

  // Check if an account exists
  bool userExists(String email) {
    return _registeredUsers.containsKey(email.toLowerCase());
  }

  // Attempt login for an existing account
  bool login(String email) {
    final key = email.toLowerCase();
    if (_registeredUsers.containsKey(key)) {
      _currentUser = _registeredUsers[key];
      notifyListeners();
      return true;
    }
    return false;
  }

  // Register a new account (Email, Google, or Apple)
  bool registerAccount({
    required String name,
    required String email,
    required String authType,
    String? avatarUrl,
  }) {
    final key = email.toLowerCase();
    if (_registeredUsers.containsKey(key)) {
      return false; // Already registered
    }

    final newAcc = UserAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      authType: authType,
      avatarUrl: avatarUrl ?? 'https://i.pravatar.cc/300?img=${key.length % 70}',
    );

    _registeredUsers[key] = newAcc;
    _currentUser = newAcc;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void addPost(Map<String, dynamic> post) {
    if (_currentUser != null) {
      _currentUser!.userPosts.insert(0, post);
      notifyListeners();
    }
  }
}