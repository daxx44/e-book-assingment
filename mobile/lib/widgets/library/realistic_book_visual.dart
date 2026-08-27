import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/models/ebook.dart';

/// Title, author, description, and file metadata for continue-reading labels.
class BookDetailsPanel extends StatelessWidget {
  const BookDetailsPanel({
    super.key,
    required this.ebook,
    this.shelfStyle = true,
    this.progressLabel,
    this.maxDescriptionLines = 2,
    this.compact = false,
  });

  final Ebook ebook;
  final bool shelfStyle;
  final String? progressLabel;
  final int maxDescriptionLines;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleColor = shelfStyle ? LibraryShelfTheme.headerText : null;
    final bodyColor = shelfStyle ? LibraryShelfTheme.headerMuted : null;
    final hasDescription = ebook.description?.trim().isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ebook.title,
          maxLines: compact ? 1 : 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            color: titleColor,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          ebook.displayAuthor,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(color: bodyColor),
        ),
        if (hasDescription) ...[
          const SizedBox(height: 4),
          Text(
            ebook.description!.trim(),
            maxLines: maxDescriptionLines,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: bodyColor,
              height: 1.35,
            ),
          ),
        ],
        const SizedBox(height: 5),
        Text(
          _metaLine,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: bodyColor?.withValues(alpha: 0.9),
            letterSpacing: 0.1,
          ),
        ),
        if (progressLabel != null) ...[
          const SizedBox(height: 4),
          Text(
            progressLabel!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: LibraryShelfTheme.navActive,
              fontWeight: FontWeight.w600,
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

/// Shared 3D book cover used on shelves and continue-reading rows.
class RealisticBookVisual extends StatelessWidget {
  const RealisticBookVisual({
    super.key,
    required this.ebook,
    this.width,
    this.height = 236,
    this.progress,
    this.onShelf = false,
  });

  final Ebook ebook;
  final double? width;
  final double height;
  final double? progress;
  final bool onShelf;

  @override
  Widget build(BuildContext context) {
    final palette = _ShelfBookPalette.forTitle(ebook.title);
    final hasCover = ebook.coverUrl != null && ebook.coverUrl!.isNotEmpty;
    final bookW = width ?? height / 1.46;

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: onShelf
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.42),
                  blurRadius: 7,
                  offset: const Offset(2, 2),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 1,
                  offset: const Offset(1, 0),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(3, 5),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: SizedBox(
        width: bookW,
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BookSpine(color: hasCover ? const Color(0xFF3A2E26) : palette.spine),
            Expanded(
              child: _BookCoverFace(
                ebook: ebook,
                palette: palette,
                hasCover: hasCover,
                progress: progress,
                onShelf: onShelf,
              ),
            ),
            const _BookPageEdge(),
          ],
        ),
      ),
    );
  }
}

class _BookCoverFace extends StatelessWidget {
  const _BookCoverFace({
    required this.ebook,
    required this.palette,
    required this.hasCover,
    this.progress,
    this.onShelf = false,
  });

  final Ebook ebook;
  final _ShelfBookPalette palette;
  final bool hasCover;
  final double? progress;
  final bool onShelf;

  static const _ornaments = [
    Icons.menu_book_rounded,
    Icons.landscape_rounded,
    Icons.explore_rounded,
    Icons.fingerprint_rounded,
    Icons.auto_stories_rounded,
    Icons.wb_sunny_outlined,
    Icons.psychology_outlined,
    Icons.nights_stay_outlined,
  ];

  IconData get _ornament {
    final hash = ebook.title.codeUnits.fold<int>(0, (v, c) => v + c);
    return _ornaments[hash % _ornaments.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = palette.lightText ? const Color(0xFF2C2420) : Colors.white;
    final mutedText = palette.lightText
        ? const Color(0xFF5C4E48)
        : Colors.white.withValues(alpha: 0.9);

    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(2)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasCover)
            CachedNetworkImage(
              imageUrl: ebook.coverUrl!,
              fit: BoxFit.cover,
              placeholder: (_, __) => ColoredBox(color: palette.background),
              errorWidget: (_, __, ___) => ColoredBox(color: palette.background),
            )
          else
            ColoredBox(color: palette.background),
          if (!hasCover)
            Center(
              child: Icon(
                _ornament,
                size: 52,
                color: textColor.withValues(alpha: palette.lightText ? 0.22 : 0.32),
              ),
            ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.3), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: hasCover ? 0.12 : 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          if (hasCover && !onShelf)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.55),
                  ],
                  stops: const [0, 0.42, 1],
                ),
              ),
            ),
          if (!onShelf)
            Padding(
              padding: const EdgeInsets.fromLTRB(9, 12, 9, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    ebook.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                      fontSize: 12,
                      shadows: hasCover || !palette.lightText
                          ? const [Shadow(color: Colors.black45, blurRadius: 4)]
                          : null,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    ebook.displayAuthor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: mutedText,
                      fontWeight: FontWeight.w500,
                      shadows: hasCover || !palette.lightText
                          ? const [Shadow(color: Colors.black38, blurRadius: 3)]
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          if (!onShelf)
            Positioned(
              top: 7,
              right: 7,
              child: _FormatBadge(label: ebook.fileTypeLabel),
            ),
          if (progress != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                child: LinearProgressIndicator(
                  value: progress!.clamp(0.0, 1.0),
                  minHeight: 4,
                  backgroundColor: Colors.black38,
                  color: LibraryShelfTheme.navActive,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BookSpine extends StatelessWidget {
  const _BookSpine({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 9,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(3)),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withValues(alpha: 0.45),
              color,
              color.withValues(alpha: 0.82),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookPageEdge extends StatelessWidget {
  const _BookPageEdge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 7,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(2)),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFD8D2CA), Color(0xFFF0EBE3), Color(0xFFB8B0A6)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            7,
            (_) => Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              color: Colors.black12,
            ),
          ),
        ),
      ),
    );
  }
}

class _FormatBadge extends StatelessWidget {
  const _FormatBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xCC2C2420),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: LibraryShelfTheme.headerText,
                fontWeight: FontWeight.w700,
                fontSize: 8,
                letterSpacing: 0.4,
              ),
        ),
      ),
    );
  }
}

class _ShelfBookPalette {
  const _ShelfBookPalette({
    required this.background,
    required this.spine,
    required this.lightText,
  });

  final Color background;
  final Color spine;
  final bool lightText;

  static const _palettes = [
    _ShelfBookPalette(background: Color(0xFF8B2A2A), spine: Color(0xFF4E1515), lightText: false),
    _ShelfBookPalette(background: Color(0xFF1E3D63), spine: Color(0xFF0F2035), lightText: false),
    _ShelfBookPalette(background: Color(0xFFE6D9C3), spine: Color(0xFFB09A78), lightText: true),
    _ShelfBookPalette(background: Color(0xFF2F4F38), spine: Color(0xFF1A2E21), lightText: false),
    _ShelfBookPalette(background: Color(0xFF5A3870), spine: Color(0xFF352045), lightText: false),
    _ShelfBookPalette(background: Color(0xFF2A5F5F), spine: Color(0xFF163838), lightText: false),
    _ShelfBookPalette(background: Color(0xFF6B442E), spine: Color(0xFF3D2618), lightText: false),
    _ShelfBookPalette(background: Color(0xFFC49A32), spine: Color(0xFF8A6820), lightText: false),
  ];

  static _ShelfBookPalette forTitle(String title) {
    final hash = title.codeUnits.fold<int>(0, (value, unit) => value + unit);
    return _palettes[hash % _palettes.length];
  }
}
