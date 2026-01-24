import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime date;
  final String status;
  final Map<String, dynamic>? otp; // OTP field

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.date,
    required this.status,
    this.otp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((x) => x.toMap()).toList(),
      'totalAmount': totalAmount,
      'date': Timestamp.fromDate(date),
      'status': status,
      'otp': otp,
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: map['userId'] ?? '',
      items: List<CartItem>.from(
        (map['items'] as List<dynamic>).map((x) => CartItem.fromMap(x)),
      ),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      date: (map['date'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
      otp: map['otp'] as Map<String, dynamic>?,
    );
  }
}
