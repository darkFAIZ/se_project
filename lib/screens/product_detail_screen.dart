import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: const Color(0xFF233B2B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Banner Image
            Image.network(
              product.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: product.getBadgeColor(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.categoryName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${product.subCategory}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 10),

                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  
                  const SizedBox(height: 8),

                  Text(
                    'Rp ${product.price}',
                    style: const TextStyle(
                      fontSize: 20, 
                      color: Color(0xFF233B2B), 
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Divider(height: 30),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF233B2B),
                      child: Icon(Icons.agriculture, color: Colors.white),
                    ),
                    title: Text(
                      'Directly from ${product.farmerName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(product.location),
                  ),

                  const SizedBox(height: 12),

                  Chip(
                    label: Text(
                      'Available Stock: ${product.availableQuantityKg} kg',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: const Color(0xFFE2EAD6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar removed entirely
    );
  }
}