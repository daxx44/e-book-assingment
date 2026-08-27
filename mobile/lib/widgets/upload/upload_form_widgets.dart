import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';

class UploadSectionLabel extends StatelessWidget {
  const UploadSectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: LibraryShelfTheme.navActive,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              fontSize: 11,
            ),
      ),
    );
  }
}

class ShelfFormField extends StatelessWidget {
  const ShelfFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      textInputAction: textInputAction,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: LibraryShelfTheme.headerText,
          ),
      cursorColor: LibraryShelfTheme.navActive,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: LibraryShelfTheme.headerMuted,
            ),
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.65),
            ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.06),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: LibraryShelfTheme.navActive, width: 1.5),
        ),
      ),
    );
  }
}

class EbookFilePickerCard extends StatelessWidget {
  const EbookFilePickerCard({
    super.key,
    required this.fileName,
    required this.onPick,
  });

  final String fileName;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName.isNotEmpty;
    final isEpub = fileName.toLowerCase().endsWith('.epub');

    return Material(
      color: Colors.white.withValues(alpha: hasFile ? 0.08 : 0.04),
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        onTap: onPick,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: hasFile
                  ? LibraryShelfTheme.navActive.withValues(alpha: 0.45)
                  : LibraryShelfTheme.headerMuted.withValues(alpha: 0.28),
              width: hasFile ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: hasFile ? _SelectedFileRow(fileName: fileName, isEpub: isEpub) : const _EmptyFilePrompt(),
          ),
        ),
      ),
    );
  }
}

class _EmptyFilePrompt extends StatelessWidget {
  const _EmptyFilePrompt();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: LibraryShelfTheme.navActive.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.upload_file_rounded,
            color: LibraryShelfTheme.navActive,
            size: 32,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Select ebook file',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: LibraryShelfTheme.headerText,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'PDF or EPUB · up to 100 MB',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: LibraryShelfTheme.headerMuted,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: LibraryShelfTheme.navActive.withValues(alpha: 0.35)),
          ),
          child: Text(
            'Browse files',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: LibraryShelfTheme.navActive,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

class _SelectedFileRow extends StatelessWidget {
  const _SelectedFileRow({required this.fileName, required this.isEpub});

  final String fileName;
  final bool isEpub;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                LibraryShelfTheme.shelfMid,
                LibraryShelfTheme.shelfShadow,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isEpub ? Icons.auto_stories_rounded : Icons.picture_as_pdf_rounded,
            color: LibraryShelfTheme.headerText,
            size: 26,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: LibraryShelfTheme.headerText,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _FormatChip(label: isEpub ? 'EPUB' : 'PDF'),
                  const SizedBox(width: 8),
                  Text(
                    'Tap to change',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: LibraryShelfTheme.headerMuted,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(Icons.swap_horiz_rounded, color: LibraryShelfTheme.navActive.withValues(alpha: 0.9)),
      ],
    );
  }
}

class CoverImagePickerCard extends StatelessWidget {
  const CoverImagePickerCard({
    super.key,
    required this.coverPath,
    required this.onPick,
    required this.onRemove,
  });

  final String coverPath;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final hasCover = coverPath.isNotEmpty;

    return Material(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onPick,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              _CoverThumbnail(coverPath: coverPath, hasCover: hasCover),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasCover ? 'Cover image' : 'Cover image',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: LibraryShelfTheme.headerText,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasCover ? 'Tap to replace' : 'Optional · JPEG, PNG, or WebP',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: LibraryShelfTheme.headerMuted,
                          ),
                    ),
                  ],
                ),
              ),
              if (hasCover)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: LibraryShelfTheme.headerMuted,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.06),
                  ),
                )
              else
                Icon(Icons.add_photo_alternate_outlined, color: LibraryShelfTheme.navActive),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverThumbnail extends StatelessWidget {
  const _CoverThumbnail({required this.coverPath, required this.hasCover});

  final String coverPath;
  final bool hasCover;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 64,
      decoration: BoxDecoration(
        color: LibraryShelfTheme.wallRecess,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: LibraryShelfTheme.shelfMid.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: hasCover
          ? Image.file(File(coverPath), fit: BoxFit.cover)
          : Icon(Icons.image_outlined, color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.7)),
    );
  }
}

class _FormatChip extends StatelessWidget {
  const _FormatChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: LibraryShelfTheme.navActive.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: LibraryShelfTheme.navActive,
              fontWeight: FontWeight.w700,
              fontSize: 9,
              letterSpacing: 0.4,
            ),
      ),
    );
  }
}

class UploadErrorBanner extends StatelessWidget {
  const UploadErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFB3261E).withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: const Color(0xFFB3261E).withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: Color(0xFFFF8A80), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
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

class ShelfUploadButton extends StatelessWidget {
  const ShelfUploadButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: LibraryShelfTheme.navActive,
          foregroundColor: LibraryShelfTheme.woodDark,
          disabledBackgroundColor: LibraryShelfTheme.navActive.withValues(alpha: 0.35),
          disabledForegroundColor: LibraryShelfTheme.woodDark.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: LibraryShelfTheme.woodDark),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 10),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}
