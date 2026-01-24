import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';
import '../constants/data.dart';

class ExploreCategoryGridWidget extends StatelessWidget {
  const ExploreCategoryGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // We'll use a subset of categories or the full list
    final categories = CATEGORIES;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ), // 3 Column grid
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = categories[index];
            return InkWell(
              onTap: () => context.push('/categories?category=${item.id}'),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                             image: item.image.startsWith('http')
                                 ? NetworkImage(item.image)
                                 : AssetImage(item.image) as ImageProvider,
                             fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      item.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: categories.length,
        ),
      ),
    );
  }
}
