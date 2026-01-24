import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/order_model.dart';
import 'auth_provider.dart';

class OrdersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? uid;

  OrdersService({this.uid});

  Future<void> placeOrder(List<CartItem> items, double total) async {
    if (uid == null) return;
    
    await _firestore.collection('orders').add({
      'userId': uid,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': total,
      'date': FieldValue.serverTimestamp(),
      'status': 'Pending',
    });
  }

  Stream<List<OrderModel>> getOrders() {
    if (uid == null) {
      return Stream.value([]);
    }
    
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
    });
  }
}

final ordersServiceProvider = Provider<OrdersService>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  return OrdersService(uid: user?.uid);
});

final ordersStreamProvider = StreamProvider<List<OrderModel>>((ref) {
  final service = ref.watch(ordersServiceProvider);
  return service.getOrders();
});
