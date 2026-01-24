import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              height: 40, width: 40,
              decoration: BoxDecoration(
                color: Colors.red[50], // Brand tint
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/logo.png'),
              )
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'Delivering to',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                          letterSpacing: 0.5
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.primary)
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Home • Sector 63, Noida',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D2D2D)
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
               padding: const EdgeInsets.all(8),
               decoration: BoxDecoration(
                 color: Colors.grey[50],
                 shape: BoxShape.circle,
                 border: Border.all(color: Colors.grey[100]!)
               ),
               child: const Icon(LucideIcons.bell, color: Colors.black87, size: 18)
            ),
          ],
        ),
      ),
    );
  }
}
