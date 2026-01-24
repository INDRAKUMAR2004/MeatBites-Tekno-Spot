import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address_model.dart';
import 'address_provider.dart';

// 1. Provider for the ID of the selected address
final selectedAddressIdProvider = StateNotifierProvider<SelectedAddressIdNotifier, String?>((ref) {
  return SelectedAddressIdNotifier();
});

class SelectedAddressIdNotifier extends StateNotifier<String?> {
  SelectedAddressIdNotifier() : super(null) {
    _loadPersisted();
  }

  Future<void> _loadPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('selected_address_id');
  }

  Future<void> select(String id) async {
    state = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_address_id', id);
  }
  
  Future<void> clear() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_address_id');
  }
}

// 2. Computed Provider: Returns the actual AddressModel of the selected address
final selectedAddressProvider = Provider<AsyncValue<AddressModel?>>((ref) {
  final addressesAsync = ref.watch(addressStreamProvider);
  final selectedId = ref.watch(selectedAddressIdProvider);

  return addressesAsync.whenData((addresses) {
    if (addresses.isEmpty) return null;

    // If no ID is selected, default to the first one (or null if you prefer)
    if (selectedId == null) return addresses.first;

    // Find the selected address
    try {
      return addresses.firstWhere((a) => a.id == selectedId);
    } catch (e) {
      // If the selected ID doesn't exist (e.g. deleted), fallback to first
      return addresses.first;
    }
  });
});
