import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/colors.dart';
// import '../constants/data.dart'; // No longer used for products
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';

class BestsellerRowWidget extends ConsumerWidget {
  const BestsellerRowWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestsellersAsync = ref.watch(bestsellersProvider);

    return bestsellersAsync.when(
      data: (bestsellers) => SizedBox(
        height: 280,
        child: bestsellers.isEmpty
            ? const Center(child: Text("No bestsellers yet"))
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: bestsellers.length,
                itemBuilder: (context, index) {
                  final item = bestsellers[index];
                  return Container(
                    width: 170,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [AppColors.cardShadow],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20)),
                              child: Image.asset(
                                item.image,
                                width: 170,
                                height: 130, // Taller image
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[200], height: 130),
                              ),
                            ),
                            if (item.discountPercentage != null)
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: const BoxDecoration(
                                    color:
                                        Color(0xFFFFC107), // Amber for discount
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(12)),
                                  ),
                                  child: Text('${item.discountPercentage}% OFF',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800)),
                                ),
                              ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(LucideIcons.zap,
                                        size: 10, color: Colors.orange),
                                    const SizedBox(width: 2),
                                    Text(item.deliveryTime,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Info Section
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    height: 1.2),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Text('Net: ${item.netWeight}',
                                        style: const TextStyle(
                                            fontSize: 9,
                                            color: AppColors.textBody,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  const SizedBox(width: 4),
                                  Text('Gross: ${item.grossWeight}',
                                      style: const TextStyle(
                                          fontSize: 9, color: Colors.grey)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('₹${item.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15)),
                                      if (item.oldPrice != null)
                                        Text(
                                            '₹${item.oldPrice!.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontSize: 10,
                                                color: Colors.grey)),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      ref
                                          .read(cartProvider.notifier)
                                          .addToCart(item);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text('${item.name} added to cart'),
                                        backgroundColor: AppColors.primary,
                                        duration:
                                            const Duration(milliseconds: 800),
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: AppColors.primary),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color(0x1AB32624),
                                                blurRadius: 4,
                                                offset: Offset(0, 2))
                                          ]),
                                      child: const Text('ADD',
                                          style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12)),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
