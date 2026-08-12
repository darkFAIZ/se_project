import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user_session.dart';

// ProductDetailScreen provides an in-depth view of a product, allowing quantity modification and adding to cart
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
  // State variable holding the amount of items the user wants to add to the cart
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    // Check global session state to determine if this exact product is bookmarked by the user
    final isSaved = UserSession().isSaved(product);

    // Image handling mapping potential sources: priority is local File, fallback is Network URL
    final String imagePath = (product['imagePath'] ?? '').toString();
    final File? imageFile = product['imageFile'] ?? (imagePath.isNotEmpty ? File(imagePath) : null);
    final String imageUrl = imagePath.isNotEmpty ? imagePath : (product['imageUrl'] ?? '');

    // Safely parse price converting to double format for UI formatting
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
                        // Image Container Background
                        Container(
                          height: 320,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: imageFile != null && imageFile.existsSync()
                              ? Image.file(
                                  imageFile,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 320,
                                )
                              : (imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.scheme != null
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

                        // Floating Back Navigation Button
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

                        // Floating Bookmark/Save Action Button
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
                                  // Modifies global UserSession state and locally redraws UI
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
                      offset: const Offset(0, -20), // Pulls the container up to overlap the image slightly
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9FAF7),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Badge Tag
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

                            // Farmer Info & Origin Context Card
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

                            // Detailed Text Description Section
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

                            // Dynamic Quantity Selector Row
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
                                            setState(() => _quantity--); // Decrement if above 1
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
                                          setState(() => _quantity++); // Increment quantity
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

            // 3. BOTTOM ACTION BAR: Pricing calculation and Add to Cart Button
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
                  // Calculated Total Price Output
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
                  // Checkout Action Button
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
                          // Iteratively adds the exact product configuration based on defined _quantity
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