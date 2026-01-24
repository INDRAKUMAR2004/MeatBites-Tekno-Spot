import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';
import '../constants/data.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_provider.dart';

class CategorySectionWidget extends ConsumerWidget {
  const CategorySectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return SizedBox(
      height: 120, // Increased height for larger circles + text
      child: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (categories) {
          if (categories.isEmpty) return const SizedBox();
    
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final item = categories[index];
            return Container(
              margin: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () {
                  context.push('/categories?category=${item.id}');
                },
                borderRadius: BorderRadius.circular(50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Story Ring Gradient
                    Container(
                      padding: const EdgeInsets.all(3), // Border width
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFF55A42), Color(0xFFFFC107)], // Swiggy/Zomato brand gradient (Orange->Yellow)
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(3), // White gap
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              image: item.image.startsWith('http')
                                  ? NetworkImage(item.image)
                                  : AssetImage(item.image) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: AppColors.secondary,
                        letterSpacing: -0.3
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ));
  }
}
