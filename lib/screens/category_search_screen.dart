import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user_session.dart';
import 'product_detail_screen.dart'; // <--- Vital import to fix the red line

class CategorySearchScreen extends StatefulWidget {
  final String selectedCategory;

  const CategorySearchScreen({
    super.key,
    this.selectedCategory = 'All',
  });

  @override
  State<CategorySearchScreen> createState() => _CategorySearchScreenState();
}

class _CategorySearchScreenState extends State<CategorySearchScreen> {
  late String _activeCategory;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Vegetables',
    'Fruits',
    'Grains',
    'Organic',
  ];

  // Sample/Mock products list
  final List<Map<String, dynamic>> _allProducts = [
    {
      'title': 'Organic Spinach',
      'price': 15,
      'category': 'Vegetables',
      'farmer': 'Pak Ahmad',
      'origin': 'Bogor',
      'stock': '50 kg',
      'description': 'Fresh organic spinach directly harvested from highland farms.',
      'imageUrl': 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500',
    },
    {
      'title': 'Fresh Carrots',
      'price': 12,
      'category': 'Vegetables',
      'farmer': 'Ibu Budi',
      'origin': 'Bandung',
      'stock': '30 kg',
      'description': 'Crispy and sweet local carrots packed with vitamins.',
      'imageUrl': 'https://images.unsplash.com/photo-1598170845058-12ef4a457939?w=500',
    },
    {
      'title': 'Red Apples',
      'price': 25,
      'category': 'Fruits',
      'farmer': 'Pak Sugeng',
      'origin': 'Malang',
      'stock': '20 kg',
      'description': 'Sweet Malang red apples with rich flavor.',
      'imageUrl': 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=500',
    },
    {
      'title': 'Organic Rice',
      'price': 65,
      'category': 'Grains',
      'farmer': 'Toko Rahmat',
      'origin': 'Cianjur',
      'stock': '100 kg',
      'description': 'Premium white organic rice, healthy and aromatic.',
      'imageUrl': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500',
    },
  ];

  @override
  void initState() {
    super.initState();
    _activeCategory = widget.selectedCategory;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredProducts {
    // Combine user posts from UserSession with static products
    final sessionPosts = UserSession().currentUser?.userPosts ?? [];
    final combinedList = [..._allProducts, ...sessionPosts];

    return combinedList.where((product) {
      final title = (product['title'] ?? '').toString().toLowerCase();
      final category = (product['category'] ?? '').toString();

      final matchesSearch = title.contains(_searchQuery.toLowerCase());
      final matchesCategory = _activeCategory == 'All' || category == _activeCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      appBar: AppBar(
        title: const Text(
          'Explore Products',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search fresh harvests...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),
            ),

            // 2. CATEGORY PILLS
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _activeCategory;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: const Color(0xFF233B2B),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _activeCategory = category;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // 3. PRODUCT GRID
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            'No products found',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        // EXPLICIT MAP CASTING TO AVOID RED LINES
                        final Map<String, dynamic> product = filteredList[index];

                        final File? imageFile = product['imageFile'];
                        final String imageUrl = product['imageUrl'] ?? '';
                        final double price = (product['price'] is num)
                            ? (product['price'] as num).toDouble()
                            : double.tryParse(product['price'].toString()) ?? 0;

                        return GestureDetector(
                          onTap: () {
                            // CLICK NAVIGATION TO PRODUCT DETAIL SCREEN
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  product: product, // Clean & Red-free!
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image Header
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.grey[200],
                                      child: imageFile != null
                                          ? Image.file(imageFile, fit: BoxFit.cover)
                                          : (imageUrl.isNotEmpty
                                              ? Image.network(imageUrl, fit: BoxFit.cover)
                                              : const Icon(Icons.image, color: Colors.grey)),
                                    ),
                                  ),
                                ),

                                // Details Body
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['title'] ?? 'Fresh Product',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rp ${price.toStringAsFixed(0)} k',
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
                                            product['farmer'] ?? 'Pak Tani',
                                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                                          ),
                                          IconButton(
                                            constraints: const BoxConstraints(),
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(Icons.add_shopping_cart, size: 18, color: Color(0xFF233B2B)),
                                            onPressed: () {
                                              UserSession().addToCart(product);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Added ${product['title']} to cart!'),
                                                  duration: const Duration(seconds: 1),
                                                ),
                                              );
                                            },
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}