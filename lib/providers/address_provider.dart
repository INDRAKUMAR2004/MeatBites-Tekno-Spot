import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/address_model.dart';

class AddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAddress(AddressModel address) async {
    await _firestore.collection('addresses').add(address.toMap());
  }

  Future<void> deleteAddress(String id) async {
    await _firestore.collection('addresses').doc(id).delete();
  }

  Stream<List<AddressModel>> getAddresses() {
    return _firestore.collection('addresses').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AddressModel.fromSnapshot(doc)).toList();
    });
  }
}

final addressServiceProvider = Provider<AddressService>((ref) {
  return AddressService();
});

final addressStreamProvider = StreamProvider<List<AddressModel>>((ref) {
  final service = ref.watch(addressServiceProvider);
  return service.getAddresses();
});
