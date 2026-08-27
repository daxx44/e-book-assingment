import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/core/utils/app_haptics.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/widgets/library/realistic_book_visual.dart';
import 'package:frontend/widgets/upload/upload_form_widgets.dart';

Future<void> showBookDetailsSheet(
  BuildContext context, {
  required Ebook ebook,
  required VoidCallback onRead,
  required VoidCallback onDownload,
  required VoidCallback onDelete,
}) async {
  AppHaptics.light();
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.78,
        minChildSize: 0.48,
        maxChildSize: 0.94,
        builder: (context, scrollController) {
          return _BookDetailsSheetBody(
            ebook: ebook,
            scrollController: scrollController,
            onRead: onRead,
            onDownload: onDownload,
            onDelete: onDelete,
          );
        },
      );
    },
  );
}

class _BookDetailsSheetBody extends StatelessWidget {
  const _BookDetailsSheetBody({
    required this.ebook,
    required this.scrollController,
    required this.onRead,
    required this.onDownload,
    required this.onDelete,
  });

  final Ebook ebook;
  final ScrollController scrollController;
  final VoidCallback onRead;
  final VoidCallback onDownload;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDescription = ebook.description?.trim().isNotEmpty == true;
    const bookW = 118.0;
    const bookH = 176.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E1C18), LibraryShelfTheme.woodMid, LibraryShelfTheme.woodDark],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
        border: Border(
          top: BorderSide(color: LibraryShelfTheme.navActive.withValues(alpha: 0.35)),
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), blurRadius: 28, offset: Offset(0, -6)),
        ],
      ),
      child: ListView(
        controller: scrollController,
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
        ),
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.45),
                      blurRadius: 14,
                      offset: const Offset(4, 6),
                    ),
                  ],
                ),
                child: RealisticBookVisual(
                  ebook: ebook,
                  width: bookW,
                  height: bookH,
                  onShelf: true,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FormatBadge(label: ebook.fileTypeLabel),
                    const SizedBox(height: 10),
                    Text(
                      ebook.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: LibraryShelfTheme.headerText,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ebook.displayAuthor,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: LibraryShelfTheme.headerMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasDescription) ...[
            const SizedBox(height: AppSpacing.lg),
            const UploadSectionLabel('About'),
            Text(
              ebook.description!.trim(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.95),
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          const UploadSectionLabel('Details'),
          _DetailsCard(
            children: [
              _DetailRow(icon: Icons.description_outlined, label: 'Format', value: ebook.fileTypeLabel),
              if (ebook.fileSize != null && ebook.fileSize! > 0)
                _DetailRow(icon: Icons.sd_storage_outlined, label: 'Size', value: ebook.formattedFileSize),
              _DetailRow(icon: Icons.calendar_today_outlined, label: 'Uploaded', value: ebook.formattedUploadDate),
              if (ebook.filename != null)
                _DetailRow(icon: Icons.insert_drive_file_outlined, label: 'File', value: ebook.filename!),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          ShelfUploadButton(
            label: 'Read now',
            icon: Icons.menu_book_rounded,
            onPressed: () {
              Navigator.pop(context);
              AppHaptics.medium();
              onRead();
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          _ShelfOutlinedButton(
            label: 'Download',
            icon: Icons.download_rounded,
            onPressed: () {
              Navigator.pop(context);
              onDownload();
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFFF8A80)),
            label: Text(
              'Delete from library',
              style: theme.textTheme.labelLarge?.copyWith(
                color: const Color(0xFFFF8A80),
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              foregroundColor: const Color(0xFFFF8A80),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatBadge extends StatelessWidget {
  const _FormatBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: LibraryShelfTheme.navActive.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: LibraryShelfTheme.navActive.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: LibraryShelfTheme.navActive,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.55)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Column(children: children),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: LibraryShelfTheme.navActive.withValues(alpha: 0.9)),
          const SizedBox(width: 12),
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: LibraryShelfTheme.headerMuted,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: LibraryShelfTheme.headerText,
                    height: 1.35,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShelfOutlinedButton extends StatelessWidget {
  const _ShelfOutlinedButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: LibraryShelfTheme.headerText),
        label: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: LibraryShelfTheme.headerText,
                fontWeight: FontWeight.w600,
              ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.35)),
          backgroundColor: Colors.white.withValues(alpha: 0.04),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        ),
      ),
    );
  }
}
