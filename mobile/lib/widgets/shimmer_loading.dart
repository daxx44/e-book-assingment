import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/widgets/library/wooden_shelf_plank.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 16,
    this.baseColor,
    this.highlightColor,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final base = baseColor ?? AppColors.shimmerBase;
    final highlight = highlightColor ?? AppColors.shimmerHighlight;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Skeleton loader for the library — simple book placeholders on the dark shelf.
class LibraryShimmer extends StatelessWidget {
  const LibraryShimmer({super.key});

  static const _base = Color(0xFF2A1A15);
  static const _highlight = Color(0xFF3D2B22);

  @override
  Widget build(BuildContext context) {
    final booksPerRow = MediaQuery.sizeOf(context).width >= 800 ? 4 : 3;
    final bookHeight = ShelfMetrics.bookHeightFor(context, booksPerRow);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        const ShimmerBox(
          width: 128,
          height: 16,
          borderRadius: 6,
          baseColor: _base,
          highlightColor: _highlight,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 108,
          child: Row(
            children: const [
              Expanded(
                child: ShimmerBox(
                  width: double.infinity,
                  height: 108,
                  borderRadius: 8,
                  baseColor: _base,
                  highlightColor: _highlight,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ShimmerBox(
                  width: double.infinity,
                  height: 108,
                  borderRadius: 8,
                  baseColor: _base,
                  highlightColor: _highlight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        for (var row = 0; row < 2; row++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < booksPerRow; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ShimmerBox(
                      width: double.infinity,
                      height: bookHeight,
                      borderRadius: 6,
                      baseColor: _base,
                      highlightColor: _highlight,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class SearchShimmer extends StatelessWidget {
  const SearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 4,
      itemBuilder: (_, __) => const _LegacyBookShimmerCard(),
    );
  }
}

class _LegacyBookShimmerCard extends StatelessWidget {
  const _LegacyBookShimmerCard();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(width: double.infinity, height: 200, borderRadius: 12),
        SizedBox(height: 12),
        ShimmerBox(width: 120, height: 14, borderRadius: 6),
        SizedBox(height: 8),
        ShimmerBox(width: 80, height: 12, borderRadius: 6),
      ],
    );
  }
}

class ReaderShimmer extends StatelessWidget {
  const ReaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: const [
          ShimmerBox(width: double.infinity, height: 48, borderRadius: 12),
          SizedBox(height: 24),
          Expanded(child: ShimmerBox(width: double.infinity, height: double.infinity, borderRadius: 16)),
          SizedBox(height: 16),
          ShimmerBox(width: 100, height: 12, borderRadius: 6),
        ],
      ),
    );
  }
}

class UploadProgressShimmer extends StatelessWidget {
  const UploadProgressShimmer({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(Icons.cloud_upload_outlined, size: 48, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Uploading your ebook…',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% complete',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.shimmerBase,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
