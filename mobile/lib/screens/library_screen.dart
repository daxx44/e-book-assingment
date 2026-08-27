import 'package:flutter/material.dart';
import 'package:frontend/controllers/library_controller.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/widgets/book_details_sheet.dart';
import 'package:frontend/widgets/delete_confirmation_dialog.dart';
import 'package:frontend/widgets/empty_state_widget.dart';
import 'package:frontend/widgets/error_state_widget.dart';
import 'package:frontend/widgets/library/bookshelf_row.dart';
import 'package:frontend/widgets/library/library_server_down_state.dart';
import 'package:frontend/widgets/library/shelf_library_header.dart';
import 'package:frontend/widgets/library/wooden_shelf_background.dart';
import 'package:frontend/widgets/loading_widget.dart';
import 'package:frontend/widgets/recently_read_section.dart';
import 'package:frontend/widgets/sort_menu.dart';
import 'package:get/get.dart';

class LibraryScreen extends GetView<LibraryController> {
  const LibraryScreen({super.key});

  int _headerBookCount() => controller.ebooks.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LibraryShelfTheme.woodDark,
      floatingActionButton: Obx(() {
        final hideFab = controller.isServerUnreachable && controller.ebooks.isEmpty;
        if (hideFab) return const SizedBox.shrink();

        return FloatingActionButton(
          onPressed: controller.openUpload,
          backgroundColor: LibraryShelfTheme.fabBrown,
          foregroundColor: Colors.white,
          elevation: 6,
          child: const Icon(Icons.add_rounded),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const WoodenShelfBackground(),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ShelfLibraryHeader(
                  bookCount: _headerBookCount(),
                  onSearch: controller.openSearch,
                  sortMenu: Obx(
                    () => SortMenu(
                      value: controller.sortBy.value,
                      onChanged: controller.changeSort,
                      iconOnly: true,
                      dark: true,
                      shelfStyle: true,
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: _buildBody(context),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (!controller.hasLoadedOnce &&
        controller.status.value == LibraryStatus.loading) {
      return const LoadingWidget(key: ValueKey('loading'));
    }

    if (controller.status.value == LibraryStatus.error &&
        controller.ebooks.isEmpty) {
      if (controller.isServerUnreachable) {
        return LibraryServerDownState(
          key: const ValueKey('server-down'),
          message: controller.errorMessage.value,
          onRetry: controller.loadEbooks,
        );
      }

      return ErrorStateWidget(
        key: const ValueKey('error'),
        message: controller.errorMessage.value,
        onRetry: controller.loadEbooks,
      );
    }

    if (controller.status.value == LibraryStatus.empty) {
      return EmptyStateWidget(
        key: const ValueKey('empty'),
        title: 'No books yet',
        message:
            'Upload your first ebook to start building your personal library.',
        actionLabel: 'Upload ebook',
        onAction: controller.openUpload,
        shelfStyle: true,
      );
    }

    return RefreshIndicator(
      key: ValueKey(
        'success-${controller.ebooks.length}-${controller.recentlyRead.length}',
      ),
      color: LibraryShelfTheme.navActive,
      backgroundColor: LibraryShelfTheme.shelfMid,
      strokeWidth: 2.5,
      displacement: 56,
      onRefresh: controller.refreshEbooks,
      child: Obx(() {
        final ebooks = controller.ebooks;
        final booksPerRow = _booksPerRow(context);
        final shelfCount = ebooks.isEmpty
            ? 0
            : (ebooks.length / booksPerRow).ceil();

        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: RecentlyReadSection(
                shelfStyle: true,
                items: controller.recentlyRead,
                ebooksById: controller.ebooksById,
                onOpen: (ebook) => _openDetails(context, ebook),
                onContinue: controller.openReader,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, shelfIndex) => BookshelfRow(
                    books: _booksOnShelf(ebooks, shelfIndex, booksPerRow),
                    booksPerRow: booksPerRow,
                    onOpenDetails: (ebook) => _openDetails(context, ebook),
                    onRead: controller.openReader,
                    onDownload: controller.downloadEbook,
                    onDelete: (ebook) => _confirmDelete(context, ebook),
                  ),
                  childCount: shelfCount,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _openDetails(BuildContext context, Ebook ebook) {
    showBookDetailsSheet(
      context,
      ebook: ebook,
      onRead: () => controller.openReader(ebook),
      onDownload: () => controller.downloadEbook(ebook),
      onDelete: () => _confirmDelete(context, ebook),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Ebook ebook) async {
    final confirmed = await showDeleteConfirmationDialog(context, ebook.title);
    if (confirmed == true) await controller.deleteEbook(ebook);
  }

  static int _booksPerRow(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 800) return 4;
    return 3;
  }

  static List<Ebook> _booksOnShelf(
    List<Ebook> ebooks,
    int shelfIndex,
    int booksPerRow,
  ) {
    final start = shelfIndex * booksPerRow;
    return ebooks.skip(start).take(booksPerRow).toList();
  }
}
