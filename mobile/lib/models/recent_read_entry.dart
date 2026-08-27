class RecentReadEntry {
  const RecentReadEntry({
    required this.ebookId,
    required this.readAt,
    required this.progress,
    this.currentPage,
    this.totalPages,
  });

  final int ebookId;
  final DateTime readAt;
  final double progress;
  final int? currentPage;
  final int? totalPages;

  factory RecentReadEntry.fromJson(Map<String, dynamic> json) {
    return RecentReadEntry(
      ebookId: json['ebook_id'] as int,
      readAt: DateTime.parse(json['read_at'] as String),
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      currentPage: json['current_page'] as int?,
      totalPages: json['total_pages'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'ebook_id': ebookId,
        'read_at': readAt.toIso8601String(),
        'progress': progress,
        if (currentPage != null) 'current_page': currentPage,
        if (totalPages != null) 'total_pages': totalPages,
      };
}

class RecentReadItem {
  const RecentReadItem({
    required this.ebookId,
    required this.readAt,
    required this.progress,
    this.currentPage,
    this.totalPages,
  });

  final int ebookId;
  final DateTime readAt;
  final double progress;
  final int? currentPage;
  final int? totalPages;

  int get progressPercent => (progress * 100).clamp(0, 100).round();
}
