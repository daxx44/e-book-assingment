import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/core/utils/app_haptics.dart';

Future<bool?> showDeleteConfirmationDialog(BuildContext context, String title) {
  AppHaptics.light();
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2E1C18), LibraryShelfTheme.woodMid, LibraryShelfTheme.woodDark],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
            border: Border(
              top: BorderSide(color: const Color(0xFFFF8A80).withValues(alpha: 0.35)),
            ),
            boxShadow: const [
              BoxShadow(color: Color(0x66000000), blurRadius: 28, offset: Offset(0, -6)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB3261E).withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFF8A80).withValues(alpha: 0.35)),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFFF8A80),
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Delete ebook?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: LibraryShelfTheme.headerText,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: LibraryShelfTheme.headerMuted,
                          height: 1.45,
                        ),
                    children: [
                      const TextSpan(text: 'Remove '),
                      TextSpan(
                        text: '"$title"',
                        style: TextStyle(
                          color: LibraryShelfTheme.headerText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: ' from your library? This cannot be undone.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      AppHaptics.medium();
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.delete_forever_rounded, size: 20),
                    label: const Text('Delete'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFB3261E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.35)),
                      backgroundColor: Colors.white.withValues(alpha: 0.04),
                      foregroundColor: LibraryShelfTheme.headerText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
