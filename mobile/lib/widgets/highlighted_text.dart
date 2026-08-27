import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText({
    super.key,
    required this.text,
    this.query = '',
    this.style,
    this.maxLines,
    this.highlightBackground,
    this.highlightColor,
  });

  final String text;
  final String query;
  final TextStyle? style;
  final int? maxLines;
  final Color? highlightBackground;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      return Text(text, style: style, maxLines: maxLines, overflow: TextOverflow.ellipsis);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = normalizedQuery.toLowerCase();
    final spans = <TextSpan>[];
    var start = 0;
    final baseStyle = style ?? DefaultTextStyle.of(context).style;
    final highlightBg = highlightBackground ?? Theme.of(context).colorScheme.primaryContainer;
    final highlightFg = highlightColor ?? baseStyle.color;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index < 0) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) spans.add(TextSpan(text: text.substring(start, index)));
      spans.add(
        TextSpan(
          text: text.substring(index, index + normalizedQuery.length),
          style: baseStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: highlightFg,
            backgroundColor: highlightBg,
          ),
        ),
      );
      start = index + normalizedQuery.length;
    }

    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(style: baseStyle, children: spans),
    );
  }
}
