class ReaderSearchResult {
  const ReaderSearchResult({
    required this.label,
    required this.excerpt,
    this.scrollIndex,
    this.pageNumber,
  });

  final String label;
  final String excerpt;
  final int? scrollIndex;
  final int? pageNumber;
}
