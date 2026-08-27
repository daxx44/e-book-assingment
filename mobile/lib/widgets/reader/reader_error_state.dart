import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/reader_theme.dart';

class ReaderErrorState extends StatelessWidget {
  const ReaderErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ReaderTheme.footerBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ReaderTheme.borderColor),
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                size: 38,
                color: ReaderTheme.chapterLabel,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Could not open book',
              style: ReaderTheme.titleSerif.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: ReaderTheme.authorStyle.copyWith(height: 1.45),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: 180,
              height: 48,
              child: FilledButton.icon(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: ReaderTheme.progressFill,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Try again'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
