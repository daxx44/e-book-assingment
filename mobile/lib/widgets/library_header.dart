import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/app_colors.dart';

/// @deprecated Bookshelf divider removed from library grid layout.
class ShelfDivider extends StatelessWidget {
  const ShelfDivider({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class LibraryHeader extends StatelessWidget {
  const LibraryHeader({
    super.key,
    required this.bookCount,
    required this.onSearch,
    required this.onFilter,
    required this.sortMenu,
    this.onMenu,
  });

  final int bookCount;
  final VoidCallback onSearch;
  final VoidCallback onFilter;
  final Widget sortMenu;
  final VoidCallback? onMenu;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get _collectionLabel {
    if (bookCount == 0) return 'Your collection is empty';
    if (bookCount == 1) return '1 book in your collection';
    return '$bookCount books in your collection';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.secondary.withValues(alpha: 0.45)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          MediaQuery.paddingOf(context).top + AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (onMenu != null) ...[
                  _HeaderIconButton(
                    icon: Icons.menu_rounded,
                    tooltip: 'Menu',
                    onPressed: onMenu!,
                  ),
                  const SizedBox(width: AppSpacing.sm + 4),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.textMuted,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'My Library',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                sortMenu,
              ],
            ),
            const SizedBox(height: AppSpacing.sm + 4),
            Text(
              _collectionLabel,
              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Material(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: InkWell(
                onTap: onSearch,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.55)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, size: 22, color: AppColors.textMuted),
                      const SizedBox(width: AppSpacing.sm + 4),
                      Expanded(
                        child: Text(
                          'Search title, author, or format',
                          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.55)),
            ),
            child: Icon(icon, size: 22, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

class PremiumSearchField extends StatefulWidget {
  const PremiumSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.autofocus = false,
    this.hintText = 'Search title, author, or file',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool autofocus;
  final String hintText;

  @override
  State<PremiumSearchField> createState() => _PremiumSearchFieldState();
}

class _PremiumSearchFieldState extends State<PremiumSearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
        ),
      ),
    );
  }
}
