import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';
import '../constants/data.dart';

class CategorySectionWidget extends StatelessWidget {
  const CategorySectionWidget({super.key});


  // Helper to get pastel colors for categories
  Color _getCategoryColor(int index) {
    final colors = [
       const Color(0xFFE3F2FD), // Blue
       const Color(0xFFFCE4EC), // Pink
       const Color(0xFFE8F5E9), // Green
       const Color(0xFFFFF3E0), // Orange
       const Color(0xFFF3E5F5), // Purple
       const Color(0xFFFFF8E1), // Amber
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120, // Increased height for larger circles + text
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: CATEGORIES.length,
        itemBuilder: (context, index) {
          final item = CATEGORIES[index];
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
                              image: AssetImage(item.icon),
                              fit: BoxFit.cover,
                            ),
                          ),
                          alignment: Alignment.center,
                        ),
                     ),
                   ),
                  const SizedBox(height: 8),
                  Text(
                    item.label,
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
      ),
    );
  }
}
