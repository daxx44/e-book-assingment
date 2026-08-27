import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/app_haptics.dart';
import 'package:get/get.dart';

enum FeedbackType { success, error, warning, info }

class AppFeedback {
  AppFeedback._();

  static void success(String title, {String? message}) {
    AppHaptics.success();
    _show(title, message: message, type: FeedbackType.success);
  }

  static void error(String title, {String? message}) {
    AppHaptics.error();
    _show(title, message: message, type: FeedbackType.error);
  }

  static void warning(String title, {String? message}) {
    AppHaptics.light();
    _show(title, message: message, type: FeedbackType.warning);
  }

  static void info(String title, {String? message}) {
    AppHaptics.selection();
    _show(title, message: message, type: FeedbackType.info);
  }

  static void _show(String title, {String? message, required FeedbackType type}) {
    final (icon, color) = switch (type) {
      FeedbackType.success => (Icons.check_circle_rounded, const Color(0xFF4CAF50)),
      FeedbackType.error => (Icons.error_outline_rounded, AppColors.error),
      FeedbackType.warning => (Icons.warning_amber_rounded, const Color(0xFFFF9800)),
      FeedbackType.info => (Icons.info_outline_rounded, AppColors.accent),
    };

    Get.snackbar(
      title,
      message ?? '',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(AppSpacing.md),
      borderRadius: AppSpacing.radiusMd,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 450),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      backgroundColor: AppColors.primaryDark,
      colorText: Colors.white,
      icon: Icon(icon, color: color, size: 28),
      shouldIconPulse: type == FeedbackType.success,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      barBlur: 8,
      overlayBlur: 0,
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      messageText: message == null || message.isEmpty
          ? null
          : Text(
              message,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.88), fontSize: 13),
            ),
    );
  }
}
