import 'package:intl/intl.dart';

class Ebook {
  const Ebook({
    required this.id,
    required this.title,
    this.author,
    this.description,
    required this.status,
    this.fileType,
    this.fileSize,
    this.filename,
    this.coverUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final String? author;
  final String? description;
  final String status;
  final String? fileType;
  final int? fileSize;
  final String? filename;
  final String? coverUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Ebook.fromJson(Map<String, dynamic> json) {
    return Ebook(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'active',
      fileType: json['file_type'] as String?,
      fileSize: json['file_size'] as int?,
      filename: json['filename'] as String?,
      coverUrl: json['cover_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  String get displayAuthor => author?.isNotEmpty == true ? author! : 'Unknown author';

  String get formattedUploadDate => DateFormat.yMMMd().format(createdAt);

  bool get isPdf => fileType == 'application/pdf';

  bool get isEpub => fileType == 'application/epub+zip';

  bool get hasCover => coverUrl != null && coverUrl!.isNotEmpty;

  String get fileTypeLabel {
    if (isPdf) return 'PDF';
    if (isEpub) return 'EPUB';
    return fileType ?? 'File';
  }

  String get fileExtension {
    if (isPdf) return '.pdf';
    if (isEpub) return '.epub';
    return '';
  }

  String get formattedFileSize {
    final size = fileSize;
    if (size == null || size <= 0) return 'Unknown size';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
