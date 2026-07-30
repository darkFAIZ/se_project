import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user_session.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isSaved = UserSession().isSaved(product);

    // Image handling for File vs Network URL vs Fallback
    final File? imageFile = product['imageFile'];
    final String imageUrl = product['imageUrl'] ?? '';

    final double price = (product['price'] is num)
        ? (product['price'] as num).toDouble()
        : double.tryParse(product['price'].toString()) ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP APP BAR / IMAGE SECTION
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Banner with Floating Back & Save Buttons
                    Stack(
                      children: [
                        Container(
                          height: 320,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: imageFile != null
                              ? Image.file(
                                  imageFile,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 320,
                                )
                              : (imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 320,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                    )
                                  : const Icon(Icons.image, size: 50, color: Colors.grey)),
                        ),

                        // Back Button
                        Positioned(
                          top: 16,
                          left: 16,
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),

                        // Bookmark/Save Button
                        Positioned(
                          top: 16,
                          right: 16,
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            child: IconButton(
                              icon: Icon(
                                isSaved ? Icons.bookmark : Icons.bookmark_border,
                                color: isSaved ? const Color(0xFF233B2B) : Colors.black87,
                              ),
                              onPressed: () {
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
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 2. PRODUCT DETAILS CONTAINER
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9FAF7),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Tag
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F0E3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                product['category'] ?? 'Harvest',
                                style: const TextStyle(
                                  color: Color(0xFF233B2B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Product Title & Price Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    product['title'] ?? 'Fresh Harvest',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Rp ${price.toStringAsFixed(0)} k',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF233B2B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Farmer Info & Origin Card
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Color(0xFF233B2B),
                                    child: Icon(Icons.person, color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['farmer'] ?? 'Pak Tani',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '📍 ${product['origin'] ?? 'Indonesia'} • Stock: ${product['stock'] ?? 'Available'}',
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Description Section
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product['description'] ??
                                  'Fresh local produce harvested directly from farmers with care and high nutrition standards.',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Quantity Selector Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Quantity',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, size: 18),
                                        onPressed: () {
                                          if (_quantity > 1) {
                                            setState(() => _quantity--);
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          '$_quantity',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add, size: 18),
                                        onPressed: () {
                                          setState(() => _quantity++);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. BOTTOM ADD TO CART / BUY BAR
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Price', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(
                        'Rp ${(price * _quantity).toStringAsFixed(0)} k',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF233B2B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF233B2B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // Add to session cart with quantity
                          for (int i = 0; i < _quantity; i++) {
                            UserSession().addToCart(product);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added $_quantity ${product['title']} to Cart!'),
                              backgroundColor: const Color(0xFF233B2B),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                        label: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}