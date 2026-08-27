import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/utils/app_haptics.dart';
import 'package:frontend/widgets/book_card.dart';

class BookOptionsMenu extends StatelessWidget {
  const BookOptionsMenu({
    super.key,
    required this.onRead,
    required this.onDownload,
    required this.onDelete,
    this.lightStyle = false,
  });

  final VoidCallback onRead;
  final VoidCallback onDownload;
  final VoidCallback onDelete;
  final bool lightStyle;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BookCardAction>(
      tooltip: 'Book options',
      padding: EdgeInsets.zero,
      offset: const Offset(0, 28),
      splashRadius: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
      color: AppColors.surface,
      onSelected: (action) {
        AppHaptics.selection();
        switch (action) {
          case BookCardAction.read:
            onRead();
          case BookCardAction.download:
            onDownload();
          case BookCardAction.delete:
            onDelete();
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: BookCardAction.read, child: Text('Read')),
        PopupMenuItem(value: BookCardAction.download, child: Text('Download')),
        PopupMenuItem(
          value: BookCardAction.delete,
          child: Text('Delete', style: TextStyle(color: AppColors.error)),
        ),
      ],
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: lightStyle
              ? Colors.black.withValues(alpha: 0.45)
              : Colors.black.withValues(alpha: 0.42),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: const SizedBox(
          width: 22,
          height: 22,
          child: Icon(Icons.more_horiz_rounded, size: 13, color: Colors.white),
        ),
      ),
    );
  }
}
