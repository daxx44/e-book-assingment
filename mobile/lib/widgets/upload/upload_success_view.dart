import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/widgets/upload/upload_form_widgets.dart';

class UploadSuccessView extends StatelessWidget {
  const UploadSuccessView({
    super.key,
    required this.title,
    required this.onGoToLibrary,
  });

  final String title;
  final VoidCallback onGoToLibrary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.8, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: LibraryShelfTheme.navActive.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                  border: Border.all(color: LibraryShelfTheme.navActive.withValues(alpha: 0.35)),
                ),
                child: const Icon(Icons.check_rounded, size: 56, color: LibraryShelfTheme.navActive),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Added to library',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: LibraryShelfTheme.headerText,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: LibraryShelfTheme.headerMuted,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xl),
              ShelfUploadButton(
                label: 'Go to Library',
                icon: Icons.library_books_rounded,
                onPressed: onGoToLibrary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
