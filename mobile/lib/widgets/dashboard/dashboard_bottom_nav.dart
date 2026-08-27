import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/core/utils/app_haptics.dart';

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  static const _items = <({IconData outlined, IconData filled, String label})>[
    (
      outlined: Icons.auto_stories_outlined,
      filled: Icons.auto_stories_rounded,
      label: 'Library',
    ),
    (
      outlined: Icons.download_outlined,
      filled: Icons.download_rounded,
      label: 'Downloads',
    ),
    (
      outlined: Icons.info_outline_rounded,
      filled: Icons.info_rounded,
      label: 'About',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: LibraryShelfTheme.woodMid,
        border: Border(
          top: BorderSide(
            color: LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.7),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              return Expanded(
                child: _NavItem(
                  outlinedIcon: item.outlined,
                  filledIcon: item.filled,
                  label: item.label,
                  selected: currentIndex == index,
                  onTap: () {
                    AppHaptics.light();
                    onChanged(index);
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.outlinedIcon,
    required this.filledIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData outlinedIcon;
  final IconData filledIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const activeColor = LibraryShelfTheme.navActive;
    const idleColor = LibraryShelfTheme.navInactive;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: activeColor.withValues(alpha: 0.08),
        highlightColor: activeColor.withValues(alpha: 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 9,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  height: 3,
                  width: selected ? 22 : 0,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(
                selected ? filledIcon : outlinedIcon,
                key: ValueKey(selected),
                size: 24,
                color: selected ? activeColor : idleColor,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              style: AppTypography.label(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? activeColor : idleColor,
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
