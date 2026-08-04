import 'dart:io';

import 'package:flutter/material.dart';
import '../models/user_session.dart';
import 'checkout_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    UserSession().addListener(_onSessionChanged);
  }

  @override
  void dispose() {
    UserSession().removeListener(_onSessionChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSessionChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // Full category list with icons
  final List<Map<String, dynamic>> _categories = const [
    {'name': 'All', 'icon': Icons.grid_view_rounded},
    {'name': 'Vegetables', 'icon': Icons.eco_rounded},
    {'name': 'Fruits', 'icon': Icons.apple_rounded},
    {'name': 'Grains', 'icon': Icons.grass_rounded},
    {'name': 'Organic', 'icon': Icons.spa_rounded},
    {'name': 'Herbs', 'icon': Icons.local_florist_rounded},
  ];

  // Comprehensive Marketplace Product Catalog
  final List<Map<String, dynamic>> _allProducts = const [
    {
      'title': 'Broccoli',
      'price': 20,
      'category': 'Vegetables',
      'subCategory': 'Fresh-Veggie',
      'farmer': 'Pak Tani',
      'origin': 'BOGOR',
      'stock': '50.0 kg',
      'imageUrl': 'https://images.unsplash.com/photo-1584270354949-c26b0d5b4a0c?q=80&w=600',
      'description': 'Freshly harvested organic broccoli packed with nutrients directly from Bogor highland farms.'
    },
    {
      'title': 'Fresh Carrots',
      'price': 12,
      'category': 'Vegetables',
      'subCategory': 'Organic',
      'farmer': 'Bu Sri',
      'origin': 'BANDUNG',
      'stock': '30.0 kg',
      'imageUrl': 'https://images.unsplash.com/photo-1598170845058-12ef4a457939?q=80&w=600',
      'description': 'Sweet and crisp organic carrots, perfect for juicing, soups, or fresh salads.'
    },
    {
      'title': 'Red Fuji Apples',
      'price': 25,
      'category': 'Fruits',
      'subCategory': 'Sweet Harvest',
      'farmer': 'Pak Budi',
      'origin': 'MALANG',
      'stock': '45.0 kg',
      'imageUrl': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?q=80&w=600',
      'description': 'Juicy and naturally sweet Fuji apples grown in Malang orchards without chemical pesticides.'
    },
    {
      'title': 'Organic White Rice',
      'price': 18,
      'category': 'Grains',
      'subCategory': 'Premium Quality',
      'farmer': 'Toko Rahmat',
      'origin': 'SUBANG',
      'stock': '100.0 kg',
      'imageUrl': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?q=80&w=600',
      'description': 'Pollen-free premium quality white rice sourced directly from Subang rice fields.'
    },
    {
      'title': 'Organic Spinach',
      'price': 8,
      'category': 'Vegetables',
      'subCategory': 'Leafy Green',
      'farmer': 'Pak Ahmad',
      'origin': 'CIANJUR',
      'stock': '25.0 kg',
      'imageUrl': 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?q=80&w=600',
      'description': 'Nutrient-rich green spinach picked fresh daily in Cianjur.'
    },
    {
      'title': 'Fresh Strawberries',
      'price': 35,
      'category': 'Fruits',
      'subCategory': 'Berry Special',
      'farmer': 'Bu Ratna',
      'origin': 'LEMBANG',
      'stock': '15.0 kg',
      'imageUrl': 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?q=80&w=600',
      'description': 'Hand-picked ripe red strawberries grown in cool Lembang climate.'
    },
    {
      'title': 'Fresh Mint Leaves',
      'price': 6,
      'category': 'Herbs',
      'subCategory': 'Aromatic',
      'farmer': 'Pak Joko',
      'origin': 'Lembang',
      'stock': '10.0 kg',
      'imageUrl': 'https://images.unsplash.com/photo-1628556270448-4d4e4148e1b1?q=80&w=600',
      'description': 'Fragrant green mint leaves ideal for tea, culinary garnishing, and beverage infusions.'
    },
    {
      'title': 'Red Cherry Tomatoes',
      'price': 15,
      'category': 'Organic',
      'subCategory': 'Hydroponic',
      'farmer': 'Kebun Kita',
      'origin': 'DEPOK',
      'stock': '20.0 kg',
      'imageUrl': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?q=80&w=600',
      'description': 'Plump hydroponic cherry tomatoes packed with antioxidants.'
    }
  ];

  void _navigateToDetail(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = UserSession().currentUser;
    final latestOrder = UserSession().orders.isNotEmpty ? UserSession().orders.first : null;
    final userPosts = currentUser?.userPosts ?? [];
    final availableProducts = <Map<String, dynamic>>[..._allProducts, ...userPosts];

    final filteredProducts = availableProducts.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          (product['category'] ?? '').toString().toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = (product['title'] ?? product['name'] ?? '')
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. TOP APP BAR & USER GREETING SECTION
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${currentUser?.name ?? 'Farm Friend'} 👋',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Find fresh harvest near you',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF233B2B),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No new notifications right now.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. SEARCH BAR & FILTER BUTTON
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search vegetables, fruits, grains...',
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF233B2B)),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF233B2B),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune_rounded, color: Colors.white),
                        onPressed: () {
                          // Quick Filter Dialog
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Filter Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 16),
                                    ListTile(
                                      leading: const Icon(Icons.arrow_upward, color: Color(0xFF233B2B)),
                                      title: const Text('Price: Low to High'),
                                      onTap: () {
                                        setState(() {
                                          _allProducts.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.arrow_downward, color: Color(0xFF233B2B)),
                                      title: const Text('Price: High to Low'),
                                      onTap: () {
                                        setState(() {
                                          _allProducts.sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. PROMOTIONAL BANNER CARD
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF233B2B), Color(0xFF385E44)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF233B2B).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'DIRECT FROM FARMERS',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Get 20% Off Fresh\nHarvest Items',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD3E4C5),
                                foregroundColor: const Color(0xFF233B2B),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                elevation: 0,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedCategory = 'Organic';
                                });
                              },
                              child: const Text('Explore Promo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.agriculture_rounded,
                        size: 80,
                        color: Color(0xFFD3E4C5),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 4. ORDER TRACKING SHORTCUT
            if (latestOrder != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderTrackingScreen(order: latestOrder),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF233B2B),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF233B2B).withOpacity(0.22),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Track your order',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  latestOrder['status'] as String? ?? 'Packed',
                                  style: const TextStyle(
                                    color: Color(0xFFDDEAD9),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // 5. CATEGORIES HORIZONTAL SELECTOR
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 10),
                    child: Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final String name = cat['name'];
                        final IconData icon = cat['icon'];
                        final bool isSelected = _selectedCategory == name;

                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = name;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF233B2B) : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF233B2B) : Colors.grey.shade300,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF233B2B).withOpacity(0.25),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        )
                                      ]
                                    : [],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    icon,
                                    size: 18,
                                    color: isSelected ? Colors.white : const Color(0xFF233B2B),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // 5. PRODUCTS SECTION TITLE & COUNT
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory == 'All' ? 'All Fresh Products' : '$_selectedCategory Items',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${filteredProducts.length} items',
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            // 6. PRODUCT GRID VIEW
            filteredProducts.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                        child: Column(
                          children: const [
                            Icon(Icons.search_off_rounded, size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('No products found', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.70,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = filteredProducts[index];
                          final isSaved = UserSession().isSaved(product);
                          final String imagePath = (product['imagePath'] ?? '').toString();
                          final bool hasLocalImage = imagePath.isNotEmpty && File(imagePath).existsSync();

                          return GestureDetector(
                            onTap: () => _navigateToDetail(product),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Image + Save Bookmark Overlay
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                          child: hasLocalImage
                                              ? Image.file(
                                                  File(imagePath),
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  product['imageUrl'],
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => Container(
                                                    color: Colors.grey[200],
                                                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                                  ),
                                                ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                UserSession().toggleSaveProduct(product);
                                              });
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    UserSession().isSaved(product)
                                                        ? 'Saved to Profile!'
                                                        : 'Removed from Saved',
                                                  ),
                                                  duration: const Duration(seconds: 1),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                isSaved ? Icons.bookmark : Icons.bookmark_border,
                                                size: 18,
                                                color: isSaved ? const Color(0xFF233B2B) : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Product Details Box
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['title'],
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Rp ${product['price']} k',
                                          style: const TextStyle(
                                            color: Color(0xFF233B2B),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '📍 ${product['origin']}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            // Add To Cart Button
                                            InkWell(
                                              onTap: () {
                                                UserSession().addToCart(product);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Added ${product['title']} to Cart!'),
                                                    duration: const Duration(seconds: 1),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF233B2B),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: const Icon(
                                                  Icons.add_shopping_cart_rounded,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: filteredProducts.length,
                      ),
                    ),
                  ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}