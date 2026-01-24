import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/colors.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final itemTotal = ref.watch(cartTotalProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    // Mock calculations
    final deliveryFee = itemTotal > 499 ? 0.0 : 40.0;
    final taxes = itemTotal * 0.05; // 5% tax
    final grandTotal = itemTotal + deliveryFee + taxes;

    if (cartItems.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.shoppingBag, size: 60, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              const Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF2D2D2D)),
              ),
              const SizedBox(height: 12),
              const Text(
                'Good food is waiting for you!\nStart adding items now.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Start Shopping', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Cart', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            Text('${cartItems.length} items', style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                 // Cart Items List
                 ...cartItems.map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]
                  ),
                  child: Row(
                    children: [
                      // Image Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item.image,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_,__,___) => Container(width: 70, height: 70, color: Colors.grey[200]),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF2D2D2D)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.netWeight ?? item.weight, 
                              style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500)
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('₹${item.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                
                                // Qty Controls
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red[100]!)
                                  ),
                                  child: Row(
                                    children: [
                                      _qtyBtn(LucideIcons.minus, () => cartNotifier.decreaseQty(item.id)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text('${item.qty}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                      ),
                                      _qtyBtn(LucideIcons.plus, () => cartNotifier.increaseQty(item.id)),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )).toList(),

                const SizedBox(height: 24),

                // Bill Details
                const Text("Bill Details", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                     boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]
                  ),
                  child: Column(
                    children: [
                      _billRow("Item Total", itemTotal),
                      const SizedBox(height: 12),
                      _billRow("Taxes & Charges", taxes),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Delivery Fee", style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                          deliveryFee == 0
                           ? const Text("FREE", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
                           : Text("₹${deliveryFee.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Grand Total", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                          Text("₹${grandTotal.toStringAsFixed(0)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Coupon PlaceHolder
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.grey[300]!, style: BorderStyle.none), // Using dash effect is complex in generic container, skipping for simple outline
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(12)
                   ),
                   child: const Row(
                     children: [
                        Icon(LucideIcons.ticket, color: AppColors.primary, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                         child: Text("Apply Coupon", style: TextStyle(fontWeight: FontWeight.w600)),
                       ),
                       Text("Select", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13))
                     ],
                   ),
                ),
                
                const SizedBox(height: 120),
              ],
            ),
          ),
          
          // Bottom Payment Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))]
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Savings Tip
                  if (deliveryFee == 0)
                     Container(
                       margin: const EdgeInsets.only(bottom: 12),
                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                       decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                       child: Text("You saved ₹40 on delivery!", style: TextStyle(fontSize: 12, color: Colors.green[700], fontWeight: FontWeight.bold)),
                     ),

                  ElevatedButton(
                    onPressed: () async {
                      if (cartItems.isEmpty) return;
                      
                      try {
                        await ref.read(ordersServiceProvider).placeOrder(cartItems, grandTotal);
                        cartNotifier.clear();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order placed successfully!')),
                          );
                          // context.go('/orders');
                        }
                      } catch (e) {
                         if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to place order: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("₹${grandTotal.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                        const Row(
                          children: [
                            Text("Place Order", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 20)
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30), // Lift above floating nav
        ],
      ),
    );
  }
  
  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }

  Widget _billRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
        Text("₹${value.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
