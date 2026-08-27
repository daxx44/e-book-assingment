import 'package:flutter/material.dart';
import 'package:frontend/core/theme/reader_theme.dart';

class ReaderContentHeader extends StatelessWidget {
  const ReaderContentHeader({
    super.key,
    required this.title,
    this.author,
    this.subtitle,
  });

  final String title;
  final String? author;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Column(
        children: [
          Text(
            title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: ReaderTheme.titleSerif,
          ),
          if (author != null && author!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              author!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: ReaderTheme.authorStyle,
            ),
          ],
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: ReaderTheme.chapterLabelStyle,
            ),
          ],
          const SizedBox(height: 14),
          Container(
            width: 48,
            height: 2,
            decoration: BoxDecoration(
              color: ReaderTheme.accent.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}
