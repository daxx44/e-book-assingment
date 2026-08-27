import 'package:flutter/material.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/widgets/library/shelf_book_card.dart';
import 'package:frontend/widgets/library/wooden_shelf_plank.dart';

/// One row of books resting on a wooden shelf, with catalog labels on the wall below.
class BookshelfRow extends StatelessWidget {
  const BookshelfRow({
    super.key,
    required this.books,
    required this.booksPerRow,
    required this.onOpenDetails,
    required this.onRead,
    required this.onDownload,
    required this.onDelete,
  });

  final List<Ebook> books;
  final int booksPerRow;
  final void Function(Ebook) onOpenDetails;
  final void Function(Ebook) onRead;
  final void Function(Ebook) onDownload;
  final void Function(Ebook) onDelete;

  @override
  Widget build(BuildContext context) {
    final bookHeight = ShelfMetrics.bookHeightFor(context, booksPerRow);
    final restInset = ShelfMetrics.bookRestInset;
    final rowHeight = bookHeight + restInset;

    return Column(
      children: [
        SizedBox(
          height: rowHeight,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: WoodenShelfPlank(),
              ),
              Positioned(
                left: ShelfMetrics.rowHorizontalPadding,
                right: ShelfMetrics.rowHorizontalPadding,
                bottom: restInset,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final ebook in books)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ShelfMetrics.columnGap / 2,
                          ),
                          child: ShelfBookCard(
                            key: ValueKey('shelf-book-${ebook.id}'),
                            ebook: ebook,
                            bookHeight: bookHeight,
                            onTap: () => onOpenDetails(ebook),
                            onRead: () => onRead(ebook),
                            onDownload: () => onDownload(ebook),
                            onDelete: () => onDelete(ebook),
                          ),
                        ),
                      ),
                    for (var i = books.length; i < booksPerRow; i++)
                      const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final ebook in books)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ShelfMetrics.columnGap / 2,
                    ),
                    child: ShelfWallLabel(ebook: ebook, showTitle: true),
                  ),
                ),
              for (var i = books.length; i < booksPerRow; i++)
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}

/// Catalog-style label on the wall directly beneath each book on the shelf.
class ShelfWallLabel extends StatelessWidget {
  const ShelfWallLabel({
    super.key,
    required this.ebook,
    this.progressLabel,
    this.showTitle = false,
    this.maxDescriptionLines = 2,
    this.compact = false,
  });

  final Ebook ebook;
  final String? progressLabel;
  final bool showTitle;
  final int maxDescriptionLines;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDescription = ebook.description?.trim().isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showTitle) ...[
          Text(
            ebook.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              color: LibraryShelfTheme.headerText,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
        ],
        if (!compact && hasDescription) ...[
          Text(
            ebook.description!.trim(),
            maxLines: maxDescriptionLines,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.95),
              height: 1.35,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 5),
        ],
        if (!compact) ...[
          Text(
            _metaLine,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.82),
              fontSize: 10,
              height: 1.3,
            ),
          ),
        ],
        if (progressLabel != null) ...[
          SizedBox(height: compact ? 2 : 4),
          Text(
            progressLabel!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: LibraryShelfTheme.navActive,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ],
    );
  }

  String get _metaLine {
    final parts = <String>[ebook.fileTypeLabel, ebook.formattedUploadDate];
    if (ebook.fileSize != null && ebook.fileSize! > 0) {
      parts.add(ebook.formattedFileSize);
    }
    return parts.join(' · ');
  }
}
