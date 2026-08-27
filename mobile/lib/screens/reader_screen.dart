import 'dart:io';

import 'package:epub_view/epub_view.dart' as epub;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/controllers/reader_controller.dart';
import 'package:frontend/core/theme/reader_theme.dart';
import 'package:frontend/widgets/delete_confirmation_dialog.dart';
import 'package:frontend/widgets/reader/reader_content_header.dart';
import 'package:frontend/widgets/reader/reader_error_state.dart';
import 'package:frontend/widgets/reader/reader_progress_footer.dart';
import 'package:frontend/widgets/loading_widget.dart';
import 'package:frontend/widgets/reader/reader_settings_sheet.dart';
import 'package:frontend/widgets/reader/reader_toolbar.dart';
import 'package:frontend/widgets/safe_epub_chapter_builder.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReaderScreen extends GetView<ReaderController> {
  const ReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: ReaderTheme.canvasBackground,
        body: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ReaderToolbar(
                onBack: Get.back,
                showChapters: controller.isEpub,
                onChapters: controller.isEpub ? controller.openChapters : null,
                onTextSearch: controller.openTextSearch,
                onZoomIn: controller.isPdf ? controller.zoomIn : null,
                showZoom: controller.isPdf,
                onDownload: controller.downloadEbook,
                onDelete: () => _confirmDelete(context),
                onSettings: () => showReaderSettingsSheet(
                  context,
                  fontSize: controller.fontSize.value,
                  onFontSizeChanged: controller.setFontSize,
                ),
              ),
              Expanded(child: _buildBody(context)),
              if (controller.status.value == ReaderStatus.ready)
                Obx(
                  () => ReaderProgressFooter(
                    currentLabel: controller.progressLabel,
                    progress: controller.progress,
                    percentText: '${controller.progressPercent}%',
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (controller.status.value) {
      case ReaderStatus.loading:
        return const LoadingWidget(key: ValueKey('loading'), variant: LoadingVariant.reader);
      case ReaderStatus.error:
        return ReaderErrorState(
          key: const ValueKey('error'),
          message: controller.errorMessage.value,
          onRetry: controller.reload,
        );
      case ReaderStatus.ready:
        if (controller.isEpub) {
          return _buildEpubViewer(context);
        }
        return _buildPdfViewer(context);
    }
  }

  Widget _buildPdfViewer(BuildContext context) {
    return DecoratedBox(
      key: const ValueKey('pdf-reader'),
      decoration: const BoxDecoration(gradient: ReaderTheme.canvasGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(
            () => ReaderContentHeader(
              title: controller.ebook.title,
              author: controller.ebook.author,
              subtitle: controller.headerSubtitle,
            ),
          ),
          Expanded(
            child: SfPdfViewer.file(
              File(controller.localFilePath.value),
              controller: controller.pdfViewerController,
              canShowScrollHead: false,
              canShowPaginationDialog: false,
              canShowPageLoadingIndicator: true,
              enableDoubleTapZooming: true,
              pageSpacing: 0,
              onDocumentLoaded: (details) {
                controller.totalPages.value = details.document.pages.count;
                final page = controller.savedPage.value;
                if (page > 1 && page <= controller.totalPages.value) {
                  controller.pdfViewerController.jumpToPage(page);
                }
              },
              onPageChanged: (details) => controller.onPageChanged(details.newPageNumber),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpubViewer(BuildContext context) {
    final epubCtrl = controller.epubController;
    if (epubCtrl == null) {
      return ReaderErrorState(
        key: const ValueKey('epub-error'),
        message: 'Failed to load EPUB content.',
        onRetry: controller.reload,
      );
    }

    return DecoratedBox(
      key: const ValueKey('epub-reader'),
      decoration: const BoxDecoration(gradient: ReaderTheme.canvasGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(
            () => ReaderContentHeader(
              title: controller.ebook.title,
              author: controller.ebook.author,
              subtitle: controller.headerSubtitle,
            ),
          ),
          Expanded(
            child: Obx(
              () => epub.EpubView(
                controller: epubCtrl,
                onChapterChanged: (value) {
                  controller.onEpubPositionChanged(value);
                  final cfi = epubCtrl.generateEpubCfi();
                  if (cfi != null) controller.saveEpubLocation(cfi);
                },
                onDocumentLoaded: (book) {
                  controller.onEpubDocumentLoaded(book);
                  final toc = epubCtrl.tableOfContents();
                  if (toc.isNotEmpty) {
                    controller.totalPages.value = toc.length;
                  }
                },
                builders: epub.EpubViewBuilders<epub.DefaultBuilderOptions>(
                  options: epub.DefaultBuilderOptions(
                    textStyle: ReaderTheme.bodySerif(controller.fontSize.value),
                    paragraphPadding: EdgeInsets.zero,
                  ),
                  chapterBuilder: (
                    ctx,
                    builders,
                    document,
                    chapters,
                    paragraphs,
                    index,
                    chapterIndex,
                    paragraphIndex,
                    onLink,
                  ) =>
                      safeEpubChapterBuilder(
                    ctx,
                    builders,
                    document,
                    chapters,
                    paragraphs,
                    index,
                    chapterIndex,
                    paragraphIndex,
                    onLink,
                    fontSize: controller.fontSize.value,
                  ),
                  chapterDividerBuilder: (_) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDeleteConfirmationDialog(context, controller.ebook.title);
    if (confirmed == true) await controller.deleteEbook();
  }
}
