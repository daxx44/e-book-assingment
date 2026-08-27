import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/core/utils/app_haptics.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/widgets/highlighted_text.dart';
import 'package:frontend/widgets/library/realistic_book_visual.dart';
import 'package:frontend/widgets/upload/upload_form_widgets.dart';
import 'package:shimmer/shimmer.dart';

class ShelfSearchField extends StatefulWidget {
  const ShelfSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.autofocus = false,
    this.hintText = 'Title, author, or filename',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool autofocus;
  final String hintText;

  @override
  State<ShelfSearchField> createState() => _ShelfSearchFieldState();
}

class _ShelfSearchFieldState extends State<ShelfSearchField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});
  void _onFocusChanged() => setState(() => _focused = _focusNode.hasFocus);

  @override
  Widget build(BuildContext context) {
    final borderColor = _focused
        ? LibraryShelfTheme.navActive.withValues(alpha: 0.65)
        : LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.85);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3A2620), Color(0xFF261612)],
        ),
        border: Border.all(color: borderColor, width: _focused ? 1.5 : 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            filled: false,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hoverColor: Colors.transparent,
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: LibraryShelfTheme.navActive,
            selectionColor: LibraryShelfTheme.navActive.withValues(alpha: 0.28),
            selectionHandleColor: LibraryShelfTheme.navActive,
          ),
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          style: const TextStyle(
            color: LibraryShelfTheme.headerText,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
          cursorWidth: 1.5,
          keyboardAppearance: Brightness.dark,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            filled: false,
            fillColor: Colors.transparent,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.8),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(
                Icons.search_rounded,
                size: 22,
                color: _focused ? LibraryShelfTheme.navActive : LibraryShelfTheme.headerMuted,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, color: LibraryShelfTheme.headerMuted, size: 20),
                    onPressed: () {
                      widget.controller.clear();
                      widget.onChanged('');
                    },
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
            isDense: true,
          ),
        ),
      ),
    );
  }
}

/// Compact shelf-style filter control for PDF, EPUB, etc.
class SearchFilterButton extends StatelessWidget {
  const SearchFilterButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LibraryShelfTheme.shelfMid.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          AppHaptics.selection();
          onTap();
        },
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: LibraryShelfTheme.shelfShadow.withValues(alpha: 0.7)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: LibraryShelfTheme.headerMuted),
                const SizedBox(width: 7),
              ],
              Text(
                label,
                style: AppTypography.label(
                  fontSize: 13,
                  color: LibraryShelfTheme.headerText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchRecentPanel extends StatelessWidget {
  const SearchRecentPanel({
    super.key,
    required this.terms,
    required this.onTap,
  });

  final List<String> terms;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.55)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < terms.length; i++) ...[
            if (i > 0) Divider(height: 1, color: LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.45)),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  AppHaptics.light();
                  onTap(terms[i]);
                },
                borderRadius: BorderRadius.vertical(
                  top: i == 0 ? const Radius.circular(12) : Radius.zero,
                  bottom: i == terms.length - 1 ? const Radius.circular(12) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  child: Row(
                    children: [
                      Icon(Icons.history_rounded, size: 18, color: LibraryShelfTheme.headerMuted),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          terms[i],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.body(
                            fontSize: 15,
                            color: LibraryShelfTheme.headerText,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.subdirectory_arrow_left_rounded,
                        size: 18,
                        color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SearchSectionTitle extends StatelessWidget {
  const SearchSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: AppTypography.headline(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: LibraryShelfTheme.headerText,
        ),
      ),
    );
  }
}

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    required this.ebook,
    required this.query,
    required this.onTap,
  });

  final Ebook ebook;
  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const bookW = 54.0;
    const bookH = 80.0;

    return Material(
      color: Colors.black.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          AppHaptics.light();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              RealisticBookVisual(ebook: ebook, width: bookW, height: bookH, onShelf: true),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HighlightedText(
                      text: ebook.title,
                      query: query,
                      maxLines: 2,
                      style: AppTypography.headline(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: LibraryShelfTheme.headerText,
                        height: 1.2,
                      ),
                      highlightBackground: LibraryShelfTheme.navActive.withValues(alpha: 0.28),
                      highlightColor: LibraryShelfTheme.headerText,
                    ),
                    const SizedBox(height: 4),
                    HighlightedText(
                      text: ebook.displayAuthor,
                      query: query,
                      maxLines: 1,
                      style: AppTypography.body(
                        fontSize: 13,
                        color: LibraryShelfTheme.headerMuted,
                      ),
                      highlightBackground: LibraryShelfTheme.navActive.withValues(alpha: 0.22),
                      highlightColor: LibraryShelfTheme.headerText,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      [ebook.fileTypeLabel, ebook.formattedUploadDate].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label(
                        fontSize: 11,
                        color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.65)),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchIdlePanel extends StatelessWidget {
  const SearchIdlePanel({
    super.key,
    required this.recentSearches,
    required this.onTermTap,
  });

  final List<String> recentSearches;
  final ValueChanged<String> onTermTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 4, AppSpacing.lg, 100),
      children: [
        const SearchSectionTitle('Browse by type'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SearchFilterButton(
              label: 'PDF',
              icon: Icons.picture_as_pdf_outlined,
              onTap: () => onTermTap('PDF'),
            ),
            SearchFilterButton(
              label: 'EPUB',
              icon: Icons.auto_stories_outlined,
              onTap: () => onTermTap('EPUB'),
            ),
            SearchFilterButton(
              label: 'Fiction',
              onTap: () => onTermTap('Fiction'),
            ),
            SearchFilterButton(
              label: 'Guide',
              onTap: () => onTermTap('Guide'),
            ),
          ],
        ),
        if (recentSearches.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          const SearchSectionTitle('Recent'),
          SearchRecentPanel(terms: recentSearches, onTap: onTermTap),
        ] else ...[
          const SizedBox(height: AppSpacing.xxl),
          const _SearchMessageState(
            icon: Icons.search_rounded,
            title: 'Search your library',
            message: 'Type above or pick a filter to get started.',
          ),
        ],
      ],
    );
  }
}

class SearchListShimmer extends StatelessWidget {
  const SearchListShimmer({super.key});

  static const _base = Color(0xFF241612);
  static const _highlight = Color(0xFF3D2B22);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 8, AppSpacing.lg, 100),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: _base,
        highlightColor: _highlight,
        child: Container(
          height: 96,
          decoration: BoxDecoration(
            color: _base,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return _SearchMessageState(
      icon: Icons.search_off_rounded,
      title: 'No matching books',
      message: query.trim().isEmpty
          ? 'Try another title, author, or filename.'
          : 'Nothing matched "$query". Try different keywords.',
    );
  }
}

class SearchErrorState extends StatelessWidget {
  const SearchErrorState({
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
            const _SearchMessageState(
              icon: Icons.cloud_off_outlined,
              title: 'Search unavailable',
              message: 'We could not reach your library right now.',
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.body(
                fontSize: 13,
                color: LibraryShelfTheme.headerMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: 180,
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

class _SearchMessageState extends StatelessWidget {
  const _SearchMessageState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.8)),
        const SizedBox(height: AppSpacing.md),
        Text(
          title,
          style: AppTypography.headline(
            fontSize: 18,
            color: LibraryShelfTheme.headerText,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          message,
          style: AppTypography.body(
            fontSize: 14,
            color: LibraryShelfTheme.headerMuted,
            height: 1.45,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
