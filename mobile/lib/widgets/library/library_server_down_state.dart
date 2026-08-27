import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/widgets/upload/upload_form_widgets.dart';

class LibraryServerDownState extends StatelessWidget {
  const LibraryServerDownState({
    super.key,
    required this.onRetry,
    this.message,
  });

  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height * 0.55,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.55),
                ),
              ),
              child: Icon(
                Icons.dns_outlined,
                size: 42,
                color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Server unavailable',
              style: AppTypography.headline(
                fontSize: 20,
                color: LibraryShelfTheme.headerText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message ??
                  'We could not connect to your library server. Start the backend and try again.',
              style: AppTypography.body(
                fontSize: 14,
                color: LibraryShelfTheme.headerMuted,
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withValues(alpha: 0.18),
                border: Border.all(
                  color: LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HintRow(
                      icon: Icons.play_circle_outline_rounded,
                      text: 'Run the Rails API on port 3000',
                    ),
                    const SizedBox(height: 8),
                    _HintRow(
                      icon: Icons.wifi_rounded,
                      text: 'Use the same network for phone and PC',
                    ),
                    const SizedBox(height: 8),
                    _HintRow(
                      icon: Icons.settings_ethernet_rounded,
                      text: 'Check API host settings in api_config.dart',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ShelfUploadButton(
                label: 'Try again',
                icon: Icons.refresh_rounded,
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HintRow extends StatelessWidget {
  const _HintRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: LibraryShelfTheme.navActive),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTypography.body(
              fontSize: 13,
              color: LibraryShelfTheme.headerMuted,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
