import 'package:flutter/material.dart';
import 'package:frontend/controllers/downloads_controller.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/services/download_service.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/core/utils/app_haptics.dart';
import 'package:frontend/models/downloaded_ebook.dart';
import 'package:frontend/widgets/library/realistic_book_visual.dart';
import 'package:frontend/widgets/library/wooden_shelf_background.dart';
import 'package:get/get.dart';

class DownloadsScreen extends GetView<DownloadsController> {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LibraryShelfTheme.woodDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const WoodenShelfBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Downloads',
                        style: AppTypography.headline(
                          fontSize: 24,
                          color: LibraryShelfTheme.headerText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Text(
                          controller.items.isEmpty
                              ? 'Books saved to your device'
                              : '${controller.items.length} ${controller.items.length == 1 ? 'book' : 'books'} available offline',
                          style: AppTypography.body(
                            fontSize: 14,
                            color: LibraryShelfTheme.headerMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    final items = controller.items;
                    if (items.isEmpty) {
                      return const _DownloadsEmptyState();
                    }

                    return RefreshIndicator(
                      color: LibraryShelfTheme.navActive,
                      backgroundColor: LibraryShelfTheme.shelfMid,
                      onRefresh: controller.refresh,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 8, AppSpacing.lg, 24),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _DownloadedBookTile(
                            item: item,
                            onRead: () => controller.openReader(item),
                            onDelete: () => controller.remove(item),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadsEmptyState extends StatelessWidget {
  const _DownloadsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download_outlined,
              size: 48,
              color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.8),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No downloads yet',
              style: AppTypography.headline(
                fontSize: 18,
                color: LibraryShelfTheme.headerText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Download a book from your library to read it offline here.',
              style: AppTypography.body(
                fontSize: 14,
                color: LibraryShelfTheme.headerMuted,
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadedBookTile extends StatelessWidget {
  const _DownloadedBookTile({
    required this.item,
    required this.onRead,
    required this.onDelete,
  });

  final DownloadedEbook item;
  final VoidCallback onRead;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final visualEbook = Get.find<DownloadService>().toEbook(item);
    const bookW = 54.0;
    const bookH = 80.0;

    return Material(
      color: Colors.black.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.55)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    AppHaptics.light();
                    onRead();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                    child: Row(
                      children: [
                        RealisticBookVisual(
                          ebook: visualEbook,
                          width: bookW,
                          height: bookH,
                          onShelf: true,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.headline(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: LibraryShelfTheme.headerText,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.displayAuthor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.body(
                                  fontSize: 13,
                                  color: LibraryShelfTheme.headerMuted,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  _OfflineBadge(label: item.fileTypeLabel),
                                  Text(
                                    item.formattedFileSize,
                                    style: AppTypography.label(
                                      fontSize: 11,
                                      color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.9),
                                    ),
                                  ),
                                  Text(
                                    '·',
                                    style: AppTypography.label(
                                      fontSize: 11,
                                      color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.55),
                                    ),
                                  ),
                                  Text(
                                    item.formattedDownloadDate,
                                    style: AppTypography.label(
                                      fontSize: 11,
                                      color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, right: 2),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 72,
              color: LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.45),
            ),
            IconButton(
              tooltip: 'Remove download',
              onPressed: () {
                AppHaptics.light();
                onDelete();
              },
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 22,
                color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineBadge extends StatelessWidget {
  const _OfflineBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: LibraryShelfTheme.navActive.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: LibraryShelfTheme.navActive.withValues(alpha: 0.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.offline_pin_rounded,
            size: 12,
            color: LibraryShelfTheme.navActive.withValues(alpha: 0.95),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.label(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: LibraryShelfTheme.navActive,
            ),
          ),
        ],
      ),
    );
  }
}
