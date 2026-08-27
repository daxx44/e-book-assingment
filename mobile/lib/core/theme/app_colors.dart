import 'package:flutter/material.dart';

/// Warm, book-inspired palette for the premium ebook library UI.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFFF7F5F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFF0EBE3);
  static const Color primary = Color(0xFF6D4C41);
  static const Color primaryDark = Color(0xFF4E342E);
  static const Color accent = Color(0xFFC67B5C);
  static const Color accentLight = Color(0xFFE8B4A0);
  static const Color secondary = Color(0xFFD7CCC8);
  static const Color textPrimary = Color(0xFF2C2420);
  static const Color textSecondary = Color(0xFF6B5E58);
  static const Color textMuted = Color(0xFF9E8F88);
  static const Color shelfWood = Color(0xFF8D6E63);
  static const Color shelfShadow = Color(0xFF5D4037);
  static const Color error = Color(0xFFB3261E);
  static const Color shimmerBase = Color(0xFFE8E2DA);
  static const Color shimmerHighlight = Color(0xFFF5F1EC);

  static const List<List<Color>> coverGradients = [
    [Color(0xFF6D4C41), Color(0xFF8D6E63)],
    [Color(0xFF5D4037), Color(0xFF795548)],
    [Color(0xFF4E342E), Color(0xFF6D4C41)],
    [Color(0xFF8D6E63), Color(0xFFA1887F)],
    [Color(0xFF6D4C41), Color(0xFFBCAAA4)],
    [Color(0xFF5D4037), Color(0xFF8D6E63)],
    [Color(0xFF795548), Color(0xFFA1887F)],
    [Color(0xFF4E342E), Color(0xFF795548)],
  ];
}
