import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/controllers/dashboard_controller.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/screens/about_screen.dart';
import 'package:frontend/screens/downloads_screen.dart';
import 'package:frontend/screens/library_screen.dart';
import 'package:frontend/widgets/dashboard/dashboard_bottom_nav.dart';
import 'package:get/get.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Obx(
        () => Scaffold(
          backgroundColor: LibraryShelfTheme.woodDark,
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              LibraryScreen(),
              DownloadsScreen(),
              AboutScreen(),
            ],
          ),
          bottomNavigationBar: DashboardBottomNav(
            currentIndex: controller.currentIndex.value,
            onChanged: controller.selectTab,
          ),
        ),
      ),
    );
  }
}
