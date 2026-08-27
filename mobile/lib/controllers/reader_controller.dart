import 'dart:io';

import 'package:epub_view/epub_view.dart' as epub;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/services/download_service.dart';
import 'package:frontend/core/services/recently_read_service.dart';
import 'package:frontend/core/utils/app_feedback.dart';
import 'package:frontend/core/utils/download_flow.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/models/reader_search_result.dart';
import 'package:frontend/repositories/ebook_repository.dart';
import 'package:frontend/widgets/reader/reader_chapters_sheet.dart';
import 'package:frontend/widgets/reader/reader_text_search_sheet.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

enum ReaderStatus { loading, ready, error }

class ReaderController extends GetxController {
  ReaderController({
    EbookRepository? repository,
    RecentlyReadService? recentlyReadService,
  })  : _repository = repository ?? EbookRepository(),
        _recentlyReadService = recentlyReadService ?? RecentlyReadService();

  final EbookRepository _repository;
  final RecentlyReadService _recentlyReadService;
  final pdfViewerController = PdfViewerController();

  late final Ebook ebook;
  final Rx<ReaderStatus> status = ReaderStatus.loading.obs;
  final RxString errorMessage = ''.obs;
  final RxString localFilePath = ''.obs;
  final RxInt savedPage = 1.obs;
  final RxInt totalPages = 0.obs;
  final RxString currentChapter = ''.obs;
  final RxDouble fontSize = 17.0.obs;
  final RxBool isDeleting = false.obs;
  final RxInt pdfMatchCount = 0.obs;
  final RxInt pdfCurrentMatch = 0.obs;

  epub.EpubController? epubController;
  epub.EpubBook? _epubBook;
  PdfTextSearchResult? _pdfSearchResult;

  bool get isEpub => ebook.isEpub;
  bool get isPdf => ebook.isPdf;

  double get progress {
    if (totalPages.value <= 0) return 0;
    return savedPage.value / totalPages.value;
  }

  int get progressPercent => (progress * 100).clamp(0, 100).round();

  String get progressLabel {
    if (totalPages.value <= 0) return 'Page ${savedPage.value}';
    return 'Page ${savedPage.value} of ${totalPages.value}';
  }

  String get headerSubtitle {
    if (isEpub && currentChapter.value.isNotEmpty) {
      return currentChapter.value;
    }
    if (totalPages.value > 0) {
      return 'Page ${savedPage.value}';
    }
    return ebook.fileTypeLabel.toUpperCase();
  }

  @override
  void onInit() {
    super.onInit();
    ebook = Get.arguments as Ebook;
    _loadSavedPage();
    _loadFile();
  }

  Future<void> reload() async {
    await _loadFile();
  }

  Future<void> _loadSavedPage() async {
    final prefs = await SharedPreferences.getInstance();
    savedPage.value = prefs.getInt(_pageKey) ?? 1;
    fontSize.value = prefs.getDouble(_fontSizeKey) ?? 17.0;
  }

  Future<void> onPageChanged(int page) async {
    savedPage.value = page;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pageKey, page);
    await _recordRecentlyRead();
  }

  void onEpubPositionChanged(dynamic value) {
    if (value == null) return;

    final chapterTitle = value.chapter?.Title?.trim();
    if (chapterTitle != null && chapterTitle.isNotEmpty) {
      currentChapter.value = chapterTitle;
    }

    final positionIndex = value.chapterNumber;
    savedPage.value = positionIndex;
    _recordRecentlyRead();
  }

  Future<void> _recordRecentlyRead() async {
    if (status.value != ReaderStatus.ready) return;

    await _recentlyReadService.record(
      ebookId: ebook.id,
      progress: progress,
      currentPage: savedPage.value,
      totalPages: totalPages.value > 0 ? totalPages.value : null,
    );
  }

  Future<void> saveEpubLocation(String cfi) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_epubCfiKey, cfi);
  }

  Future<String?> loadEpubLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_epubCfiKey);
  }

  Future<void> setFontSize(double size) async {
    fontSize.value = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
  }

  void zoomIn() {
    if (!isPdf) return;
    final next = (pdfViewerController.zoomLevel + 0.25).clamp(1.0, 3.0);
    pdfViewerController.zoomLevel = next;
  }

  Future<void> downloadEbook() => downloadEbookWithProgress(ebook, openDownloadsTab: false);

  void openChapters() {
    if (!isEpub) return;
    final toc = epubController?.tableOfContents() ?? [];
    Get.bottomSheet(
      ReaderChaptersSheet(
        chapters: toc,
        onSelect: (index) {
          Get.back();
          epubController?.scrollTo(index: index);
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void openTextSearch() {
    Get.bottomSheet(
      Obx(
        () => ReaderTextSearchSheet(
          isPdf: isPdf,
          onSearch: searchInBook,
          onSelect: _onSearchResultSelected,
          onNextMatch: isPdf ? nextPdfMatch : null,
          onPrevMatch: isPdf ? prevPdfMatch : null,
          matchCount: pdfMatchCount.value,
          currentMatch: pdfCurrentMatch.value,
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<List<ReaderSearchResult>> searchInBook(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) return [];

    if (isPdf) {
      return _searchPdf(normalized);
    }
    return _searchEpub(normalized.toLowerCase());
  }

  Future<List<ReaderSearchResult>> _searchPdf(String query) async {
    _pdfSearchResult?.removeListener(_onPdfSearchUpdated);
    _pdfSearchResult?.clear();
    pdfMatchCount.value = 0;
    pdfCurrentMatch.value = 0;

    _pdfSearchResult = pdfViewerController.searchText(query);
    _pdfSearchResult?.addListener(_onPdfSearchUpdated);

    await Future.delayed(const Duration(milliseconds: 400));
    _onPdfSearchUpdated();

    if (pdfMatchCount.value == 0) return [];

    return [
      ReaderSearchResult(
        label: '${pdfMatchCount.value} matches found',
        excerpt: 'Use the arrows above to jump between highlights.',
      ),
    ];
  }

  Future<List<ReaderSearchResult>> _searchEpub(String query) async {
    final book = _epubBook ?? await epubController?.document;
    if (book == null) return [];

    final toc = epubController?.tableOfContents() ?? [];
    final flatChapters = <epub.EpubChapter>[];
    void walk(epub.EpubChapter chapter) {
      flatChapters.add(chapter);
      for (final sub in chapter.SubChapters ?? <epub.EpubChapter>[]) {
        walk(sub);
      }
    }
    for (final chapter in book.Chapters ?? <epub.EpubChapter>[]) {
      walk(chapter);
    }

    final results = <ReaderSearchResult>[];
    for (var i = 0; i < toc.length; i++) {
      final entry = toc[i];
      final title = entry.title ?? 'Chapter ${i + 1}';
      final startIndex = entry.startIndex;
      final body = i < flatChapters.length ? _plainText(flatChapters[i].HtmlContent) : '';
      final haystack = '$title $body'.toLowerCase();
      if (!haystack.contains(query)) continue;

      results.add(
        ReaderSearchResult(
          label: title,
          excerpt: _excerpt(body.isNotEmpty ? body : title, query),
          scrollIndex: startIndex,
        ),
      );
    }
    return results;
  }

  void _onSearchResultSelected(ReaderSearchResult result) {
    if (result.scrollIndex != null) {
      Get.back();
      epubController?.scrollTo(index: result.scrollIndex!);
    }
  }

  void nextPdfMatch() {
    _pdfSearchResult?.nextInstance();
    _onPdfSearchUpdated();
  }

  void prevPdfMatch() {
    _pdfSearchResult?.previousInstance();
    _onPdfSearchUpdated();
  }

  void _onPdfSearchUpdated() {
    final result = _pdfSearchResult;
    if (result == null) return;
    pdfMatchCount.value = result.totalInstanceCount;
    pdfCurrentMatch.value = result.currentInstanceIndex;
  }

  void onEpubDocumentLoaded(epub.EpubBook book) {
    _epubBook = book;
  }

  static String _plainText(String? html) {
    if (html == null || html.isEmpty) return '';
    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String _excerpt(String text, String query) {
    final lower = text.toLowerCase();
    final index = lower.indexOf(query);
    if (index < 0) return text.length > 80 ? '${text.substring(0, 80)}…' : text;

    final start = index > 30 ? index - 30 : 0;
    final end = (index + query.length + 50).clamp(0, text.length);
    final snippet = text.substring(start, end).trim();
    return start > 0 ? '…$snippet' : snippet;
  }

  Future<void> deleteEbook() async {
    isDeleting.value = true;
    try {
      await _repository.deleteEbook(ebook.id);
      AppFeedback.success('Removed', message: '${ebook.title} was deleted.');
      Get.back(result: true);
    } on ApiException catch (error) {
      AppFeedback.error('Delete failed', message: error.message);
    } catch (_) {
      AppFeedback.error('Delete failed', message: 'Please try again.');
    } finally {
      isDeleting.value = false;
    }
  }

  void _attachEpubListener() {
    epubController?.currentValueListenable.addListener(_epubListener);
    epubController?.isBookLoaded.addListener(_onEpubBookLoaded);
  }

  void _epubListener() {
    onEpubPositionChanged(epubController?.currentValueListenable.value);
  }

  void _onEpubBookLoaded() {
    if (epubController?.isBookLoaded.value != true) return;
    final toc = epubController?.tableOfContents() ?? [];
    if (toc.isNotEmpty && totalPages.value == 0) {
      totalPages.value = toc.length;
    }
  }

  String get _pageKey => 'reader_page_${ebook.id}';
  String get _epubCfiKey => 'reader_epub_cfi_${ebook.id}';
  String get _fontSizeKey => 'reader_font_size_${ebook.id}';

  Future<void> _loadFile() async {
    status.value = ReaderStatus.loading;
    errorMessage.value = '';
    totalPages.value = 0;
    currentChapter.value = '';

    try {
      if (Get.isRegistered<DownloadService>()) {
        final savedPath = Get.find<DownloadService>().localPathFor(ebook.id);
        if (savedPath != null && await File(savedPath).exists()) {
          await _loadFromPath(savedPath);
          return;
        }
      }

      final bytes = await _repository.downloadEbook(ebook.id);
      final directory = await getTemporaryDirectory();
      final extension = ebook.fileExtension.isNotEmpty ? ebook.fileExtension : '.pdf';
      final path = '${directory.path}/reader_${ebook.id}$extension';
      final file = File(path);
      await file.writeAsBytes(bytes, flush: true);
      await _loadFromPath(path, bytes: bytes);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
      status.value = ReaderStatus.error;
    } catch (_) {
      errorMessage.value = 'Unable to open this ebook.';
      status.value = ReaderStatus.error;
    }
  }

  Future<void> _loadFromPath(String path, {List<int>? bytes}) async {
    localFilePath.value = path;

    if (isEpub) {
      final epubBytes = bytes ?? await File(path).readAsBytes();
      await _initEpubController(epubBytes);
      _attachEpubListener();
    }

    status.value = ReaderStatus.ready;
    await _recordRecentlyRead();
  }

  Future<void> _initEpubController(List<int> bytes) async {
    final savedCfi = await loadEpubLocation();
    epubController = epub.EpubController(
      document: epub.EpubDocument.openData(Uint8List.fromList(bytes)),
      epubCfi: savedCfi,
    );
  }

  @override
  void onClose() {
    _recordRecentlyRead();
    _pdfSearchResult?.removeListener(_onPdfSearchUpdated);
    _pdfSearchResult?.clear();
    epubController?.currentValueListenable.removeListener(_epubListener);
    epubController?.isBookLoaded.removeListener(_onEpubBookLoaded);
    pdfViewerController.dispose();
    epubController?.dispose();
    super.onClose();
  }
}
