import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/address_model.dart';
import 'auth_provider.dart';

class AddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? uid;

  AddressService({this.uid});

  CollectionReference<Map<String, dynamic>>? get _userAddressesCollection {
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('addresses');
  }

  Future<void> addAddress(AddressModel address) async {
    if (_userAddressesCollection == null) return;
    await _userAddressesCollection!.add(address.toMap());
  }

  Future<void> deleteAddress(String id) async {
    if (_userAddressesCollection == null) return;
    await _userAddressesCollection!.doc(id).delete();
  }

  Stream<List<AddressModel>> getAddresses() {
    if (_userAddressesCollection == null) {
      return Stream.value([]);
    }
    return _userAddressesCollection!.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AddressModel.fromSnapshot(doc)).toList();
    });
  }
}

final addressServiceProvider = Provider<AddressService>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  return AddressService(uid: user?.uid);
});

final addressStreamProvider = StreamProvider<List<AddressModel>>((ref) {
  final service = ref.watch(addressServiceProvider);
  return service.getAddresses();
});
