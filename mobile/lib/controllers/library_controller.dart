import 'package:frontend/core/services/recently_read_service.dart';
import 'package:frontend/core/utils/app_feedback.dart';
import 'package:frontend/core/utils/app_haptics.dart';
import 'package:frontend/core/utils/download_flow.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/models/recent_read_entry.dart';
import 'package:frontend/repositories/ebook_repository.dart';
import 'package:frontend/routes/app_pages.dart';
import 'package:get/get.dart';

enum LibraryStatus { loading, success, empty, error }

class LibraryController extends GetxController {
  LibraryController({
    EbookRepository? repository,
    RecentlyReadService? recentlyReadService,
  })  : _repository = repository ?? EbookRepository(),
        _recentlyReadService = recentlyReadService ?? RecentlyReadService();

  final EbookRepository _repository;
  final RecentlyReadService _recentlyReadService;

  final Rx<LibraryStatus> status = LibraryStatus.loading.obs;
  final RxList<Ebook> ebooks = <Ebook>[].obs;
  final RxList<RecentReadItem> recentlyRead = <RecentReadItem>[].obs;
  final RxString errorMessage = ''.obs;
  final RxString errorCode = ''.obs;
  final RxnInt errorStatusCode = RxnInt();
  final RxBool isDeleting = false.obs;
  final RxString sortBy = 'recent'.obs;

  bool _hasLoadedOnce = false;
  bool get hasLoadedOnce => _hasLoadedOnce;

  bool get isServerUnreachable {
    if (status.value != LibraryStatus.error) return false;

    const unreachableCodes = {
      'NETWORK_ERROR',
      'TIMEOUT',
      'SERVER_UNAVAILABLE',
    };
    if (unreachableCodes.contains(errorCode.value)) return true;

    final code = errorStatusCode.value;
    return code != null && code >= 502 && code < 600;
  }

  @override
  void onInit() {
    super.onInit();
    loadEbooks();
  }

  /// Refreshes the library in the background without showing the initial shimmer.
  Future<void> refreshEbooks() => loadEbooks(background: true);

  Future<void> loadEbooks({bool background = false}) async {
    final showInitialLoader = !background && !_hasLoadedOnce;

    if (showInitialLoader) {
      status.value = LibraryStatus.loading;
    }
    errorMessage.value = '';
    errorCode.value = '';
    errorStatusCode.value = null;

    try {
      final results = await _repository.fetchEbooks(sort: sortBy.value);
      ebooks.assignAll(results);
      await _loadRecentlyRead();
      _hasLoadedOnce = true;
      status.value = results.isEmpty ? LibraryStatus.empty : LibraryStatus.success;
    } on ApiException catch (error) {
      if (background && ebooks.isNotEmpty) return;
      errorCode.value = error.code;
      errorStatusCode.value = error.statusCode;
      errorMessage.value = error.message;
      status.value = LibraryStatus.error;
      _hasLoadedOnce = true;
    } catch (_) {
      if (background && ebooks.isNotEmpty) return;
      errorCode.value = 'NETWORK_ERROR';
      errorStatusCode.value = null;
      errorMessage.value =
          'Unable to reach the server. Start the backend and check your API settings.';
      status.value = LibraryStatus.error;
      _hasLoadedOnce = true;
    }
  }

  Future<void> deleteEbook(Ebook ebook) async {
    isDeleting.value = true;
    try {
      await _repository.deleteEbook(ebook.id);
      await _recentlyReadService.remove(ebook.id);
      ebooks.removeWhere((item) => item.id == ebook.id);
      recentlyRead.removeWhere((item) => item.ebookId == ebook.id);
      status.value = ebooks.isEmpty ? LibraryStatus.empty : LibraryStatus.success;
      AppFeedback.success('Removed', message: '${ebook.title} was deleted.');
    } on ApiException catch (error) {
      AppFeedback.error('Delete failed', message: error.message);
    } catch (_) {
      AppFeedback.error('Delete failed', message: 'Please try again.');
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> downloadEbook(Ebook ebook) => downloadEbookWithProgress(ebook);

  void changeSort(String value) {
    sortBy.value = value;
    AppHaptics.selection();
    loadEbooks(background: hasLoadedOnce);
  }

  void openReader(Ebook ebook) {
    AppHaptics.medium();
    Get.toNamed(AppRoutes.reader, arguments: ebook)?.then((_) => _loadRecentlyRead());
  }

  Future<void> _loadRecentlyRead() async {
    final entries = await _recentlyReadService.loadAll();
    final libraryIds = ebooks.map((book) => book.id).toSet();
    recentlyRead.assignAll(entries.where((entry) => libraryIds.contains(entry.ebookId)));
  }

  Map<int, Ebook> get ebooksById => {for (final book in ebooks) book.id: book};

  void openUpload() {
    AppHaptics.light();
    Get.toNamed(AppRoutes.upload)?.then((_) => refreshEbooks());
  }

  void openSearch() {
    AppHaptics.light();
    Get.toNamed(AppRoutes.search)?.then((_) => refreshEbooks());
  }
}
