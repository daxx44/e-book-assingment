import 'package:flutter/material.dart';
import 'package:frontend/core/utils/app_haptics.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/widgets/book_card.dart';
import 'package:frontend/widgets/library/realistic_book_visual.dart';
import 'package:frontend/widgets/library/wooden_shelf_plank.dart';
import 'package:frontend/widgets/scale_on_press.dart';

/// Physical book only — sized and aligned to rest on the shelf plank.
class ShelfBookCard extends StatelessWidget {
  const ShelfBookCard({
    super.key,
    required this.ebook,
    required this.onTap,
    required this.onRead,
    required this.onDownload,
    required this.onDelete,
    required this.bookHeight,
  });

  final Ebook ebook;
  final VoidCallback onTap;
  final VoidCallback onRead;
  final VoidCallback onDownload;
  final VoidCallback onDelete;
  final double bookHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showBookMenu(context),
      child: ScaleOnPress(
        onTap: () {
          AppHaptics.light();
          onTap();
        },
        scale: 0.98,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bookW = ShelfMetrics.bookWidthForColumn(constraints.maxWidth, bookHeight);
            final bookH = ShelfMetrics.resolvedBookHeight(bookW);

            return SizedBox(
              width: constraints.maxWidth,
              height: bookH,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RealisticBookVisual(
                  ebook: ebook,
                  width: bookW,
                  height: bookH,
                  onShelf: true,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showBookMenu(BuildContext context) {
    AppHaptics.medium();
    final box = context.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = box?.localToGlobal(Offset.zero) ?? Offset.zero;
    final size = box?.size ?? Size.zero;

    showMenu<BookCardAction>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        overlay.size.width - position.dx - size.width,
        overlay.size.height - position.dy - size.height * 0.5,
      ),
      items: const [
        PopupMenuItem(value: BookCardAction.read, child: Text('Read')),
        PopupMenuItem(value: BookCardAction.download, child: Text('Download')),
        PopupMenuItem(
          value: BookCardAction.delete,
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ).then((action) {
      if (action == null) return;
      switch (action) {
        case BookCardAction.read:
          onRead();
        case BookCardAction.download:
          onDownload();
        case BookCardAction.delete:
          onDelete();
      }
    });
  }
}
