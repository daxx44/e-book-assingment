import 'package:get/get.dart';

class DashboardController extends GetxController {
  static const tabLibrary = 0;
  static const tabDownloads = 1;
  static const tabAbout = 2;

  final currentIndex = tabLibrary.obs;

  void selectTab(int index) {
    if (index < tabLibrary || index > tabAbout) return;
    currentIndex.value = index;
  }
}
