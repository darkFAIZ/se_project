import 'package:flutter/material.dart';
import '../models/user_session.dart';

// ShopDetailScreen displays information for a specific physical shop/farmer and their unique product catalog
class ShopDetailScreen extends StatefulWidget {
  final Map<String, dynamic> shop;

  const ShopDetailScreen({Key? key, required this.shop}) : super(key: key);

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  // Collection representing sample products specific to this particular shop
  late List<Map<String, dynamic>> products;

  // Utility to format price logically translating inputs to thousands 'k' format for UI scaling
  double _normalizePrice(dynamic rawPrice) {
    final value = (rawPrice is num)
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice.toString()) ?? 0;

    if (value <= 0) return 0;
    if (value >= 1000) {
      return value / 1000;
    }
    return value;
  }

  @override
  void initState() {
    super.initState();
    // Static dummy data mapping local products for this specific store
    products = [
      {
        'id': 'p1',
        'name': 'Fresh Red Apple',
        'price': 25000,
        'unit': 'kg',
        'image': 'https://via.placeholder.com/150',
        'isSaved': false,
      },
      {
        'id': 'p2',
        'name': 'Organic Spinach',
        'price': 12000,
        'unit': 'bunch',
        'image': 'https://via.placeholder.com/150',
        'isSaved': true,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shop['name'] ?? 'Shop Detail'),
        backgroundColor: const Color(0xFF1B4D3E),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Information Header Block (Info fetched directly from the widget mapping)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.shop['name'] ?? '',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "⭐ ${widget.shop['rating'] ?? '4.8'} • 📍 ${widget.shop['distance'] ?? '1.5 KM'}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.shop['description'] ?? 'Directly harvested products direct from farm.',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Products Offered',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Product Grid representing inventory for this specific shop
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Allows SingleChildScrollView to govern scrolling
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                
                // Construct a normalized map productForSession to pass into UserSession functions.
                // This resolves naming conflicts (e.g. 'name' vs 'title', 'image' vs 'imageUrl')
                // so session tracking remains consistent globally across screens.
                final productForSession = {
                  ...product,
                  'title': product['name'] ?? product['title'] ?? 'Product',
                  'name': product['name'] ?? product['title'] ?? 'Product',
                  'imageUrl': product['imageUrl'] ?? product['image'] ?? '',
                  'category': product['category'] ?? 'Shop',
                  'farmer': product['farmer'] ?? widget.shop['name'] ?? 'Farmer',
                  'origin': product['origin'] ?? 'Indonesia',
                  'stock': product['stock'] ?? 'Available',
                  'description': product['description'] ?? 'Fresh produce from this shop.',
                };
                // Determine save state using the standardized map
                final isSaved = UserSession().isSaved(productForSession);

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stack image and favorite icon overlay
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[200],
                              ),
                              child: const Icon(Icons.image, size: 50, color: Colors.grey),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: Icon(
                                  isSaved ? Icons.favorite : Icons.favorite_border,
                                  color: isSaved ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    UserSession().toggleSaveProduct(productForSession); // Modifies Global Session state
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        // Process raw price UI presentation
                        Text(
                          "Rp ${_normalizePrice(product['price']).toStringAsFixed(0)} k / ${product['unit']}",
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B4D3E),
                            ),
                            onPressed: () {
                              // Ensure standardized structure gets pushed into the session shopping cart 
                              final cartProduct = {
                                ...productForSession,
                                'title': product['name'] ?? product['title'] ?? 'Product',
                                'imageUrl': product['imageUrl'] ?? product['image'],
                                'category': product['category'] ?? widget.shop['name'] ?? 'Shop',
                                'farmer': product['farmer'] ?? widget.shop['name'] ?? 'Farmer',
                                'origin': product['origin'] ?? 'Indonesia',
                                'stock': product['stock'] ?? 'Available',
                                'description': product['description'] ?? 'Fresh produce from this shop.',
                                'price': _normalizePrice(product['price']), // Injects fixed price value
                              };

                              UserSession().addToCart(cartProduct);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Added ${product['name']} to cart!')),
                              );
                            },
                            child: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}