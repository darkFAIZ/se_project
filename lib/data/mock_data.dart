import 'package:flutter/material.dart';

// Abstract Base Class defining the blueprint for all products
abstract class Product {
  final String id;
  final String name;
  final String categoryName;
  final String subCategory;
  final String price;
  final String imageUrl;
  final double availableQuantityKg;
  final String farmerName;
  final String location;

  Product({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.subCategory,
    required this.price,
    required this.imageUrl,
    required this.availableQuantityKg,
    required this.farmerName,
    required this.location,
  });

  // Polymorphic method to get badge color, to be overridden by subclasses
  Color getBadgeColor();
}

// 1. Concrete Class: Vegetable inheriting from Product
class VegetableProduct extends Product {
  VegetableProduct({
    required super.id,
    required super.name,
    required super.subCategory,
    required super.price,
    required super.imageUrl,
    required super.availableQuantityKg,
    required super.farmerName,
    required super.location,
  }) : super(categoryName: 'Vegetable'); // Hardcodes the category name

  @override
  Color getBadgeColor() => Colors.lightGreen.shade200; // Specific color for vegetables
}

// 2. Concrete Class: Fruit inheriting from Product
class FruitProduct extends Product {
  FruitProduct({
    required super.id,
    required super.name,
    required super.subCategory,
    required super.price,
    required super.imageUrl,
    required super.availableQuantityKg,
    required super.farmerName,
    required super.location,
  }) : super(categoryName: 'Fruit');

  @override
  Color getBadgeColor() => Colors.orangeAccent.shade100; // Specific color for fruits
}

// 3. Concrete Class: Grain inheriting from Product
class GrainProduct extends Product {
  GrainProduct({
    required super.id,
    required super.name,
    required super.subCategory,
    required super.price,
    required super.imageUrl,
    required super.availableQuantityKg,
    required super.farmerName,
    required super.location,
  }) : super(categoryName: 'Rice & Wheat');

  @override
  Color getBadgeColor() => Colors.amber.shade200; // Specific color for grains
}

// Polymorphic Mock Repository holding static dummy data for testing
class ProductRepository {
  static final List<Product> mockProducts = [
    VegetableProduct(
      id: 'p1',
      name: 'Organically Grown Tomatoes',
      subCategory: 'Fresh-Veggie',
      price: '14 k',
      availableQuantityKg: 150.0,
      farmerName: 'Pak Budi',
      location: 'Lembang, West Java',
      imageUrl: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=600&q=80',
    ),
    FruitProduct(
      id: 'p2',
      name: 'Fresh Fuji Apples',
      subCategory: 'Fresh-Fruit',
      price: '28 k',
      availableQuantityKg: 80.0,
      farmerName: 'Ibu Siti',
      location: 'Malang, East Java',
      imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=600&q=80',
    ),
    GrainProduct(
      id: 'p3',
      name: 'Organic Red Rice',
      subCategory: 'Grain',
      price: '18 k',
      availableQuantityKg: 300.0,
      farmerName: 'Pak Asep',
      location: 'Cianjur, West Java',
      imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=600&q=80',
    ),
    FruitProduct(
      id: 'p4',
      name: 'Banana',
      subCategory: 'Fresh-Fruit',
      price: '15.k',
      availableQuantityKg: 50.0,
      farmerName: 'Pak Budi',
      location: 'Lembang, West Java',
      imageUrl: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400',
    ),
    FruitProduct(
      id: 'p5',
      name: 'Grape',
      subCategory: 'Fruitto',
      price: '17 k',
      availableQuantityKg: 40.0,
      farmerName: 'Ibu Siti',
      location: 'Malang, East Java',
      imageUrl: 'https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=400',
    ),
  ];

  // Polymorphic Category Filtering Query to search through the mock products
  static List<Product> getByCategory(String category) {
    return mockProducts.where((p) {
      final target = category.toLowerCase().trim();
      final current = p.categoryName.toLowerCase().trim();
      // Checks for partial string matches for robust filtering
      return current.contains(target) || target.contains(current);
    }).toList();
  }
}