import 'package:frontend/controllers/dashboard_controller.dart';
import 'package:frontend/controllers/downloads_controller.dart';
import 'package:frontend/controllers/library_controller.dart';
import 'package:frontend/controllers/reader_controller.dart';
import 'package:frontend/controllers/search_controller.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/core/services/download_service.dart';
import 'package:frontend/core/theme/app_transitions.dart';
import 'package:frontend/screens/dashboard_screen.dart';
import 'package:frontend/screens/reader_screen.dart';
import 'package:frontend/screens/search_screen.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'package:frontend/screens/upload_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const library = '/';
  static const upload = '/upload';
  static const search = '/search';
  static const reader = '/reader';
}

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    AppTransitions.page(
      name: AppRoutes.library,
      page: () => const DashboardScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<DownloadService>()) {
          Get.put(DownloadService(), permanent: true);
        }
        Get.lazyPut(DashboardController.new);
        Get.lazyPut(LibraryController.new);
        Get.lazyPut(DownloadsController.new);
      }),
    ),
    AppTransitions.page(
      name: AppRoutes.upload,
      page: () => const UploadScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(UploadController.new)),
      fullscreen: true,
    ),
    AppTransitions.page(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(EbookSearchController.new)),
    ),
    AppTransitions.fade(
      name: AppRoutes.reader,
      page: () => const ReaderScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<DownloadService>()) {
          Get.put(DownloadService(), permanent: true);
        }
        Get.lazyPut(ReaderController.new);
      }),
    ),
  ];
}
