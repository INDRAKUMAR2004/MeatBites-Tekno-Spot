import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/colors.dart';
import '../widgets/banner_widget.dart';
import '../widgets/bestseller_row_widget.dart';
import '../widgets/category_section_widget.dart';
import '../widgets/explore_category_grid_widget.dart';
import '../widgets/featured_collections_widget.dart';
import '../widgets/flash_sale_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Sticky Header
          SliverAppBar(
            pinned: true,
            floating: false,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            titleSpacing: 0,
            toolbarHeight: 70,
            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     children: [
                       Icon(LucideIcons.mapPin, color: AppColors.primary, size: 18),
                       SizedBox(width: 6),
                       Text('Home', style: TextStyle(
                         color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800
                       )),
                       Icon(Icons.keyboard_arrow_down, color: Colors.black)
                     ],
                   ),
                   Padding(
                     padding: EdgeInsets.only(left: 24),
                     child: Text('A1, B Block Rd, Sector 63, Noida', 
                       style: TextStyle(color: Colors.grey, fontSize: 12, overflow: TextOverflow.ellipsis),
                     ),
                   )
                ],
              ),
            ),
            actions: [
               Container(
                 margin: const EdgeInsets.only(right: 16),
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                 child: const Icon(LucideIcons.search, color: Colors.black, size: 22),
               ),
               Container(
                 margin: const EdgeInsets.only(right: 16),
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                 child: const Icon(LucideIcons.user, color: Colors.black, size: 22),
               ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Container(height: 1, color: Colors.grey[100]), // Divider
            ),
          ),
          
          // Content
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              
              // 1. Horizontal Category Circles (Stories)
              const CategorySectionWidget(),
              const SizedBox(height: 20),
              
              // 2. Banner
              const BannerWidget(),
              const SizedBox(height: 32),

              // 3. Flash Sale (Moved Below)
              
              // 4. Section Title: Shop by Category
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                     Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4))),
                     const SizedBox(width: 8),
                     const Text('Shop by Category', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.secondary, letterSpacing: -0.5
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              
              // 5. Explore Grid
              const SizedBox(height: 10), // grid has padding
            ]),
          ),
          
          const ExploreCategoryGridWidget(),
          
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 32),
              
              // 3. Flash Sale (Moved Here)
              const FlashSaleWidget(),
              const SizedBox(height: 32),
              
               // 6. Featured Collections (New)
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                     Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4))),
                     const SizedBox(width: 8),
                     const Text('Curated Collections', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.secondary, letterSpacing: -0.5
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const FeaturedCollectionsWidget(),
              const SizedBox(height: 32),

              
               // 7. Section Title: Bestsellers
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                         Container(width: 4, height: 24, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4))),
                         const SizedBox(width: 8),
                         const Text('Bestsellers', style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.secondary, letterSpacing: -0.5
                        )),
                      ],
                    ),
                    const Text('See All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13))
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // 8. Bestsellers List
              const BestsellerRowWidget(),
              
              const SizedBox(height: 40),
              
              // Trust Badges
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1), // Light amber/cream
                  borderRadius: BorderRadius.circular(16)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Column(
                      children: [
                        Icon(LucideIcons.shieldCheck, size: 28, color: Colors.orange),
                        SizedBox(height: 8),
                        Text('Antibiotic\nFree', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    // ignore: deprecated_member_use
                    Container(height: 30, width: 1, color: Colors.orange.withOpacity(0.3)),
                    const Column(
                      children: [
                        Icon(LucideIcons.thermometerSnowflake, size: 28, color: Colors.blue),
                        SizedBox(height: 8),
                        Text('Cold Chain\nSupply', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    // ignore: deprecated_member_use
                    Container(height: 30, width: 1, color: Colors.orange.withOpacity(0.3)),
                    const Column(
                      children: [
                        Icon(LucideIcons.checkCircle, size: 28, color: Colors.green),
                        SizedBox(height: 8),
                         Text('FSSAI\nCertified', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ])
          )
        ],
      ),
    );
  }
}
