import 'dart:convert';
import 'dart:io';

import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/models/downloaded_ebook.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/repositories/ebook_repository.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef DownloadProgressCallback = void Function(double progress, String stage);

class DownloadService extends GetxService {
  DownloadService({
    EbookRepository? repository,
    SharedPreferences? prefs,
  })  : _repository = repository ?? EbookRepository(),
        _prefs = prefs;

  static const _storageKey = 'downloaded_ebooks_v1';

  final EbookRepository _repository;
  SharedPreferences? _prefs;

  final RxList<DownloadedEbook> downloads = <DownloadedEbook>[].obs;
  final RxMap<int, double> activeProgress = <int, double>{}.obs;
  final RxMap<int, String> activeStage = <int, String>{}.obs;

  Future<SharedPreferences> get _preferences async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> loadDownloads() async {
    final prefs = await _preferences;
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      downloads.clear();
      return;
    }

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final items = decoded
          .map((item) => DownloadedEbook.fromJson(item as Map<String, dynamic>))
          .where((item) => File(item.localPath).existsSync())
          .toList();
      downloads.assignAll(items);
      if (items.length != decoded.length) {
        await _persist(items);
      }
    } catch (_) {
      downloads.clear();
    }
  }

  bool isDownloaded(int ebookId) => downloads.any((item) => item.ebookId == ebookId);

  String? localPathFor(int ebookId) {
    for (final item in downloads) {
      if (item.ebookId == ebookId) return item.localPath;
    }
    return null;
  }

  DownloadedEbook? findByEbookId(int ebookId) {
    for (final item in downloads) {
      if (item.ebookId == ebookId) return item;
    }
    return null;
  }

  Ebook toEbook(DownloadedEbook item) {
    return Ebook(
      id: item.ebookId,
      title: item.title,
      author: item.author,
      status: 'active',
      fileType: item.fileType,
      fileSize: item.fileSizeBytes,
      filename: item.filename,
      coverUrl: item.coverUrl,
      createdAt: item.downloadedAt,
      updatedAt: item.downloadedAt,
    );
  }

  Future<DownloadedEbook> download(
    Ebook ebook, {
    DownloadProgressCallback? onProgress,
  }) async {
    if (activeProgress.containsKey(ebook.id)) {
      throw ApiException(code: 'DOWNLOAD_IN_PROGRESS', message: 'Download already in progress.');
    }

    void report(double value, String stage) {
      activeProgress[ebook.id] = value;
      activeStage[ebook.id] = stage;
      onProgress?.call(value, stage);
    }

    report(0.02, 'Preparing download...');

    try {
      final bytes = await _repository.downloadEbook(
        ebook.id,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            report(0.05 + (received / total) * 0.8, 'Downloading...');
          } else {
            report(0.45, 'Downloading...');
          }
        },
      );

      if (bytes.isEmpty) {
        throw ApiException(code: 'EMPTY_FILE', message: 'Downloaded file is empty.');
      }

      report(0.9, 'Saving to device...');
      final savedPath = await _saveBytes(ebook, bytes);
      report(0.98, 'Finishing up...');

      final record = DownloadedEbook(
        ebookId: ebook.id,
        title: ebook.title,
        author: ebook.author,
        fileType: ebook.fileType,
        coverUrl: ebook.coverUrl,
        filename: _filenameFor(ebook),
        localPath: savedPath,
        fileSizeBytes: bytes.length,
        downloadedAt: DateTime.now(),
      );

      downloads.removeWhere((item) => item.ebookId == ebook.id);
      downloads.insert(0, record);
      await _persist(downloads);

      report(1, 'Complete');
      return record;
    } finally {
      activeProgress.remove(ebook.id);
      activeStage.remove(ebook.id);
    }
  }

  Future<void> removeDownload(int ebookId) async {
    final item = findByEbookId(ebookId);
    if (item == null) return;

    final file = File(item.localPath);
    if (await file.exists()) {
      await file.delete();
    }

    downloads.removeWhere((entry) => entry.ebookId == ebookId);
    await _persist(downloads);
  }

  Future<String> _saveBytes(Ebook ebook, List<int> bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final folder = Directory('${directory.path}/downloads');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final path = '${folder.path}/${_filenameFor(ebook)}';
    await File(path).writeAsBytes(bytes, flush: true);
    return path;
  }

  String _filenameFor(Ebook ebook) {
    final extension = ebook.fileExtension.isNotEmpty ? ebook.fileExtension : '.pdf';
    final base = ebook.filename?.trim();
    if (base != null && base.isNotEmpty) {
      return 'ebook_${ebook.id}_$base';
    }
    return 'ebook_${ebook.id}$extension';
  }

  Future<void> _persist(List<DownloadedEbook> items) async {
    final prefs = await _preferences;
    await prefs.setString(
      _storageKey,
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
  }
}
