import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';

/// Shared dimensions so books align consistently on shelf planks.
class ShelfMetrics {
  ShelfMetrics._();

  static const double contactShadowHeight = 4;
  static const double plankTopHeight = 11;
  static const double plankFrontHeight = 6;
  static const double plankHeight = plankTopHeight + plankFrontHeight;
  static const double dropShadowHeight = 7;
  static const double bracketWidth = 10;

  /// Total vertical space occupied by the wooden shelf widget.
  static double get totalShelfHeight =>
      contactShadowHeight + plankHeight + dropShadowHeight + 1;

  /// Distance from the stack bottom to the book's resting edge (top of plank).
  static double get bookRestInset => dropShadowHeight + plankHeight;

  /// Standard cover aspect: height / width.
  static const double bookAspect = 1.5;

  static const double rowHorizontalPadding = 14;
  static const double columnGap = 8;

  static double bookHeightFor(BuildContext context, int booksPerRow) {
    final screenW = MediaQuery.sizeOf(context).width;
    final rowInner = screenW - (rowHorizontalPadding * 2);
    final columnW = rowInner / booksPerRow;
    final bookW = (columnW - columnGap) * 0.8;
    final height = bookW * bookAspect;
    return height.clamp(215, 252);
  }

  static double bookWidthForColumn(double columnWidth, double bookHeight) {
    final idealWidth = bookHeight / bookAspect;
    final maxWidth = columnWidth * 0.82;
    return idealWidth < maxWidth ? idealWidth : maxWidth;
  }

  static double resolvedBookHeight(double bookWidth) => bookWidth * bookAspect;

  static const double continueBookWidth = 104;

  /// Height for the horizontal Continue Reading list (book + shelf + labels).
  static double get continueReadingStripHeight {
    final bookH = resolvedBookHeight(continueBookWidth);
    return bookH + bookRestInset + 96;
  }
}

/// Painted wooden shelf plank with grain, bevel, brackets, and cast shadow.
class WoodenShelfPlank extends StatelessWidget {
  const WoodenShelfPlank({super.key, this.showBrackets = true});

  final bool showBrackets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ShelfMetrics.rowHorizontalPadding),
      child: CustomPaint(
        painter: _ShelfPlankPainter(showBrackets: showBrackets),
        child: SizedBox(height: ShelfMetrics.totalShelfHeight),
      ),
    );
  }
}

class _ShelfPlankPainter extends CustomPainter {
  _ShelfPlankPainter({required this.showBrackets});

  final bool showBrackets;

  @override
  void paint(Canvas canvas, Size size) {
    final contactH = ShelfMetrics.contactShadowHeight;
    final topH = ShelfMetrics.plankTopHeight;
    final frontH = ShelfMetrics.plankFrontHeight;
    final dropH = ShelfMetrics.dropShadowHeight;
    final bracketW = ShelfMetrics.bracketWidth;

    final plankTop = size.height - dropH - frontH - topH;
    final plankFront = plankTop + topH;
    final plankBottom = size.height - dropH;

    _paintContactShadow(canvas, size, plankTop, contactH, bracketW);
    _paintPlankTop(canvas, size, plankTop, topH, bracketW);
    _paintPlankFront(canvas, size, plankFront, frontH, bracketW);
    _paintDropShadow(canvas, size, plankBottom, dropH, bracketW);

    if (showBrackets) {
      _paintBracket(canvas, Rect.fromLTWH(0, plankTop - 2, bracketW, frontH + topH + 2));
      _paintBracket(
        canvas,
        Rect.fromLTWH(size.width - bracketW, plankTop - 2, bracketW, frontH + topH + 2),
        mirrored: true,
      );
    }
  }

  void _paintContactShadow(Canvas canvas, Size size, double plankTop, double height, double bracketW) {
    final innerLeft = showBrackets ? bracketW - 2 : 0.0;
    final innerRight = showBrackets ? size.width - bracketW + 2 : size.width;
    final rect = Rect.fromLTWH(innerLeft, plankTop - height, innerRight - innerLeft, height);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.22),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _paintPlankTop(Canvas canvas, Size size, double top, double height, double bracketW) {
    final innerLeft = showBrackets ? bracketW - 2 : 0.0;
    final innerRight = showBrackets ? size.width - bracketW + 2 : size.width;
    final rect = Rect.fromLTWH(innerLeft, top, innerRight - innerLeft, height);

    final basePaint = Paint()
      ..shader = LibraryShelfTheme.shelfGradient.createShader(rect);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(2));
    canvas.drawRRect(rrect, basePaint);

    _paintWoodGrain(canvas, rect);

    // Top bevel highlight
    final highlight = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.22),
          Colors.white.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0, 0.35, 1],
      ).createShader(rect);
    canvas.drawRRect(rrect, highlight);

    // Subtle edge darkening at sides
    final sideShade = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.black.withValues(alpha: 0.18),
          Colors.transparent,
          Colors.transparent,
          Colors.black.withValues(alpha: 0.18),
        ],
        stops: const [0, 0.08, 0.92, 1],
      ).createShader(rect);
    canvas.drawRRect(rrect, sideShade);
  }

  void _paintWoodGrain(Canvas canvas, Rect rect) {
    final rng = math.Random(rect.width.round() + rect.height.round());
    final grainPaint = Paint()..style = PaintingStyle.stroke;

    for (var i = 0; i < 14; i++) {
      final y = rect.top + rect.height * (0.12 + rng.nextDouble() * 0.76);
      final amplitude = 0.8 + rng.nextDouble() * 1.6;
      final wavelength = 28 + rng.nextDouble() * 42;
      final path = Path()..moveTo(rect.left, y);

      for (var x = rect.left; x <= rect.right; x += 3) {
        final wave = math.sin((x - rect.left) / wavelength * math.pi * 2) * amplitude;
        path.lineTo(x, y + wave);
      }

      grainPaint
        ..color = (i.isEven ? LibraryShelfTheme.shelfGrainLight : LibraryShelfTheme.shelfGrainDark)
            .withValues(alpha: 0.07 + rng.nextDouble() * 0.09)
        ..strokeWidth = 0.6 + rng.nextDouble() * 0.5;
      canvas.drawPath(path, grainPaint);
    }

    // Occasional darker streaks
    for (var i = 0; i < 4; i++) {
      final x = rect.left + rect.width * rng.nextDouble();
      final streak = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.14),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTWH(x - 1, rect.top, 2, rect.height));
      canvas.drawRect(Rect.fromLTWH(x - 0.8, rect.top, 1.6, rect.height), streak);
    }
  }

  void _paintPlankFront(Canvas canvas, Size size, double top, double height, double bracketW) {
    final innerLeft = showBrackets ? bracketW - 2 : 0.0;
    final innerRight = showBrackets ? size.width - bracketW + 2 : size.width;
    final rect = Rect.fromLTWH(innerLeft, top, innerRight - innerLeft, height);

    final paint = Paint()
      ..shader = LibraryShelfTheme.shelfFrontGradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Bottom lip shadow
    final lip = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.35),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, lip);

    // Front face horizontal grain lines
    final linePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..strokeWidth = 0.5;
    for (var y = top + 1.5; y < top + height - 1; y += 1.8) {
      canvas.drawLine(Offset(innerLeft + 2, y), Offset(innerRight - 2, y), linePaint);
    }
  }

  void _paintDropShadow(Canvas canvas, Size size, double top, double height, double bracketW) {
    final innerLeft = showBrackets ? bracketW - 2 : 0.0;
    final innerRight = showBrackets ? size.width - bracketW + 2 : size.width;
    final rect = Rect.fromLTWH(innerLeft, top, innerRight - innerLeft, height);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withValues(alpha: 0.38),
          Colors.transparent,
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _paintBracket(Canvas canvas, Rect rect, {bool mirrored = false}) {
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: mirrored ? Radius.zero : const Radius.circular(2),
      topRight: mirrored ? const Radius.circular(2) : Radius.zero,
      bottomLeft: mirrored ? const Radius.circular(1) : const Radius.circular(1),
      bottomRight: mirrored ? const Radius.circular(1) : const Radius.circular(1),
    );

    final base = Paint()
      ..shader = LinearGradient(
        begin: mirrored ? Alignment.centerRight : Alignment.centerLeft,
        end: mirrored ? Alignment.centerLeft : Alignment.centerRight,
        colors: [
          LibraryShelfTheme.shelfBracketEdge.withValues(alpha: 0.5),
          LibraryShelfTheme.shelfBracket,
          LibraryShelfTheme.shelfFrontShadow,
        ],
      ).createShader(rect);
    canvas.drawRRect(rrect, base);

    // Bracket edge highlight
    final edgeX = mirrored ? rect.left + 1 : rect.right - 1;
    final edge = Paint()
      ..color = LibraryShelfTheme.shelfGrainLight.withValues(alpha: 0.2)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(edgeX, rect.top + 1), Offset(edgeX, rect.bottom - 1), edge);
  }

  @override
  bool shouldRepaint(covariant _ShelfPlankPainter oldDelegate) =>
      oldDelegate.showBrackets != showBrackets;
}
