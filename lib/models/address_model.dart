import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id;
  final String name;
  final String type; // Home, Work, Other
  final String addressLine;
  final String city;
  final String zipCode;
  final String phoneNumber;

  AddressModel({
    required this.id,
    required this.name,
    required this.type,
    required this.addressLine,
    required this.city,
    required this.zipCode,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'addressLine': addressLine,
      'city': city,
      'zipCode': zipCode,
      'phoneNumber': phoneNumber,
    };
  }

  factory AddressModel.fromSnapshot(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return AddressModel(
      id: doc.id,
      name: map['name'] ?? '',
      type: map['type'] ?? 'Home',
      addressLine: map['addressLine'] ?? '',
      city: map['city'] ?? '',
      zipCode: map['zipCode'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
