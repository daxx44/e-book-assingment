import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/core/utils/app_haptics.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/models/recent_read_entry.dart';
import 'package:frontend/widgets/library/bookshelf_row.dart';
import 'package:frontend/widgets/library/realistic_book_visual.dart';
import 'package:frontend/widgets/library/wooden_shelf_plank.dart';
import 'package:frontend/widgets/scale_on_press.dart';
import 'package:intl/intl.dart';

class RecentlyReadSection extends StatelessWidget {
  const RecentlyReadSection({
    super.key,
    required this.items,
    required this.ebooksById,
    required this.onOpen,
    required this.onContinue,
    this.shelfStyle = false,
  });

  final List<RecentReadItem> items;
  final Map<int, Ebook> ebooksById;
  final void Function(Ebook ebook) onOpen;
  final void Function(Ebook ebook) onContinue;
  final bool shelfStyle;

  @override
  Widget build(BuildContext context) {
    final books = items
        .map((item) => (item, ebooksById[item.ebookId]))
        .where((pair) => pair.$2 != null)
        .toList();

    if (books.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final titleColor = shelfStyle ? LibraryShelfTheme.headerText : null;
    final accentColor = shelfStyle ? LibraryShelfTheme.navActive : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            shelfStyle ? AppSpacing.sm : AppSpacing.md,
            AppSpacing.md,
            0,
          ),
          child: Row(
            children: [
              Text(
                'Continue Reading',
                style: theme.textTheme.titleMedium?.copyWith(color: titleColor),
              ),
              const Spacer(),
              Icon(Icons.play_circle_outline_rounded, size: 22, color: accentColor),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: ShelfMetrics.continueReadingStripHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: books.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = books[index].$1;
              final ebook = books[index].$2!;
              return _ContinueReadingCard(
                ebook: ebook,
                item: item,
                onTap: () {
                  AppHaptics.light();
                  onContinue(ebook);
                },
                onOpenDetails: () => onOpen(ebook),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  const _ContinueReadingCard({
    required this.ebook,
    required this.item,
    required this.onTap,
    required this.onOpenDetails,
  });

  final Ebook ebook;
  final RecentReadItem item;
  final VoidCallback onTap;
  final VoidCallback onOpenDetails;

  String get _timeLabel {
    final now = DateTime.now();
    final diff = now.difference(item.readAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat.MMMd().format(item.readAt);
  }

  @override
  Widget build(BuildContext context) {
    final bookWidth = ShelfMetrics.continueBookWidth;
    final bookHeight = ShelfMetrics.resolvedBookHeight(bookWidth);
    final restInset = ShelfMetrics.bookRestInset;

    return ScaleOnPress(
      onTap: onTap,
      scale: 0.97,
      child: SizedBox(
        width: 152,
        height: ShelfMetrics.continueReadingStripHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: bookHeight + restInset,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: WoodenShelfPlank(showBrackets: false),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: restInset,
                    child: Align(
                      child: RealisticBookVisual(
                        ebook: ebook,
                        width: bookWidth,
                        height: bookHeight,
                        progress: item.progress,
                        onShelf: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShelfWallLabel(
                    ebook: ebook,
                    progressLabel: '${item.progressPercent}% · $_timeLabel',
                    showTitle: true,
                    compact: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tap to continue',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: LibraryShelfTheme.navActive,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: onOpenDetails,
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: LibraryShelfTheme.headerMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
