import 'package:flutter/material.dart';
import 'package:frontend/controllers/dashboard_controller.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/services/download_service.dart';
import 'package:frontend/core/utils/app_feedback.dart';
import 'package:frontend/core/utils/app_haptics.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/widgets/download/download_progress_sheet.dart';
import 'package:get/get.dart';

Future<void> downloadEbookWithProgress(Ebook ebook, {bool openDownloadsTab = true}) async {
  if (!Get.isRegistered<DownloadService>()) {
    Get.put(DownloadService(), permanent: true);
  }

  final downloadService = Get.find<DownloadService>();

  if (downloadService.isDownloaded(ebook.id)) {
    AppFeedback.info('Already downloaded', message: '${ebook.title} is in your downloads.');
    if (openDownloadsTab && Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().selectTab(DashboardController.tabDownloads);
    }
    return;
  }

  if (downloadService.activeProgress.containsKey(ebook.id)) {
    AppFeedback.info('Download in progress', message: 'Please wait for the current download.');
    return;
  }

  AppHaptics.light();
  Get.bottomSheet(
    DownloadProgressSheet(ebook: ebook),
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
  );

  try {
    await downloadService.download(ebook);
    if (Get.isBottomSheetOpen ?? false) Get.back();
    AppFeedback.success('Download complete', message: ebook.title);
    if (openDownloadsTab && Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().selectTab(DashboardController.tabDownloads);
    }
  } on ApiException catch (error) {
    if (Get.isBottomSheetOpen ?? false) Get.back();
    AppFeedback.error('Download failed', message: error.message);
  } catch (_) {
    if (Get.isBottomSheetOpen ?? false) Get.back();
    AppFeedback.error('Download failed', message: 'Please try again.');
  }
}
