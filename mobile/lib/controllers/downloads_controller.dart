import 'package:frontend/core/services/download_service.dart';
import 'package:frontend/core/utils/app_feedback.dart';
import 'package:frontend/core/utils/app_haptics.dart';
import 'package:frontend/models/downloaded_ebook.dart';
import 'package:frontend/routes/app_pages.dart';
import 'package:get/get.dart';

class DownloadsController extends GetxController {
  DownloadsController({DownloadService? downloadService})
      : _downloadService = downloadService ?? Get.find<DownloadService>();

  final DownloadService _downloadService;

  List<DownloadedEbook> get items => _downloadService.downloads;

  @override
  void onInit() {
    super.onInit();
    _downloadService.loadDownloads();
  }

  @override
  Future<void> refresh() => _downloadService.loadDownloads();

  void openReader(DownloadedEbook item) {
    AppHaptics.medium();
    Get.toNamed(
      AppRoutes.reader,
      arguments: _downloadService.toEbook(item),
    );
  }

  Future<void> remove(DownloadedEbook item) async {
    AppHaptics.light();
    await _downloadService.removeDownload(item.ebookId);
    AppFeedback.success('Removed', message: '${item.title} was deleted from downloads.');
  }
}
