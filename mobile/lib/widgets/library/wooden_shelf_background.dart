import 'package:flutter/material.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';

class WoodenShelfBackground extends StatelessWidget {
  const WoodenShelfBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(decoration: BoxDecoration(gradient: LibraryShelfTheme.backgroundGradient)),
        CustomPaint(painter: _WoodPlankPainter()),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.85),
              radius: 1.1,
              colors: [LibraryShelfTheme.spotlight, Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }
}

class _WoodPlankPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const plankWidth = 52.0;
    for (var x = 0.0; x < size.width + plankWidth; x += plankWidth) {
      final shade = (x / plankWidth).round() % 2 == 0 ? 0.06 : 0.12;
      final paint = Paint()..color = Colors.black.withValues(alpha: shade);
      canvas.drawRect(Rect.fromLTWH(x, 0, plankWidth * 0.45, size.height), paint);

      final grain = Paint()
        ..color = Colors.white.withValues(alpha: 0.025)
        ..strokeWidth = 1;
      canvas.drawLine(Offset(x + 8, 0), Offset(x + 8, size.height), grain);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
