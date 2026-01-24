import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/colors.dart';
import '../models/address_model.dart';
import '../providers/address_provider.dart';
import '../providers/selected_address_provider.dart';
import 'map_selection_screen.dart';
import 'package:geocoding/geocoding.dart';

class SavedAddressScreen extends ConsumerWidget {
  const SavedAddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressAsyncValue = ref.watch(addressStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Saved Addresses', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: addressAsyncValue.when(
        data: (addresses) {
          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.mapPin, size: 60, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No saved addresses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final address = addresses[index];
              return _AddressCard(address: address);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ]
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () => _showAddAddressSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.plus, size: 20),
                SizedBox(width: 8),
                Text("Add New Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddAddressSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddAddressForm(),
    );
  }
}

class _AddressCard extends ConsumerWidget {
  final AddressModel address;
  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IconData icon;
    switch (address.type.toLowerCase()) {
      case 'work':
        icon = LucideIcons.briefcase;
        break;
      case 'other':
        icon = LucideIcons.mapPin;
        break;
      case 'home':
      default:
        icon = LucideIcons.home;
    }

    // Check if this card is selected
    final selectedId = ref.watch(selectedAddressIdProvider);
    final isSelected = selectedId == address.id || (selectedId == null && ref.watch(addressStreamProvider).asData?.value.first.id == address.id); // Fallback logic is complex in UI, better simplified
    // Actually, simplifying: The provider handles defaulting. We just need to check if 'this' is effectively selected.
    
    // Better way: compare to the *actual resolved* selected address
    final currentSelected = ref.watch(selectedAddressProvider).asData?.value;
    final isEffectiveSelected = currentSelected?.id == address.id;

    return InkWell(
      onTap: () async {
        await ref.read(selectedAddressIdProvider.notifier).select(address.id);
        if (context.mounted) Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isEffectiveSelected ? Border.all(color: AppColors.primary, width: 2) :Border.all(color: Colors.transparent),
           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        address.type,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      if (isEffectiveSelected)
                        const Icon(Icons.check_circle, color: AppColors.primary, size: 20)
                      else
                        InkWell(
                          onTap: () {
                             showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Delete Address?"),
                                content: const Text("Are you sure you want to delete this address?"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                                  TextButton(
                                    onPressed: () {
                                      ref.read(addressServiceProvider).deleteAddress(address.id);
                                      Navigator.pop(ctx);
                                    },
                                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Icon(LucideIcons.trash2, size: 18, color: Colors.grey),
                        )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.name,
                     style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF2D2D2D)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${address.addressLine}, ${address.city} - ${address.zipCode}",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
                  ),
                   const SizedBox(height: 4),
                  Text(
                    "Phone: ${address.phoneNumber}",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddAddressForm extends ConsumerStatefulWidget {
  const _AddAddressForm();

  @override
  ConsumerState<_AddAddressForm> createState() => _AddAddressFormState();
}

class _AddAddressFormState extends ConsumerState<_AddAddressForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedType = 'Home';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newAddress = AddressModel(
        id: '', // Generated by Firestore
        name: _nameController.text,
        type: _selectedType,
        addressLine: _addressController.text,
        city: _cityController.text,
        zipCode: _zipController.text,
        phoneNumber: _phoneController.text,
      );

      await ref.read(addressServiceProvider).addAddress(newAddress);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving address: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Add New Address", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const Divider(),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text("Address Type", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Home', 'Work', 'Other'].map((type) {
                      final isSelected = _selectedType == type;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedType = type),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            type,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  
                  
                  OutlinedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MapSelectionScreen()),
                      );

                      if (result != null && result is Map) {
                        final placemark = result['placemark'] as Placemark?;
                        if (placemark != null) {
                          setState(() {
                             _addressController.text = result['address'] ?? "";
                             _cityController.text = placemark.locality ?? "";
                             _zipController.text = placemark.postalCode ?? "";
                          });
                        }
                      }
                    },
                    icon: const Icon(LucideIcons.mapPin, size: 18),
                    label: const Text("Select from Map"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.grey[300]!),
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildTextField("Full Name", _nameController),
                  const SizedBox(height: 16),
                  _buildTextField("Phone Number", _phoneController, keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildTextField("Address (House No, Building, Street)", _addressController),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField("City", _cityController)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField("Zip Code", _zipController, keyboardType: TextInputType.number)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Save Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) => value == null || value.isEmpty ? '$label is required' : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
