import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_assets.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.size,
    this.borderRadius = 16,
    this.showShadow = false,
  });

  final double size;
  final double borderRadius;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: LibraryShelfTheme.shelfMid,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  blurRadius: size * 0.22,
                  offset: Offset(0, size * 0.1),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        AppAssets.appIcon,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(
          Icons.menu_book_rounded,
          size: size * 0.5,
          color: LibraryShelfTheme.navActive,
        ),
      ),
    );
  }
}
