import 'package:flutter/material.dart';
import 'shop_detail_screen.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // 1. LOCATION HEADER BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 24, color: Colors.black87),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'North Jakarta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Blok S23 • Taman nyiur • Sunter',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.black87),
                      onPressed: () {},
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 2. FILTER & SORT BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildDropdownChip(label: 'Filter'),
                  const SizedBox(width: 8),
                  _buildDropdownChip(label: 'Sort'),
                  const Spacer(),
                  const Text(
                    '9 results',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 3. MAP AREA WITH FARMER PINS
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Stack(
                children: [
                  // Stylized Map Background (Grid effect)
                  Container(
                    color: const Color(0xFFE8EEF5),
                    child: CustomPaint(
                      painter: MapGridPainter(),
                      size: Size.infinite,
                    ),
                  ),

                  // Pins / Badges on Map
                  Positioned(
                    top: 20,
                    left: 50,
                    child: _buildMapPin('Fresh-Fruit'),
                  ),
                  Positioned(
                    top: 50,
                    right: 30,
                    child: _buildMapPin('Sayurku'),
                  ),
                  Positioned(
                    top: 80,
                    left: 120,
                    child: _buildUserPin(),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 15,
                    child: _buildMapPin('Beras-Jaya'),
                  ),
                  Positioned(
                    bottom: 40,
                    right: 25,
                    child: _buildMapPin('SDM-Gunung'),
                  ),
                ],
              ),
            ),

            // 4. SCROLLABLE FARMER SHOPS LIST
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F6ED), // Soft light green card background
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Farmer Shop Card 1: Beras-Jaya
                    _buildFarmerShopCard(
                      context: context,
                      imageUrl: 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=800',
                      shopName: 'Beras-Jaya',
                      rating: '4.8',
                      reviewCount: '500',
                      distance: '2.2 KM',
                      description: 'Beras-Jaya is the real rice with good quality',
                      discountOffer: '15% OFF on organic white rice',
                    ),
                    const SizedBox(height: 16),

                    // Farmer Shop Card 2: Fresh-Fruit
                    _buildFarmerShopCard(
                      context: context,
                      imageUrl: 'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=800',
                      shopName: 'Fresh-Fruit',
                      rating: '4.9',
                      reviewCount: '320',
                      distance: '1.5 KM',
                      description: 'Directly harvested fresh fruits everyday from regional orchards',
                      discountOffer: 'Buy 2 kg Grapes get 10% Discount!',
                    ),
                    const SizedBox(height: 16),

                    // Farmer Shop Card 3: Sayurku
                    _buildFarmerShopCard(
                      context: context,
                      imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800',
                      shopName: 'Sayurku',
                      rating: '4.7',
                      reviewCount: '180',
                      distance: '3.1 KM',
                      description: 'Fresh organic greens and daily vegetables direct from farm',
                      discountOffer: null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter/Sort Dropdown Chip
  static Widget _buildDropdownChip({required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
        ],
      ),
    );
  }

  // Shop Pin Widget for Map
  static Widget _buildMapPin(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // User Pin Widget for Map
  static Widget _buildUserPin() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF1B4D2E), // Dark green highlight
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        'You',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Helper to open shop detail screen
// Helper to open shop detail screen
  static void _navigateToShop(BuildContext context, String shopName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopDetailScreen(
          // Pass a Map with the 'name' key so it matches what ShopDetailScreen expects
          shop: {'name': shopName}, 
        ),
      ),
    );
  }

  // Farmer Shop Card Widget
  static Widget _buildFarmerShopCard({
    required BuildContext context,
    required String imageUrl,
    required String shopName,
    required String rating,
    required String reviewCount,
    required String distance,
    required String description,
    String? discountOffer,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shop Banner Image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 160,
                  color: Colors.grey[300],
                  child: const Icon(Icons.store, size: 40, color: Colors.grey),
                ),
              ),
              // Discount Tag Badge (If offer exists)
              if (discountOffer != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_offer, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          discountOffer,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Shop Name
        Text(
          shopName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 4),

        // Rating and Distance Row
        Row(
          children: [
            const Icon(Icons.star_border_rounded, size: 18, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '$rating ($reviewCount reviews)',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              distance,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Description & Select Button
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => _navigateToShop(context, shopName),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF223829), // Dark forest green
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                elevation: 0,
              ),
              child: const Text(
                'Select',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Custom Painter to draw stylized map grid lines in background
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 6.0;

    // Draw vertical road lines
    for (double i = 0; i < size.width; i += 70) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw horizontal road lines
    for (double i = 0; i < size.height; i += 45) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}