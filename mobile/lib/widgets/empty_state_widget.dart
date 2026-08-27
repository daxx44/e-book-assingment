import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/widgets/empty_illustration.dart';
import 'package:frontend/widgets/primary_button.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.illustration,
    this.shelfStyle = false,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? illustration;
  final bool shelfStyle;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              illustration ?? const EmptyIllustration(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                style: shelfStyle
                    ? AppTypography.headline(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: LibraryShelfTheme.headerText,
                      )
                    : Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: shelfStyle
                    ? AppTypography.body(
                        fontSize: 14,
                        color: LibraryShelfTheme.headerMuted,
                        height: 1.45,
                      )
                    : Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: 240,
                  child: PrimaryButton(label: actionLabel!, onPressed: onAction, icon: Icons.add_rounded),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
