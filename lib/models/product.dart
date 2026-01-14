class Product {
  final String id;
  final String category;
  final String name;
  final String weight;
  final double price;
  final double? oldPrice;
  final bool elite;
  final String image;
  final String netWeight;
  final String grossWeight;
  final String deliveryTime;
  final int? discountPercentage;
  final bool isBestseller;

  const Product({
    required this.id,
    required this.category,
    required this.name,
    required this.weight, // Keep for backward compat or display subtitle
    required this.price,
    this.oldPrice,
    this.elite = false,
    required this.image,
    this.netWeight = "500g",
    this.grossWeight = "550g",
    this.deliveryTime = "90 min",
    this.discountPercentage,
    this.isBestseller = false,
  });
}
