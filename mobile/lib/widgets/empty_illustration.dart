import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/widgets/app_icon.dart';

/// Decorative illustration for empty states — app icon with book accents.
class EmptyIllustration extends StatelessWidget {
  const EmptyIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 24,
            bottom: 20,
            child: _BookTile(
              colors: AppColors.coverGradients[2],
              rotation: -0.12,
              width: 56,
              height: 72,
            ),
          ),
          Positioned(
            right: 28,
            bottom: 16,
            child: _BookTile(
              colors: AppColors.coverGradients[4],
              rotation: 0.1,
              width: 52,
              height: 68,
            ),
          ),
          const AppIcon(size: 100, borderRadius: 24, showShadow: true),
        ],
      ),
    );
  }
}

class _BookTile extends StatelessWidget {
  const _BookTile({
    required this.colors,
    required this.rotation,
    required this.width,
    required this.height,
  });

  final List<Color> colors;
  final double rotation;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: colors.first.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 6)),
          ],
        ),
      ),
    );
  }
}
