import 'package:cloud_firestore/cloud_firestore.dart';

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
  factory Product.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      category: data['category'] ?? '',
      name: data['name'] ?? '',
      weight: data['weight'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      oldPrice: data['oldPrice'] != null ? (data['oldPrice'] as num).toDouble() : null,
      elite: data['elite'] ?? false,
      image: data['image'] ?? '',
      netWeight: data['netWeight'] ?? '',
      grossWeight: data['grossWeight'] ?? '',
      deliveryTime: data['deliveryTime'] ?? '',
      discountPercentage: data['discountPercentage'],
      isBestseller: data['isBestseller'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'name': name,
      'weight': weight,
      'price': price,
      'oldPrice': oldPrice,
      'elite': elite,
      'image': image,
      'netWeight': netWeight,
      'grossWeight': grossWeight,
      'deliveryTime': deliveryTime,
      'discountPercentage': discountPercentage,
      'isBestseller': isBestseller,
    };
  }
}
