import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/widgets/library/wooden_shelf_background.dart';
import 'package:frontend/widgets/upload/upload_form_widgets.dart';
import 'package:frontend/widgets/upload/upload_progress_view.dart';
import 'package:frontend/widgets/upload/upload_success_view.dart';
import 'package:get/get.dart';

class UploadScreen extends GetView<UploadController> {
  const UploadScreen({super.key});

  Future<void> _handleUpload() async {
    final success = await controller.upload();
    if (!success) return;

    await Future.delayed(const Duration(milliseconds: 1200));
    await controller.finishAndReturnHome();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: LibraryShelfTheme.woodDark,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const WoodenShelfBackground(),
            SafeArea(
              child: Obx(() {
                if (controller.showSuccess.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _UploadHeader(onClose: () => controller.finishAndReturnHome()),
                      Expanded(
                        child: UploadSuccessView(
                          title: controller.titleController.text.trim(),
                          onGoToLibrary: () => controller.finishAndReturnHome(),
                        ),
                      ),
                    ],
                  );
                }

                if (controller.isUploading.value) {
                  return UploadProgressView(progress: controller.uploadProgress.value);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _UploadHeader(onClose: Get.back),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          AppSpacing.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Obx(
                              () => EbookFilePickerCard(
                                fileName: controller.selectedFileName.value,
                                onPick: controller.pickFile,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            const UploadSectionLabel('Book details'),
                            ShelfFormField(
                              controller: controller.titleController,
                              label: 'Title',
                              hint: 'Enter book title',
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            ShelfFormField(
                              controller: controller.authorController,
                              label: 'Author',
                              hint: 'Optional',
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            ShelfFormField(
                              controller: controller.descriptionController,
                              label: 'Description',
                              hint: 'Optional notes about this book',
                              maxLines: 3,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            const UploadSectionLabel('Cover'),
                            Obx(
                              () => CoverImagePickerCard(
                                coverPath: controller.coverImagePath.value,
                                onPick: controller.pickCoverImage,
                                onRemove: controller.removeCoverImage,
                              ),
                            ),
                            if (controller.errorMessage.value.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.md),
                              UploadErrorBanner(message: controller.errorMessage.value),
                            ],
                            const SizedBox(height: AppSpacing.xl),
                            Obx(
                              () => ShelfUploadButton(
                                label: 'Add to Library',
                                icon: Icons.library_add_rounded,
                                isLoading: controller.isUploading.value,
                                onPressed: controller.isUploading.value ? null : _handleUpload,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadHeader extends StatelessWidget {
  const _UploadHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(12),
              child: const SizedBox(
                width: 42,
                height: 42,
                child: Icon(Icons.close_rounded, color: LibraryShelfTheme.headerText, size: 22),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add to Library',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: LibraryShelfTheme.headerText,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Upload a PDF or EPUB to your shelf',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: LibraryShelfTheme.headerMuted,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
