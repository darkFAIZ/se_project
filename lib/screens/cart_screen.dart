import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample cart data mirroring your UI screenshot
  final List<Map<String, dynamic>> _cartItems = [
    {
      'store': 'Fresh-Fruit',
      'title': 'Seedless Ruby-Core Watermelon....',
      'variant': 'Seedless',
      'price': 20000,
      'quantity': 1,
      'isSelected': true,
      'image': 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400',
    },
    {
      'store': 'Sayurku',
      'title': 'Broccoli - 100% Organic Non - G...',
      'variant': 'Family Bundle',
      'price': 8000,
      'quantity': 2,
      'isSelected': true,
      'image': 'https://images.unsplash.com/photo-1584270354949-c26b0d5b4a0c?w=400',
    },
    {
      'store': 'Sayurku',
      'title': 'Hand-Harvested Grapes | Ripen...',
      'variant': '0.5 kg, Seedless',
      'price': 17000,
      'quantity': 1,
      'isSelected': false,
      'image': 'https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=400',
    },
    {
      'store': 'Sayurku',
      'title': 'Cavendish Bananas | High-Den...',
      'variant': '2 kg',
      'price': 15000,
      'quantity': 1,
      'isSelected': false,
      'image': 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400',
    },
  ];

  bool get _isAllSelected => _cartItems.every((item) => item['isSelected']);

  void _toggleSelectAll(bool? val) {
    setState(() {
      for (var item in _cartItems) {
        item['isSelected'] = val ?? false;
      }
    });
  }

  int get _totalPrice {
    int total = 0;
    for (var item in _cartItems) {
      if (item['isSelected']) {
        total += (item['price'] as int) * (item['quantity'] as int);
      }
    }
    return total;
  }

  int get _selectedCount {
    return _cartItems.where((item) => item['isSelected']).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7EC), // Soft green background matching screenshot
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F7EC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    children: [
                      // Store Header Row
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: item['isSelected'],
                              activeColor: const Color(0xFF1B4D2E),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: (val) {
                                setState(() {
                                  item['isSelected'] = val ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${item['store']} >',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Edit', style: TextStyle(color: Colors.black, fontSize: 13)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Product Details Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 32), // Align under checkbox
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item['image'],
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),

                                // Variant Dropdown Chip
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.04),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item['variant'],
                                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                                      ),
                                      const Icon(Icons.keyboard_arrow_down, size: 16),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Price and Quantity Stepper
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rp ${item['price']}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.04),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (item['quantity'] > 1) {
                                                setState(() => item['quantity']--);
                                              }
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              child: Text('-', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 6),
                                            child: Text('${item['quantity']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() => item['quantity']++);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              child: Text('+', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Checkout Bar Section
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF3F7EC),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _isAllSelected,
                          activeColor: const Color(0xFF1B4D2E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: _toggleSelectAll,
                        ),
                        const Text('All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    Text(
                      'Rp $_totalPrice',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF233B2B), // Dark forest green matching screenshot
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Check Out ($_selectedCount)',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
              bottomNavigationBar: BottomNavigationBar(
              currentIndex: 2, // Cart is active
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (index) {
                if (index == 0) {
                  Navigator.pop(context); // Go back to Home
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled, size: 26),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined, size: 26),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined, size: 26),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
    );
  }
}