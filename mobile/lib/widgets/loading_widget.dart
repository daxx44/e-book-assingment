import 'package:flutter/material.dart';
import 'package:frontend/widgets/shimmer_loading.dart';

/// Page-level loading uses shimmer instead of spinners.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.variant = LoadingVariant.library,
    this.progress,
  });

  final LoadingVariant variant;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case LoadingVariant.library:
        return const LibraryShimmer();
      case LoadingVariant.search:
        return const SearchShimmer();
      case LoadingVariant.reader:
        return const ReaderShimmer();
      case LoadingVariant.upload:
        return UploadProgressShimmer(progress: progress ?? 0);
    }
  }
}

enum LoadingVariant { library, search, reader, upload }
