import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String image;
  final List<String> cutTypes;
  final int items;
  final DateTime? createdAt;

  const Category({
    required this.id,
    required this.name,
    required this.image,
    required this.cutTypes,
    required this.items,
    this.createdAt,
  });

  factory Category.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      cutTypes: List<String>.from(data['cutTypes'] ?? []),
      items: data['items'] ?? 0,
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
    );
  }
}
