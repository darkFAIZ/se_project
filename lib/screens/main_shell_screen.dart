import 'package:flutter/material.dart';
import '../models/user_session.dart';
import 'home_screen.dart';
import 'discover_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

// MainShellScreen acts as the primary layout wrapper, holding the BottomNavigationBar.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;

  // The 4 main screens connected to your navigation tabs
  final List<Widget> _pages = const [
    HomeScreen(),
    DiscoverScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack is used so screens aren't rebuilt when switching tabs (maintains state/scroll position)
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E3A2B), // Dark green theme
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          
          // --- CART TAB WITH LIVE COUNTER BADGE ---
          // ListenableBuilder redraws the badge automatically when the global cart item count changes
          BottomNavigationBarItem(
            icon: ListenableBuilder(
              listenable: UserSession(),
              builder: (context, child) {
                final count = UserSession().currentUser?.cartItems.length ?? 0;
                return Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count'),
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.shopping_cart_outlined),
                );
              },
            ),
            activeIcon: ListenableBuilder(
              listenable: UserSession(),
              builder: (context, child) {
                final count = UserSession().currentUser?.cartItems.length ?? 0;
                return Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count'),
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),
            label: 'Cart',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}