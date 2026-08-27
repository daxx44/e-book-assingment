import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/services/download_service.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/widgets/library/realistic_book_visual.dart';
import 'package:get/get.dart';

class DownloadProgressSheet extends StatelessWidget {
  const DownloadProgressSheet({super.key, required this.ebook});

  final Ebook ebook;

  @override
  Widget build(BuildContext context) {
    final service = Get.find<DownloadService>();

    return Obx(() {
      final progress = service.activeProgress[ebook.id] ?? 0.02;
      final stage = service.activeStage[ebook.id] ?? 'Preparing download...';
      final percent = (progress * 100).clamp(0, 100).round();

      return Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3A2620), Color(0xFF261612)],
            ),
            border: Border.all(color: LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.65)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    RealisticBookVisual(ebook: ebook, width: 48, height: 72, onShelf: true),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Downloading',
                            style: AppTypography.label(
                              fontSize: 12,
                              color: LibraryShelfTheme.navActive,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ebook.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.headline(
                              fontSize: 16,
                              color: LibraryShelfTheme.headerText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress >= 1 ? 1 : progress,
                    minHeight: 8,
                    backgroundColor: LibraryShelfTheme.shelfShadow.withValues(alpha: 0.5),
                    color: LibraryShelfTheme.navActive,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        stage,
                        style: AppTypography.body(
                          fontSize: 13,
                          color: LibraryShelfTheme.headerMuted,
                        ),
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: AppTypography.label(
                        fontSize: 13,
                        color: LibraryShelfTheme.headerText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
