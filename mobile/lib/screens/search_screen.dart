import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/controllers/search_controller.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/widgets/book_details_sheet.dart';
import 'package:frontend/widgets/delete_confirmation_dialog.dart';
import 'package:frontend/widgets/library/wooden_shelf_background.dart';
import 'package:frontend/widgets/search/search_widgets.dart';
import 'package:frontend/widgets/sort_menu.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _recentKey = 'recent_searches';
  List<String> _recentSearches = [];

  EbookSearchController get controller => Get.find<EbookSearchController>();

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _recentSearches = prefs.getStringList(_recentKey) ?? []);
  }

  Future<void> _saveRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final updated = [trimmed, ..._recentSearches.where((item) => item != trimmed)].take(6).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentKey, updated);
    if (mounted) setState(() => _recentSearches = updated);
  }

  void _onSearchChanged(String value) {
    controller.onQueryChanged(value);
    if (value.trim().isNotEmpty) _saveRecentSearch(value);
  }

  void _applySearchTerm(String term) {
    controller.searchController.text = term;
    controller.search(term);
    _saveRecentSearch(term);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SearchHeader(onBack: Get.back),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 10),
                    child: ShelfSearchField(
                      controller: controller.searchController,
                      onChanged: _onSearchChanged,
                      autofocus: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Obx(() {
                      final count = controller.results.length;
                      final isSuccess = controller.status.value == SearchStatus.success;
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              isSuccess ? '$count ${count == 1 ? 'result' : 'results'}' : ' ',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: LibraryShelfTheme.headerMuted,
                                  ),
                            ),
                          ),
                          SortMenu(
                            value: controller.sortBy.value,
                            onChanged: controller.changeSort,
                            dark: true,
                            showCurrentLabel: true,
                          ),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Obx(() {
                      final query = controller.searchController.text;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOutCubic,
                        child: _buildResults(context, query),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, String query) {
    switch (controller.status.value) {
      case SearchStatus.idle:
        return SearchIdlePanel(
          key: const ValueKey('idle'),
          recentSearches: _recentSearches,
          onTermTap: _applySearchTerm,
        );
      case SearchStatus.loading:
        if (controller.results.isNotEmpty) {
          return _ResultsList(
            key: ValueKey('results-loading-${controller.results.length}'),
            query: query,
            results: controller.results,
            onOpen: (ebook) => _openDetails(context, ebook),
          );
        }
        return const SearchListShimmer(key: ValueKey('loading'));
      case SearchStatus.error:
        return SearchErrorState(
          key: const ValueKey('error'),
          message: controller.errorMessage.value,
          onRetry: () => controller.search(controller.searchController.text),
        );
      case SearchStatus.empty:
        return SearchEmptyState(key: const ValueKey('empty'), query: query);
      case SearchStatus.success:
        return _ResultsList(
          key: ValueKey('results-${controller.results.length}'),
          query: query,
          results: controller.results,
          onOpen: (ebook) => _openDetails(context, ebook),
        );
    }
  }

  void _openDetails(BuildContext context, ebook) {
    showBookDetailsSheet(
      context,
      ebook: ebook,
      onRead: () => controller.openReader(ebook),
      onDownload: () => controller.downloadEbook(ebook),
      onDelete: () async {
        final confirmed = await showDeleteConfirmationDialog(context, ebook.title);
        if (confirmed == true) await controller.deleteEbook(ebook);
      },
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
      child: Row(
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(12),
              child: const SizedBox(
                width: 42,
                height: 42,
                child: Icon(Icons.arrow_back_rounded, color: LibraryShelfTheme.headerText, size: 22),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: LibraryShelfTheme.headerText,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find titles across your shelf',
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

class _ResultsList extends StatelessWidget {
  const _ResultsList({
    super.key,
    required this.query,
    required this.results,
    required this.onOpen,
  });

  final String query;
  final List<Ebook> results;
  final void Function(Ebook ebook) onOpen;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 8, AppSpacing.lg, 100),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final ebook = results[index];
        return SearchResultTile(
          ebook: ebook,
          query: query,
          onTap: () => onOpen(ebook),
        );
      },
    );
  }
}
