import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';
import '../constants/data.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/category_product_card.dart';

import '../providers/product_provider.dart';

// ... imports

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Find similar products (same category, excluding current)
    final allProductsAsync = ref.watch(productsProvider);
    final similarProducts = allProductsAsync.when(
      data: (products) => products
          .where((p) => p.category == product.category && p.id != product.id)
          .take(5)
          .toList(),
      loading: () => <Product>[],
      error: (_, __) => <Product>[],
    );
    final cartNotifier = ref.read(cartProvider.notifier);
    final cartItems = ref.watch(cartProvider);

    Widget _qtyBtn(IconData icon, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Slightly off-white for depth
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Premium Hero Header
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.black, size: 20),
                    onPressed: () => context.pop(),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(LucideIcons.share2,
                          color: Colors.black, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey[200]),
                      ),
                      // Gradient Overlay for text readability
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 120,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Content Body
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  // Negative offset to overlap image slightly
                  transform: Matrix4.translationValues(0, -20, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag Handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        // Title & Rating
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                  letterSpacing: -0.5,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.green.withOpacity(0.3))),
                              child: Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 16, color: Colors.green),
                                  const SizedBox(width: 4),
                                  Text('4.8',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.green[800],
                                          fontSize: 13)),
                                  Text(' (1.2k)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green[600],
                                          fontSize: 12)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text("Freshly Sourced • Antibiotic Free • Premium Cut",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),

                        const SizedBox(height: 24),

                        // Price Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('₹${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                    height: 1)),
                            const SizedBox(width: 12),
                            if (product.oldPrice != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                    '₹${product.oldPrice!.toStringAsFixed(0)}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey[400],
                                        fontWeight: FontWeight.w600)),
                              ),
                            const Spacer(),
                            if (product.discountPercentage != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      Color(0xFFFFC107),
                                      Color(0xFFFFB300)
                                    ]),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.orange.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4))
                                    ]),
                                child: Text(
                                    '${product.discountPercentage}% OFF',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        color: Colors.brown)),
                              )
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Specs Grid
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFEEEEEE)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSpecItem(LucideIcons.scale, "Net Wt.",
                                  product.netWeight),
                              Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.grey[300]),
                              _buildSpecItem(LucideIcons.package, "Gross Wt.",
                                  product.grossWeight),
                              Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.grey[300]),
                              _buildSpecItem(LucideIcons.timer, "Time",
                                  product.deliveryTime),
                              Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.grey[300]),
                              _buildSpecItem(
                                  LucideIcons.chefHat, "Serves", "3-4"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // "Best For" Section
                        const Text("Best Cooked As",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildCookingChip("Curry", LucideIcons.soup),
                            _buildCookingChip("Fry", LucideIcons.flame),
                            _buildCookingChip("Grill", LucideIcons.utensils),
                            _buildCookingChip("Roast", LucideIcons.sun),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Nutrition Facts
                        const Text("Nutrition (per 100g)",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 16),
                        _buildNutritionCard(),

                        const SizedBox(height: 32),

                        // Description
                        const Text("Description",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        Text(
                          "Experience the tenderest ${product.name}, hand-picked and sourced directly from antibiotic-free farms. Our meat is processed in state-of-the-art cold chain facilities to ensure maximum hygiene, texture, and taste. Ideal for slow-cooked curries or quick pan-fries.",
                          style: TextStyle(
                              color: Colors.grey[700],
                              height: 1.6,
                              fontSize: 15),
                        ),

                        const SizedBox(height: 32),

                        // Similar Products
                        if (similarProducts.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("You Might Also Like",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800)),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text("View All",
                                      style:
                                          TextStyle(color: AppColors.primary)))
                            ],
                          ),
                          SizedBox(
                            height: 280,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: similarProducts.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 200,
                                  margin: const EdgeInsets.only(right: 16),
                                  child: CategoryProductCard(
                                      item: similarProducts[index]),
                                );
                              },
                            ),
                          ),
                        ],

                        const SizedBox(height: 100), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 3. Glassmorphic Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      border:
                          const Border(top: BorderSide(color: Colors.white)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, -5))
                      ]),
                  child: SafeArea(
                    child: Row(
                      children: [
                        ...cartItems.map((item) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey[200]!),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.02),
                                        blurRadius: 4)
                                  ]),
                              child: Row(
                                children: [
                                  _qtyBtn(LucideIcons.minus,
                                      () => cartNotifier.decreaseQty(item.id)),
                                  const SizedBox(width: 16),
                                  Text('${item.qty}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18)),
                                  const SizedBox(width: 16),
                                  _qtyBtn(LucideIcons.plus,
                                      () => cartNotifier.increaseQty(item.id)),
                                ],
                              ),
                            )),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(cartProvider.notifier)
                                  .addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('${product.name} added'),
                                      backgroundColor: AppColors.primary));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                              shadowColor: AppColors.primary.withOpacity(0.5),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.shoppingBag, size: 20),
                                SizedBox(width: 10),
                                Text("Add to Cart",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 22, color: AppColors.primary.withOpacity(0.8)),
        const SizedBox(height: 6),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D2D2D))),
      ],
    );
  }

  Widget _buildCookingChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildNutritionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.blue[50]!.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue[100]!.withOpacity(0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutrient("Protein", "22g", Colors.blue),
          _buildNutrient("Total Fat", "5g", Colors.orange),
          _buildNutrient("Calories", "145", Colors.red),
        ],
      ),
    );
  }

  Widget _buildNutrient(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w900, color: color, fontSize: 16)),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700])),
      ],
    );
  }
}
