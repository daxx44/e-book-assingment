import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_typography.dart';

/// Reading-focused palette and typography matching the premium reader mockup.
class ReaderTheme {
  ReaderTheme._();

  static const Color toolbarBackground = Color(0xFFF3F1EE);
  static const Color canvasBackground = Color(0xFFFAF8F5);
  static const Color canvasBackgroundDeep = Color(0xFFF5F0E8);
  static const Color footerBackground = Color(0xFFF0EBE3);
  static const Color chapterLabel = Color(0xFF8B7355);
  static const Color bodyText = Color(0xFF3D3632);
  static const Color progressTrack = Color(0xFFE0D8D0);
  static const Color progressFill = Color(0xFF6D4C41);
  static const Color iconColor = Color(0xFF2C2420);
  static const Color borderColor = Color(0xFFD9CFC4);
  static const Color accent = Color(0xFFB8956E);

  static const LinearGradient canvasGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [canvasBackground, canvasBackgroundDeep],
  );

  static TextStyle get titleSerif => AppTypography.headline(
        fontSize: 24,
        color: bodyText,
        height: 1.2,
      );

  static TextStyle get authorStyle => AppTypography.body(
        fontSize: 14,
        color: chapterLabel,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get chapterLabelStyle => AppTypography.label(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: chapterLabel,
        letterSpacing: 1.1,
      );

  static TextStyle bodySerif(double fontSize) => AppTypography.body(
        fontSize: fontSize,
        color: bodyText,
        height: 1.75,
      );

  static TextStyle get footerPageStyle => AppTypography.headline(
        fontSize: 20,
        color: bodyText,
      );

  static TextStyle get footerLabelStyle => AppTypography.label(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: chapterLabel,
        letterSpacing: 0.4,
      );

  static TextStyle get footerPercentStyle => AppTypography.label(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: chapterLabel,
      );

  static TextStyle get toolbarTitleStyle => AppTypography.headline(
        fontSize: 15,
        color: bodyText,
        fontWeight: FontWeight.w600,
      );
}
