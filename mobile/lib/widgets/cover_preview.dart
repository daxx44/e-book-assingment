import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class CoverPreview extends StatelessWidget {
  const CoverPreview({
    super.key,
    required this.title,
    this.subtitle,
    this.coverUrl,
    this.heroTag,
    this.compact = false,
    this.showFormatBadge = true,
  });

  final String title;
  final String? subtitle;
  final String? coverUrl;
  final String? heroTag;
  final bool compact;
  final bool showFormatBadge;

  static List<Color> gradientForTitle(String title) {
    final hash = title.codeUnits.fold<int>(0, (value, unit) => value + unit);
    return AppColors.coverGradients[hash % AppColors.coverGradients.length];
  }

  static String initialsFor(String title) {
    final words = title.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return '?';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasCover = coverUrl != null && coverUrl!.isNotEmpty;
    final content = hasCover ? _buildImageCover(context) : _buildGradientCover(context);

    if (heroTag != null) {
      return Hero(tag: heroTag!, child: Material(color: Colors.transparent, child: content));
    }
    return content;
  }

  Widget _buildImageCover(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: coverUrl!,
          fit: BoxFit.cover,
          placeholder: (_, __) => _buildGradientCover(context),
          errorWidget: (_, __, ___) => _buildGradientCover(context),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: showFormatBadge
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    subtitle ?? 'PDF',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildGradientCover(BuildContext context) {
    final colors = gradientForTitle(title);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: showFormatBadge
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      subtitle ?? 'PDF',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Padding(
            padding: EdgeInsets.all(compact ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  initialsFor(title),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                ),
                if (!compact) ...[
                  const SizedBox(height: 12),
                  Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.3,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
