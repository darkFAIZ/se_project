import '../models/product.dart';

final List<Product> mockProducts = [
  Product(
    id: 'p1',
    name: 'Organically Grown Tomatoes',
    category: 'Vegetables',
    pricePerKg: 14000.0,
    availableQuantityKg: 150.0,
    farmerName: 'Pak Budi',
    location: 'Lembang, West Java',
    imageUrl: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=600&q=80',
  ),
  Product(
    id: 'p2',
    name: 'Fresh Fuji Apples',
    category: 'Fruits',
    pricePerKg: 28000.0,
    availableQuantityKg: 80.0,
    farmerName: 'Ibu Siti',
    location: 'Malang, East Java',
    imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=600&q=80',
  ),
  Product(
    id: 'p3',
    name: 'Organic Red Rice',
    category: 'Grains',
    pricePerKg: 18000.0,
    availableQuantityKg: 300.0,
    farmerName: 'Pak Asep',
    location: 'Cianjur, West Java',
    imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=600&q=80',
  ),
];