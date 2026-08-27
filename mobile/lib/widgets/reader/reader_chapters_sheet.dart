import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/reader_theme.dart';

class ReaderChaptersSheet extends StatelessWidget {
  const ReaderChaptersSheet({
    super.key,
    required this.chapters,
    required this.onSelect,
  });

  final List chapters;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
      decoration: const BoxDecoration(
        color: ReaderTheme.toolbarBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
        border: Border(top: BorderSide(color: ReaderTheme.borderColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ReaderTheme.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Icon(Icons.menu_book_rounded, color: ReaderTheme.iconColor, size: 22),
                const SizedBox(width: 10),
                Text('Chapters', style: ReaderTheme.titleSerif.copyWith(fontSize: 20)),
              ],
            ),
          ),
          const Divider(height: 1, color: ReaderTheme.borderColor),
          Flexible(
            child: chapters.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No chapters available.',
                      style: ReaderTheme.authorStyle,
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: chapters.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                      color: ReaderTheme.borderColor,
                    ),
                    itemBuilder: (context, index) {
                      final chapter = chapters[index];
                      final title = chapter.title;
                      final startIndex = chapter.startIndex;
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: ReaderTheme.footerBackground,
                          child: Text(
                            '${index + 1}',
                            style: ReaderTheme.footerLabelStyle.copyWith(fontSize: 11),
                          ),
                        ),
                        title: Text(
                          title ?? 'Chapter ${index + 1}',
                          style: ReaderTheme.toolbarTitleStyle.copyWith(fontSize: 14),
                        ),
                        onTap: () => onSelect(startIndex),
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
