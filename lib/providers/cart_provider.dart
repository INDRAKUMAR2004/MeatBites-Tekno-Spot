import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    if (state.any((item) => item.id == product.id)) {
      state = [
        for (final item in state)
          if (item.id == product.id)
            item.copyWith(qty: item.qty + 1)
          else
            item
      ];
    } else {
      state = [
        ...state,
        CartItem(
          id: product.id,
          name: product.name,
          price: product.price,
          qty: 1,
          image: product.image,
          weight: product.weight,
          netWeight: product.netWeight,
        ),
      ];
    }
  }

  void increaseQty(String id) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(qty: item.qty + 1) else item
    ];
  }

  void decreaseQty(String id) {
    // Using explicit loop to avoid syntax ambiguity with dangling else
    final newState = <CartItem>[];
    for (final item in state) {
      if (item.id == id) {
        if (item.qty > 1) {
          newState.add(item.copyWith(qty: item.qty - 1));
        }
        // else: qty is 1, so we drop it (remove from cart)
      } else {
        newState.add(item);
      }
    }
    state = newState;
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
  
  double get total => state.fold(0, (sum, item) => sum + (item.price * item.qty));

  void clear() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + (item.price * item.qty));
});
