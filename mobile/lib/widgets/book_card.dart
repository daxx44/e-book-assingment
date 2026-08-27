import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/app_haptics.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/widgets/cover_preview.dart';
import 'package:frontend/widgets/highlighted_text.dart';
import 'package:frontend/widgets/scale_on_press.dart';

enum BookCardAction { read, download, delete }

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.ebook,
    required this.onTap,
    required this.onDownload,
    required this.onDelete,
    this.onRead,
    this.highlightQuery = '',
    this.compact = false,
  });

  final Ebook ebook;
  final VoidCallback onTap;
  final VoidCallback onDownload;
  final VoidCallback onDelete;
  final VoidCallback? onRead;
  final String highlightQuery;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: '${ebook.title} by ${ebook.displayAuthor}',
      button: true,
      child: ScaleOnPress(
        onTap: () {
          AppHaptics.light();
          onTap();
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.secondary.withValues(alpha: 0.45)),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CoverPreview(
                        title: ebook.title,
                        subtitle: ebook.fileTypeLabel,
                        coverUrl: ebook.coverUrl,
                        compact: true,
                        showFormatBadge: false,
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 56,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.45),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: _FileTypeChip(label: ebook.fileTypeLabel),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: _BookMenuButton(
                          onSelected: (action) {
                            AppHaptics.selection();
                            switch (action) {
                              case BookCardAction.read:
                                (onRead ?? onTap)();
                              case BookCardAction.download:
                                onDownload();
                              case BookCardAction.delete:
                                onDelete();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HighlightedText(
                        text: ebook.title,
                        query: highlightQuery,
                        maxLines: 2,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      HighlightedText(
                        text: ebook.displayAuthor,
                        query: highlightQuery,
                        maxLines: 1,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _metadataLine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get _metadataLine {
    final parts = <String>[ebook.formattedUploadDate];
    if (ebook.fileSize != null && ebook.fileSize! > 0) {
      parts.add(ebook.formattedFileSize);
    }
    return parts.join(' · ');
  }
}

class _FileTypeChip extends StatelessWidget {
  const _FileTypeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
        ),
      ),
    );
  }
}

class _BookMenuButton extends StatelessWidget {
  const _BookMenuButton({required this.onSelected});

  final ValueChanged<BookCardAction> onSelected;

  static const _size = 24.0;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BookCardAction>(
      tooltip: 'Book options',
      padding: EdgeInsets.zero,
      offset: const Offset(0, _size + 4),
      splashRadius: 14,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.surface,
      elevation: 6,
      shadowColor: Colors.black26,
      onSelected: onSelected,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: BookCardAction.read,
          child: ListTile(
            leading: Icon(Icons.menu_book_outlined, size: 20),
            title: Text('Read'),
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
        ),
        PopupMenuItem(
          value: BookCardAction.download,
          child: ListTile(
            leading: Icon(Icons.download_outlined, size: 20),
            title: Text('Download'),
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
        ),
        PopupMenuItem(
          value: BookCardAction.delete,
          child: ListTile(
            leading: Icon(Icons.delete_outline, size: 20, color: AppColors.error),
            title: Text('Delete', style: TextStyle(color: AppColors.error)),
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.42),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        ),
        child: const SizedBox(
          width: _size,
          height: _size,
          child: Icon(Icons.more_horiz_rounded, size: 14, color: Colors.white),
        ),
      ),
    );
  }
}
