import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/widgets/library/shelf_library_header.dart';

class SortMenu extends StatelessWidget {
  const SortMenu({
    super.key,
    required this.value,
    required this.onChanged,
    this.iconOnly = false,
    this.dark = false,
    this.showCurrentLabel = false,
    this.shelfStyle = false,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final bool iconOnly;
  final bool dark;
  final bool showCurrentLabel;
  final bool shelfStyle;

  static const options = <String, String>{
    'recent': 'Recently added',
    'title': 'Title A–Z',
    'author': 'Author A–Z',
  };

  @override
  Widget build(BuildContext context) {
    final fg = dark ? LibraryShelfTheme.headerText : AppColors.textPrimary;
    final muted = dark ? LibraryShelfTheme.headerMuted : AppColors.textSecondary;
    final label = options[value] ?? 'Sort';
    final menuBg = dark ? const Color(0xFF2E1C18) : AppColors.surface;
    final hoverColor = dark
        ? LibraryShelfTheme.navActive.withValues(alpha: 0.14)
        : AppColors.accent.withValues(alpha: 0.1);

    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: hoverColor,
        splashColor: hoverColor,
        popupMenuTheme: PopupMenuThemeData(
          color: menuBg,
          surfaceTintColor: Colors.transparent,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            side: BorderSide(
              color: dark
                  ? LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.65)
                  : AppColors.secondary.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
      child: PopupMenuButton<String>(
        tooltip: 'Sort library',
        onSelected: onChanged,
        offset: const Offset(0, 44),
        color: menuBg,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: BorderSide(
            color: dark
                ? LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.65)
                : AppColors.secondary.withValues(alpha: 0.4),
          ),
        ),
        itemBuilder: (context) => options.entries
            .map(
              (entry) => PopupMenuItem<String>(
                value: entry.key,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                height: 48,
                child: _SortMenuRow(
                  label: entry.value,
                  selected: entry.key == value,
                  dark: dark,
                ),
              ),
            )
            .toList(),
        child: iconOnly && shelfStyle
            ? const ShelfHeaderIconShell(icon: Icons.filter_list_rounded)
            : iconOnly
            ? _SortButtonShell(
                dark: dark,
                child: Icon(Icons.filter_list_rounded, size: 22, color: fg),
              )
            : _SortButtonShell(
                dark: dark,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.swap_vert_rounded, size: 18, color: muted),
                    const SizedBox(width: 6),
                    Text(
                      showCurrentLabel ? label : 'Sort',
                      style: AppTypography.label(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: fg,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.expand_more_rounded, size: 18, color: muted),
                  ],
                ),
              ),
      ),
    );
  }
}

class _SortMenuRow extends StatelessWidget {
  const _SortMenuRow({
    required this.label,
    required this.selected,
    required this.dark,
  });

  final String label;
  final bool selected;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final selectedBg = dark
        ? LibraryShelfTheme.navActive.withValues(alpha: 0.2)
        : AppColors.accent.withValues(alpha: 0.12);
    final selectedBorder = dark
        ? LibraryShelfTheme.navActive.withValues(alpha: 0.45)
        : AppColors.accent.withValues(alpha: 0.35);
    final textColor = selected
        ? (dark ? LibraryShelfTheme.headerText : AppColors.textPrimary)
        : (dark ? LibraryShelfTheme.headerMuted : AppColors.textSecondary);
    final checkColor = dark ? LibraryShelfTheme.navActive : AppColors.accent;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: selected ? selectedBg : Colors.transparent,
        border: selected ? Border.all(color: selectedBorder) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              child: selected
                  ? Icon(Icons.check_rounded, size: 18, color: checkColor)
                  : null,
            ),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortButtonShell extends StatelessWidget {
  const _SortButtonShell({
    required this.dark,
    required this.child,
    this.padding,
  });

  final bool dark;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: padding,
      decoration: BoxDecoration(
        gradient: dark
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF3A2620), Color(0xFF261612)],
              )
            : null,
        color: dark ? null : AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: dark
              ? LibraryShelfTheme.shelfShadow.withValues(alpha: 0.75)
              : AppColors.secondary.withValues(alpha: 0.55),
        ),
      ),
      child: Center(child: child),
    );
  }
}
