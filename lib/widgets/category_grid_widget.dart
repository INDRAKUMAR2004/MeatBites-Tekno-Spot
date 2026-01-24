import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';
import '../constants/data.dart';

class CategoryGridWidget extends StatelessWidget {
  const CategoryGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: CATEGORIES.map((item) {
          // Calculate width for 3 items per row roughly, accounting for spacing
          // (Screen Width - Padding - Spacing) / 3
          // For simplicity in Wrap, we can just use a fixed width fraction or layout builder.
          // RN used width: "30%".
          
          return LayoutBuilder(
            builder: (context, constraints) {
               // A bit of a hack for Wrap to get exact 33% like flexbox, 
               // but simpler to just use a fixed sized container or GridView.
               // Let's use a fixed width container that roughly fits.
               // But to be responsive, let's use MediaQuery width.
               final double screenWidth = MediaQuery.of(context).size.width;
               final double itemWidth = (screenWidth - 32 - 24) / 3; // 32 pad, 24 gap (12*2)

               return GestureDetector(
                onTap: () {
                   context.push('/categories?category=${item.id}');
                },
                child: Container(
                  width: itemWidth,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Column(
                    children: [
                      Text(item.image, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 6),
                      Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
          );
        }).toList(),
      ),
    );
  }
}
