import 'package:flutter/material.dart';


class ShopDetailScreen extends StatefulWidget {
  final Map<String, dynamic> shop;

  const ShopDetailScreen({Key? key, required this.shop}) : super(key: key);

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  // Sample products for the shop
  late List<Map<String, dynamic>> products;

  @override
  void initState() {
    super.initState();
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
            // Shop Information Header
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
            // Product Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  product['isSaved'] ? Icons.favorite : Icons.favorite_border,
                                  color: product['isSaved'] ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    product['isSaved'] = !product['isSaved'];
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
                        Text(
                          "Rp ${product['price']} / ${product['unit']}",
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

//the problem now is if we add the product to the cart from here its not automatically updated the cart page!!!