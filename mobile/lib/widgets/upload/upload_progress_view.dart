import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';

class UploadProgressView extends StatelessWidget {
  const UploadProgressView({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).clamp(0, 100).toStringAsFixed(0);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 108,
              height: 108,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 108,
                    height: 108,
                    child: CircularProgressIndicator(
                      value: progress > 0 ? progress : null,
                      strokeWidth: 5,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      color: LibraryShelfTheme.navActive,
                    ),
                  ),
                  Icon(
                    Icons.cloud_upload_rounded,
                    size: 40,
                    color: LibraryShelfTheme.navActive.withValues(alpha: 0.9),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Uploading to your shelf…',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: LibraryShelfTheme.headerText,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '$percent% complete',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: LibraryShelfTheme.headerMuted,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress > 0 ? progress : null,
                minHeight: 6,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                color: LibraryShelfTheme.navActive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
