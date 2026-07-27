import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'category_search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // 1. SEARCH BAR WITH CHAT & CHECKOUT BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Chat Button
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.black87, size: 22),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Checkout Button
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black87, size: 22),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. ACTION CHIPS
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildChip(
                      label: '% Promos',
                      backgroundColor: const Color(0xFF1B4D2E),
                      textColor: Colors.white,
                      icon: null,
                    ),
                    const SizedBox(width: 8),
                    _buildChip(
                      label: 'History',
                      backgroundColor: Colors.grey[200]!,
                      textColor: Colors.black87,
                      icon: Icons.history,
                    ),
                    const SizedBox(width: 8),
                    _buildChip(
                      label: 'Orders',
                      backgroundColor: Colors.grey[200]!,
                      textColor: Colors.black87,
                      icon: Icons.receipt_long_outlined,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. PROMO BANNER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=800',
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 160,
                          color: Colors.red[100],
                          child: const Center(child: Text('Apples Banner')),
                        ),
                      ),
                      Container(
                        height: 160,
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.2),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child: Text(
                          'APPLES',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 4. TYPE SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: const [
                    Text(
                      'Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.chevron_right, size: 22, color: Colors.black54),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: const [
                    _CategoryCircleItem(
                      imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300',
                      label: 'Vegetable',
                      categoryKey: 'Vegetables',
                    ),
                    SizedBox(width: 18),
                    _CategoryCircleItem(
                      imageUrl: 'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=300',
                      label: 'Fruit',
                      categoryKey: 'Fruit',
                    ),
                    SizedBox(width: 18),
                    _CategoryCircleItem(
                      imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=300',
                      label: 'Seasoning',
                      categoryKey: 'Seasoning',
                    ),
                    SizedBox(width: 18),
                    _CategoryCircleItem(
                      imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300',
                      label: 'Rice &\nWheat',
                      categoryKey: 'Grains',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 5. RECOMMENDED SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: const [
                    Text(
                      'Recommended',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.chevron_right, size: 22, color: Colors.black54),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              SizedBox(
                height: 240,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: const [
                    _ProductCard(
                      imageUrl: 'https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=400',
                      category: 'Fruitto',
                      title: 'Grape',
                      price: '17k',
                    ),
                    SizedBox(width: 14),
                    _ProductCard(
                      imageUrl: 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400',
                      category: 'Fresh-Fruit',
                      title: 'Watermelon',
                      price: '20k',
                    ),
                    SizedBox(width: 14),
                    _ProductCard(
                      imageUrl: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400',
                      category: 'Fresh-Fruit',
                      title: 'Banana',
                      price: '15k',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      // bottomNavigationBar dihapus seluruhnya dari sini
    );
  }

  static Widget _buildChip({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCircleItem extends StatelessWidget {
  final String imageUrl;
  final String label;
  final String categoryKey;

  const _CategoryCircleItem({
    required this.imageUrl,
    required this.label,
    required this.categoryKey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategorySearchScreen(categoryTitle: categoryKey),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String price;

  const _ProductCard({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: const Color(0xFFE2EAD6),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 130,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            price,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}