import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/reader_theme.dart';
import 'package:frontend/models/reader_search_result.dart';

class ReaderTextSearchSheet extends StatefulWidget {
  const ReaderTextSearchSheet({
    super.key,
    required this.isPdf,
    required this.onSearch,
    required this.onSelect,
    this.onNextMatch,
    this.onPrevMatch,
    this.matchCount = 0,
    this.currentMatch = 0,
  });

  final bool isPdf;
  final Future<List<ReaderSearchResult>> Function(String query) onSearch;
  final ValueChanged<ReaderSearchResult> onSelect;
  final VoidCallback? onNextMatch;
  final VoidCallback? onPrevMatch;
  final int matchCount;
  final int currentMatch;

  @override
  State<ReaderTextSearchSheet> createState() => _ReaderTextSearchSheetState();
}

class _ReaderTextSearchSheetState extends State<ReaderTextSearchSheet> {
  final _queryController = TextEditingController();
  List<ReaderSearchResult> _results = [];
  bool _isSearching = false;
  String _lastQuery = '';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _runSearch() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _lastQuery = query;
    });

    final results = await widget.onSearch(query);
    if (!mounted) return;

    setState(() {
      _results = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pdfMatches = widget.isPdf && widget.matchCount > 0;

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.75),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: ReaderTheme.iconColor, size: 22),
                const SizedBox(width: 10),
                Text('Search in book', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: TextField(
              controller: _queryController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _runSearch(),
              decoration: InputDecoration(
                hintText: 'Search for text…',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  onPressed: _runSearch,
                ),
              ),
            ),
          ),
          if (pdfMatches)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${widget.currentMatch} of ${widget.matchCount} matches',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Previous match',
                    onPressed: widget.onPrevMatch,
                    icon: const Icon(Icons.keyboard_arrow_up_rounded),
                  ),
                  IconButton(
                    tooltip: 'Next match',
                    onPressed: widget.onNextMatch,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                ],
              ),
            ),
          const Divider(height: 1),
          if (_isSearching)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            )
          else if (_lastQuery.isNotEmpty && _results.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No results for "$_lastQuery"',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _results.length,
                separatorBuilder: (_, __) => const Divider(height: 1, indent: 20, endIndent: 20),
                itemBuilder: (context, index) {
                  final result = _results[index];
                  return ListTile(
                    title: Text(result.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      result.excerpt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => widget.onSelect(result),
                  );
                },
              ),
            ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}
