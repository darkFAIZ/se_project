import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class CartItem {
  final Map<String, dynamic> product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class UserAccount {
  final String id;
  final String name;
  final String email;
  final String authType;
  final String avatarUrl;

  List<Map<String, dynamic>> userPosts;
  List<Map<String, dynamic>> savedItems;
  List<CartItem> cartItems;

  UserAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.authType,
    required this.avatarUrl,
    List<Map<String, dynamic>>? userPosts,
    List<Map<String, dynamic>>? savedItems,
    List<CartItem>? cartItems,
  })  : userPosts = userPosts ?? [],
        savedItems = savedItems ?? [],
        cartItems = cartItems ?? [];
}

class UserSession extends ChangeNotifier {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;

  UserSession._internal() {
    Future.microtask(loadSession);
  }

  final List<Map<String, dynamic>> _orders = [];
  final Map<String, UserAccount> _registeredUsers = {};

  UserAccount? _currentUser;

  List<Map<String, dynamic>> get orders => List.unmodifiable(_orders);
  UserAccount? get currentUser => _currentUser;

  Map<String, dynamic> _normalizeProductForStorage(Map<String, dynamic> product) {
    final normalized = <String, dynamic>{};
    for (final entry in product.entries) {
      if (entry.key == 'imageFile') continue;
      normalized[entry.key] = entry.value;
    }

    normalized['title'] = (product['title'] ?? product['name'] ?? 'Product').toString();
    normalized['name'] = (product['name'] ?? product['title'] ?? normalized['title']).toString();
    normalized['imageUrl'] = (product['imageUrl'] ?? product['image'] ?? '').toString();
    normalized['category'] = (product['category'] ?? product['subCategory'] ?? 'General').toString();
    normalized['origin'] = (product['origin'] ?? 'BOGOR').toString();
    normalized['price'] = product['price'] ?? 0;
    normalized['farmer'] = (product['farmer'] ?? 'Pak Tani').toString();
    normalized['stock'] = (product['stock'] ?? 'Available').toString();
    normalized['description'] = (product['description'] ?? 'Fresh product').toString();

    if (normalized['imageUrl'].toString().trim().isEmpty) {
      normalized['imageUrl'] = 'https://images.unsplash.com/photo-1540420773420-3366772f4999?q=80&w=600';
    }

    return normalized;
  }

  Map<String, dynamic> _accountToMap(UserAccount account) {
    return {
      'id': account.id,
      'name': account.name,
      'email': account.email,
      'authType': account.authType,
      'avatarUrl': account.avatarUrl,
      'userPosts': account.userPosts.map(_normalizeProductForStorage).toList(),
      'savedItems': account.savedItems.map(_normalizeProductForStorage).toList(),
      'cartItems': account.cartItems
          .map((item) => {
                'quantity': item.quantity,
                'product': _normalizeProductForStorage(item.product),
              })
          .toList(),
    };
  }

  UserAccount _accountFromMap(Map<String, dynamic> accountMap) {
    final userPosts = (accountMap['userPosts'] as List? ?? [])
        .map((post) => Map<String, dynamic>.from(post as Map))
        .toList();

    final savedItems = (accountMap['savedItems'] as List? ?? [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    final cartItems = (accountMap['cartItems'] as List? ?? [])
        .map((item) {
          final productMap = Map<String, dynamic>.from((item as Map)['product'] as Map); 
          return CartItem(
            product: productMap,
            quantity: int.tryParse((item['quantity'] ?? 1).toString()) ?? 1,
          );
        })
        .toList();

    return UserAccount(
      id: (accountMap['id'] ?? DateTime.now().millisecondsSinceEpoch.toString()).toString(),
      name: (accountMap['name'] ?? 'User').toString(),
      email: (accountMap['email'] ?? '').toString(),
      authType: (accountMap['authType'] ?? 'email').toString(),
      avatarUrl: (accountMap['avatarUrl'] ?? 'https://i.pravatar.cc/300').toString(),
      userPosts: userPosts,
      savedItems: savedItems,
      cartItems: cartItems,
    );
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsers = prefs.getString('registered_users');
    final currentUserEmail = prefs.getString('current_user_email');

    if (storedUsers != null && storedUsers.isNotEmpty) {
      final decoded = jsonDecode(storedUsers) as Map<String, dynamic>;
      for (final entry in decoded.entries) {
        final key = entry.key.toLowerCase();
        if (entry.value is Map) {
          _registeredUsers[key] = _accountFromMap(Map<String, dynamic>.from(entry.value as Map));
        }
      }
    }

    if (_registeredUsers.isEmpty) {
      _registeredUsers['faiz.user@gmail.com'] = UserAccount(
        id: 'usr_1',
        name: 'Faiz',
        email: 'faiz.user@gmail.com',
        authType: 'google',
        avatarUrl: 'https://i.pravatar.cc/300?img=12',
        userPosts: [
          {
            'id': 'p1',
            'title': 'Fresh Organic Tomatoes',
            'price': 15000,
            'category': 'Vegetables',
            'farmer': 'Pak Tani',
            'origin': 'BOGOR',
            'stock': '50.0 kg',
            'imageUrl': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?q=80&w=600',
            'description': 'Fresh harvest directly from farm.',
          },
        ],
      );
    }

    if (currentUserEmail != null && _registeredUsers.containsKey(currentUserEmail.toLowerCase())) {
      _currentUser = _registeredUsers[currentUserEmail.toLowerCase()];
    }

    notifyListeners();
  }

  Future<void> saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final usersMap = {
      for (final entry in _registeredUsers.entries) entry.key: _accountToMap(entry.value),
    };

    await prefs.setString('registered_users', jsonEncode(usersMap));
    if (_currentUser != null) {
      await prefs.setString('current_user_email', _currentUser!.email.toLowerCase());
    } else {
      await prefs.remove('current_user_email');
    }
  }

  bool userExists(String email) => _registeredUsers.containsKey(email.toLowerCase());

  bool login(String email) {
    final key = email.toLowerCase();
    if (_registeredUsers.containsKey(key)) {
      _currentUser = _registeredUsers[key];
      unawaited(saveSession());
      notifyListeners();
      return true;
    }
    return false;
  }

  bool registerAccount({required String name, required String email, required String authType, String? avatarUrl}) {
    final key = email.toLowerCase();
    if (_registeredUsers.containsKey(key)) return false;

    final newAcc = UserAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      authType: authType,
      avatarUrl: avatarUrl ?? 'https://i.pravatar.cc/300?img=${key.length % 70}',
    );
    _registeredUsers[key] = newAcc;
    _currentUser = newAcc;
    unawaited(saveSession());
    notifyListeners();
    return true;
  }

  Future<bool> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final account = await googleSignIn.signIn();
      if (account == null) return false;

      final key = account.email.toLowerCase();
      final existingUser = _registeredUsers[key];
      final signedInUser = existingUser ?? UserAccount(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: account.displayName ?? account.email.split('@').first,
        email: account.email,
        authType: 'google',
        avatarUrl: account.photoUrl ?? 'https://i.pravatar.cc/300?img=${key.length % 70}',
      );

      _registeredUsers[key] = signedInUser;
      _currentUser = signedInUser;
      await saveSession();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final email = credential.email ?? '${DateTime.now().millisecondsSinceEpoch}@privaterelay.appleid.com';
      final name = [credential.givenName, credential.familyName].whereType<String>().join(' ').trim();
      final key = email.toLowerCase();
      final existingUser = _registeredUsers[key];
      final signedInUser = existingUser ?? UserAccount(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.isNotEmpty ? name : email.split('@').first,
        email: email,
        authType: 'apple',
        avatarUrl: 'https://i.pravatar.cc/300?img=${key.length % 70}',
      );

      _registeredUsers[key] = signedInUser;
      _currentUser = signedInUser;
      await saveSession();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    unawaited(saveSession());
    notifyListeners();
  }

  void addPost(Map<String, dynamic> post) {
    if (_currentUser != null) {
      _currentUser!.userPosts.insert(0, _normalizeProductForStorage(post));
      unawaited(saveSession());
      notifyListeners();
    }
  }

  void deletePost(int index) {
    if (_currentUser != null && index < _currentUser!.userPosts.length) {
      _currentUser!.userPosts.removeAt(index);
      unawaited(saveSession());
      notifyListeners();
    }
  }

  bool isSaved(Map<String, dynamic> product) {
    if (_currentUser == null) return false;

    final productTitle = (product['title'] ?? product['name'] ?? '').toString().trim();
    if (productTitle.isEmpty) return false;

    return _currentUser!.savedItems.any((item) {
      final savedTitle = (item['title'] ?? item['name'] ?? '').toString().trim();
      return savedTitle == productTitle;
    });
  }

  void toggleSaveProduct(Map<String, dynamic> product) {
    if (_currentUser == null) return;

    final normalizedProduct = _normalizeProductForStorage(product);
    final productTitle = (normalizedProduct['title'] ?? normalizedProduct['name'] ?? '').toString();

    if (isSaved(normalizedProduct)) {
      _currentUser!.savedItems.removeWhere((item) {
        final savedTitle = (item['title'] ?? item['name'] ?? '').toString();
        return savedTitle == productTitle;
      });
    } else {
      _currentUser!.savedItems.add(normalizedProduct);
    }
    unawaited(saveSession());
    notifyListeners();
  }

  void deleteSavedItem(int index) {
    if (_currentUser != null && index < _currentUser!.savedItems.length) {
      _currentUser!.savedItems.removeAt(index);
      unawaited(saveSession());
      notifyListeners();
    }
  }

  void clearCart() {
    if (_currentUser != null) {
      _currentUser!.cartItems.clear();
      unawaited(saveSession());
      notifyListeners();
    }
  }

  void addToCart(Map<String, dynamic> product) {
    if (_currentUser == null) return;
    final existingIndex = _currentUser!.cartItems.indexWhere((item) => item.product['title'] == product['title']);

    if (existingIndex >= 0) {
      _currentUser!.cartItems[existingIndex].quantity += 1;
    } else {
      _currentUser!.cartItems.add(CartItem(product: product, quantity: 1));
    }
    unawaited(saveSession());
    notifyListeners();
  }

  void updateCartQuantity(int index, int delta) {
    if (_currentUser != null && index < _currentUser!.cartItems.length) {
      _currentUser!.cartItems[index].quantity += delta;
      if (_currentUser!.cartItems[index].quantity <= 0) {
        _currentUser!.cartItems.removeAt(index);
      }
      unawaited(saveSession());
      notifyListeners();
    }
  }

  double get cartTotalPrice {
    if (_currentUser == null) return 0;
    return _currentUser!.cartItems.fold(0, (sum, item) {
      final double price = (item.product['price'] is num)
          ? (item.product['price'] as num).toDouble()
          : double.tryParse(item.product['price'].toString()) ?? 0;
      return sum + (price * item.quantity);
    });
  }

  void placeOrder(Map<String, dynamic> order) {
    _orders.insert(0, order);
    if (_currentUser != null) {
      _currentUser!.cartItems.clear();
    }
    unawaited(saveSession());
    notifyListeners();
  }
}
