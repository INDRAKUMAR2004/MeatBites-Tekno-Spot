import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/order_model.dart';
import 'cart_provider.dart';

class OrdersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(List<CartItem> items, double total) async {
    await _firestore.collection('orders').add({
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': total,
      'date': FieldValue.serverTimestamp(),
      'status': 'Pending',
    });
  }

  Stream<List<OrderModel>> getOrders() {
    return _firestore
        .collection('orders')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
    });
  }
}

final ordersServiceProvider = Provider<OrdersService>((ref) {
  return OrdersService();
});

final ordersStreamProvider = StreamProvider<List<OrderModel>>((ref) {
  final service = ref.watch(ordersServiceProvider);
  return service.getOrders();
});
