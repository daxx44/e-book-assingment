import 'package:intl/intl.dart';

class DownloadedEbook {
  const DownloadedEbook({
    required this.ebookId,
    required this.title,
    this.author,
    this.fileType,
    this.coverUrl,
    required this.filename,
    required this.localPath,
    required this.fileSizeBytes,
    required this.downloadedAt,
  });

  final int ebookId;
  final String title;
  final String? author;
  final String? fileType;
  final String? coverUrl;
  final String filename;
  final String localPath;
  final int fileSizeBytes;
  final DateTime downloadedAt;

  factory DownloadedEbook.fromJson(Map<String, dynamic> json) {
    return DownloadedEbook(
      ebookId: json['ebook_id'] as int,
      title: json['title'] as String,
      author: json['author'] as String?,
      fileType: json['file_type'] as String?,
      coverUrl: json['cover_url'] as String?,
      filename: json['filename'] as String,
      localPath: json['local_path'] as String,
      fileSizeBytes: json['file_size_bytes'] as int? ?? 0,
      downloadedAt: DateTime.parse(json['downloaded_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'ebook_id': ebookId,
        'title': title,
        'author': author,
        'file_type': fileType,
        'cover_url': coverUrl,
        'filename': filename,
        'local_path': localPath,
        'file_size_bytes': fileSizeBytes,
        'downloaded_at': downloadedAt.toIso8601String(),
      };

  String get displayAuthor => author?.isNotEmpty == true ? author! : 'Unknown author';

  String get formattedDownloadDate => DateFormat.yMMMd().format(downloadedAt);

  String get fileTypeLabel {
    if (fileType == 'application/pdf') return 'PDF';
    if (fileType == 'application/epub+zip') return 'EPUB';
    return 'File';
  }

  String get formattedFileSize {
    if (fileSizeBytes <= 0) return 'Unknown size';
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
