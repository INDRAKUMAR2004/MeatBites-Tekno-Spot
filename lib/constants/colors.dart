import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFB32624);
  static const Color secondary = Color(0xFF1A1A1A); // Darker black for text
  static const Color background = Color(0xFFF9FAFB); // Very light grey surface
  static const Color surface = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFF3F4F6);
  static const Color textBody = Color(0xFF6B7280);
  
  static const BoxShadow softShadow = BoxShadow(
    color: Color(0x0D000000), // Very light shadow
    blurRadius: 10,
    offset: Offset(0, 4),
    spreadRadius: 0,
  );
  
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 12,
    offset: Offset(0, 6),
    spreadRadius: -2,
  );
}
