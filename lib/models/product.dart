class Product {
  final String id;
  final String name;
  final String category;
  final double pricePerKg;
  final double availableQuantityKg;
  final String farmerName;
  final String location;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.pricePerKg,
    required this.availableQuantityKg,
    required this.farmerName,
    required this.location,
    required this.imageUrl,
  });
}