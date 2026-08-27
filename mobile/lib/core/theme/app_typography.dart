import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  /// Headline — Libre Caslon Text for titles and headings.
  static TextStyle headline({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double height = 1.25,
    double? letterSpacing,
  }) {
    return GoogleFonts.libreCaslonText(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Body — Hanken Grotesk for paragraphs and reading content.
  static TextStyle body({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double height = 1.5,
    double? letterSpacing,
  }) {
    return GoogleFonts.hankenGrotesk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Label — Hanken Grotesk for UI labels and metadata.
  static TextStyle label({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w500,
    Color color = AppColors.textSecondary,
    double height = 1.4,
    double? letterSpacing,
  }) {
    return GoogleFonts.hankenGrotesk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextTheme textTheme = TextTheme(
    displayLarge: headline(fontSize: 34, letterSpacing: -0.5),
    displayMedium: headline(fontSize: 28, letterSpacing: -0.3),
    headlineLarge: headline(fontSize: 24),
    headlineMedium: headline(fontSize: 20),
    headlineSmall: headline(fontSize: 18),
    titleLarge: headline(fontSize: 17, fontWeight: FontWeight.w600),
    titleMedium: headline(fontSize: 15, fontWeight: FontWeight.w600),
    titleSmall: headline(fontSize: 13, fontWeight: FontWeight.w600, height: 1.3),
    bodyLarge: body(fontSize: 16, color: AppColors.textPrimary, height: 1.5),
    bodyMedium: body(fontSize: 14, color: AppColors.textSecondary, height: 1.45),
    bodySmall: body(fontSize: 12, color: AppColors.textMuted, height: 1.4),
    labelLarge: label(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    labelMedium: label(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
    labelSmall: label(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textMuted, letterSpacing: 0.2),
  );
}
