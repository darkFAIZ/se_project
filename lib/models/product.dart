import 'package:flutter/material.dart';

// Abstract Base Class
abstract class Product {
  final String id;
  final String name;
  final String categoryName;
  final String subCategory;
  final String price;
  final String imageUrl;
  final String farmerName;
  final String location;
  final double availableQuantityKg;

  Product({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.subCategory,
    required this.price,
    required this.imageUrl,
    this.farmerName = 'Pak Tani',
    this.location = 'BOGOR',
    this.availableQuantityKg = 50.0,
  });

  // Polymorphic method to get category badge color
  Color getBadgeColor();
}

// Concrete Class 1: Fruit
class FruitProduct extends Product {
  FruitProduct({
    required super.id,
    required super.name,
    required super.subCategory,
    required super.price,
    required super.imageUrl,
    super.farmerName,
    super.location,
    super.availableQuantityKg,
  }) : super(categoryName: 'Fruit');

  @override
  Color getBadgeColor() => Colors.orangeAccent.shade100;
}

// Concrete Class 2: Vegetable
class VegetableProduct extends Product {
  VegetableProduct({
    required super.id,
    required super.name,
    required super.subCategory,
    required super.price,
    required super.imageUrl,
    super.farmerName,
    super.location,
    super.availableQuantityKg,
  }) : super(categoryName: 'Vegetables');

  @override
  Color getBadgeColor() => Colors.lightGreen.shade200;
}

// Mock Repository populated via Polymorphic Product instances
class ProductRepository {
  static final List<Product> allProducts = [
    // Fruits
    FruitProduct(
      id: '1',
      name: 'Banana',
      subCategory: 'Fresh-Fruit',
      price: '15.k',
      imageUrl: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400',
    ),
    FruitProduct(
      id: '2',
      name: 'Grape',
      subCategory: 'Fruitto',
      price: '17 k',
      imageUrl: 'https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=400',
    ),
    FruitProduct(
      id: '3',
      name: 'Watermelon',
      subCategory: 'Fresh-Fruit',
      price: '20 k',
      imageUrl: 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400',
    ),

    // Vegetables
    VegetableProduct(
      id: '4',
      name: 'Broccoli',
      subCategory: 'Fresh-Veggie',
      price: '20 k',
      imageUrl: 'https://images.unsplash.com/photo-1584270354949-c26b0d5b4a0c?w=400',
    ),
    VegetableProduct(
      id: '5',
      name: 'Lettuce',
      subCategory: 'Fresh-Veggie',
      price: '20 k',
      imageUrl: 'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400',
    ),
    VegetableProduct(
      id: '6',
      name: 'Spinach',
      subCategory: 'Leafy',
      price: '20 k',
      imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
    ),
    VegetableProduct(
      id: '7',
      name: 'Cabbage',
      subCategory: 'Fresh-Veggie',
      price: '20 k',
      imageUrl: 'https://images.unsplash.com/photo-1594282486552-05b4d80fbb9f?w=400',
    ),
  ];

  // Polymorphic Filter Query Method
  static List<Product> getByCategory(String category) {
    return allProducts
        .where((p) => p.categoryName.toLowerCase() == category.toLowerCase())
        .toList();
  }
}