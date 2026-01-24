import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/category.dart';

class CategoryCarousel extends StatelessWidget {
  final List<Category> categories;
  final String selectedId;
  final ValueChanged<String> onSelect;

  const CategoryCarousel({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104, // more space (prevents overflow)
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat.id == selectedId;

          return InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => onSelect(cat.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              width: isSelected ? 210 : 190, // wider so text fits
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: isSelected ? AppColors.primary : Colors.white,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[200]!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isSelected ? 0.10 : 0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Colors.white.withOpacity(0.25)
                            : Colors.grey[200]!,
                      ),
                      image: DecorationImage(
                        image: cat.image.startsWith('http')
                            ? NetworkImage(cat.image)
                            : AssetImage(cat.image) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat.name,
                          maxLines: 2, // IMPORTANT
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.15,
                            fontWeight: FontWeight.w900,
                            color: isSelected ? Colors.white : Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isSelected ? "Selected" : "Tap to view",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white.withOpacity(0.90)
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: isSelected ? Colors.white : AppColors.primary,
                    size: 18,
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
