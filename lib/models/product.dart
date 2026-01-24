import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String category;
  final String name;
  final String description;
  final String weight;
  final double price;
  final double? oldPrice;
  final bool elite;
  final String image; // Main image
  final List<String> images; // Array of images
  final String netWeight;
  final String grossWeight;
  final String deliveryTime;
  final int? discountPercentage;
  final bool isBestseller;
  final String cutType;
  final String availability;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.weight,
    required this.price,
    this.oldPrice,
    this.elite = false,
    required this.image,
    this.images = const [],
    this.netWeight = "500g",
    this.grossWeight = "550g",
    this.deliveryTime = "90 min",
    this.discountPercentage,
    this.isBestseller = false,
    this.cutType = "",
    this.availability = "in-stock",
    this.createdAt,
  });

  factory Product.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      category: data['category'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      weight: data['weight'] ?? '', // Fallback or use cutType if weight missing? Keeping for now.
      price: (data['price'] ?? 0).toDouble(),
      oldPrice: data['oldPrice'] != null ? (data['oldPrice'] as num).toDouble() : null,
      elite: data['elite'] ?? false,
      image: data['image'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      netWeight: data['netWeight'] ?? '',
      grossWeight: data['grossWeight'] ?? '',
      deliveryTime: data['deliveryTime'] ?? '90 min',
      discountPercentage: data['discountPercentage'],
      isBestseller: data['isBestseller'] ?? false,
      cutType: data['cutType'] ?? '',
      availability: data['availability'] ?? 'in-stock',
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'name': name,
      'description': description,
      'weight': weight,
      'price': price,
      'oldPrice': oldPrice,
      'elite': elite,
      'image': image,
      'images': images,
      'netWeight': netWeight,
      'grossWeight': grossWeight,
      'deliveryTime': deliveryTime,
      'discountPercentage': discountPercentage,
      'isBestseller': isBestseller,
      'cutType': cutType,
      'availability': availability,
    };
  }
}
