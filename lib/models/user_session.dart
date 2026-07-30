import 'package:flutter/material.dart';

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
  UserSession._internal();

  final Map<String, UserAccount> _registeredUsers = {
    'faiz.user@gmail.com': UserAccount(
      id: 'usr_1',
      name: 'Faiz',
      email: 'faiz.user@gmail.com',
      authType: 'google',
      avatarUrl: 'https://i.pravatar.cc/300?img=12',
      userPosts: [
        {'id': 'p1', 'title': 'Fresh Organic Tomatoes', 'price': 15000, 'category': 'Vegetables', 'farmer': 'Pak Tani', 'origin': 'BOGOR', 'stock': '50.0 kg'}
      ],
      savedItems: [],
      cartItems: [],
    ),
  };

  UserAccount? _currentUser;
  UserAccount? get currentUser => _currentUser;

  bool userExists(String email) => _registeredUsers.containsKey(email.toLowerCase());

  bool login(String email) {
    final key = email.toLowerCase();
    if (_registeredUsers.containsKey(key)) {
      _currentUser = _registeredUsers[key];
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
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // --- POST MANAGEMENT ---
  void addPost(Map<String, dynamic> post) {
    if (_currentUser != null) {
      _currentUser!.userPosts.insert(0, post);
      notifyListeners();
    }
  }

  void deletePost(int index) {
    if (_currentUser != null && index < _currentUser!.userPosts.length) {
      _currentUser!.userPosts.removeAt(index);
      notifyListeners();
    }
  }

  // --- SAVED ITEMS MANAGEMENT ---
  bool isSaved(Map<String, dynamic> product) {
    if (_currentUser == null) return false;
    return _currentUser!.savedItems.any((item) => item['title'] == product['title']);
  }

  void toggleSaveProduct(Map<String, dynamic> product) {
    if (_currentUser == null) return;
    if (isSaved(product)) {
      _currentUser!.savedItems.removeWhere((item) => item['title'] == product['title']);
    } else {
      _currentUser!.savedItems.add(product);
    }
    notifyListeners();
  }

  void deleteSavedItem(int index) {
    if (_currentUser != null && index < _currentUser!.savedItems.length) {
      _currentUser!.savedItems.removeAt(index);
      notifyListeners();
    }
  }

  // --- CART MANAGEMENT ---
  void addToCart(Map<String, dynamic> product) {
    if (_currentUser == null) return;
    final existingIndex = _currentUser!.cartItems.indexWhere((item) => item.product['title'] == product['title']);
    
    if (existingIndex >= 0) {
      _currentUser!.cartItems[existingIndex].quantity += 1;
    } else {
      _currentUser!.cartItems.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void updateCartQuantity(int index, int delta) {
    if (_currentUser != null && index < _currentUser!.cartItems.length) {
      _currentUser!.cartItems[index].quantity += delta;
      if (_currentUser!.cartItems[index].quantity <= 0) {
        _currentUser!.cartItems.removeAt(index);
      }
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
}