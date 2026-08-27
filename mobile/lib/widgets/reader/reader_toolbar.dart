import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/reader_theme.dart';
import 'package:frontend/core/utils/app_haptics.dart';

class ReaderToolbar extends StatelessWidget {
  const ReaderToolbar({
    super.key,
    required this.onBack,
    this.onChapters,
    this.onTextSearch,
    this.onZoomIn,
    this.onDownload,
    this.onDelete,
    this.onSettings,
    this.showZoom = true,
    this.showChapters = false,
  });

  final VoidCallback onBack;
  final VoidCallback? onChapters;
  final VoidCallback? onTextSearch;
  final VoidCallback? onZoomIn;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;
  final VoidCallback? onSettings;
  final bool showZoom;
  final bool showChapters;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ReaderTheme.toolbarBackground,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              _ToolbarIcon(
                icon: Icons.arrow_back_rounded,
                tooltip: 'Back',
                onPressed: onBack,
              ),
              const Spacer(),
              if (showChapters && onChapters != null)
                _ToolbarIcon(
                  icon: Icons.menu_book_outlined,
                  tooltip: 'Chapters',
                  onPressed: onChapters!,
                ),
              if (onTextSearch != null)
                _ToolbarIcon(
                  icon: Icons.search_rounded,
                  tooltip: 'Search text',
                  onPressed: onTextSearch!,
                ),
              if (showZoom && onZoomIn != null)
                _ToolbarIcon(icon: Icons.zoom_in_rounded, tooltip: 'Zoom in', onPressed: onZoomIn!),
              if (onDownload != null)
                _ToolbarIcon(icon: Icons.download_outlined, tooltip: 'Download', onPressed: onDownload!),
              if (onDelete != null)
                _ToolbarIcon(
                  icon: Icons.delete_outline_rounded,
                  tooltip: 'Delete',
                  color: AppColors.error,
                  onPressed: onDelete!,
                ),
              if (onSettings != null)
                _ToolbarIcon(icon: Icons.settings_outlined, tooltip: 'Settings', onPressed: onSettings!),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  const _ToolbarIcon({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () {
        AppHaptics.light();
        onPressed();
      },
      icon: Icon(icon, color: color ?? ReaderTheme.iconColor, size: 22),
      style: IconButton.styleFrom(
        minimumSize: const Size(44, 44),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
