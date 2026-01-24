import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

/*
  BASIC FIRESTORE STRUCTURE FOR PRODUCTS:
  
  Collection: "products"
  Document ID: (Auto-generated or custom string like "prod_001")
  
  Fields:
  - category: String (e.g., "chicken", "mutton", "fish")
  - name: String (e.g., "Country Chicken Curry Cut")
  - weight: String (e.g., "550-600 Gms")
  - price: Number (Double) (e.g., 349.0)
  - oldPrice: Number (Double) (Optional, e.g., 399.0)
  - elite: Boolean (e.g., true/false)
  - image: String (URL of the image or asset path if local)
  - netWeight: String (e.g., "500g")
  - grossWeight: String (e.g., "550g")
  - deliveryTime: String (e.g., "45 min")
  - discountPercentage: Number (Int) (Optional, e.g., 12)
  - isBestseller: Boolean (e.g., true/false)

  Example Document (JSON representation):
  {
    "category": "chicken",
    "name": "Country Chicken Curry Cut",
    "weight": "550-600 Gms",
    "price": 349.0,
    "oldPrice": 399.0,
    "elite": true,
    "image": "https://example.com/chicken.png",
    "netWeight": "500g",
    "grossWeight": "550g",
    "deliveryTime": "45 min",
    "discountPercentage": 12,
    "isBestseller": true
  }
*/

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }

  // Helper to fetch valid categories if needed, or by category
  Stream<List<Product>> getProductsByCategory(String categoryId) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: categoryId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }
}

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

final productsProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(productServiceProvider).getProducts();
});

// Helper provider for Bestsellers
final bestsellersProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  return productsAsync.whenData((products) => 
      products.where((p) => p.isBestseller).toList());
});
