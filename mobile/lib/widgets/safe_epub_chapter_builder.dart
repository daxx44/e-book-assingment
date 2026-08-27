import 'dart:typed_data';

import 'package:epub_view/epub_view.dart' as epub;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:frontend/core/theme/reader_theme.dart';

/// Safe replacement for epub_view's default chapter builder.
///
/// The stock builder crashes on EPUBs with missing or unresolved image refs
/// because it force-unwraps `document.Content!.Images![url]!.Content!`.
Widget safeEpubChapterBuilder(
  BuildContext context,
  epub.EpubViewBuilders builders,
  epub.EpubBook document,
  List<epub.EpubChapter> chapters,
  List paragraphs,
  int index,
  int chapterIndex,
  int paragraphIndex,
  void Function(String href) onExternalLinkPressed, {
  double fontSize = 17,
}) {
  if (paragraphs.isEmpty) return const SizedBox.shrink();

  final paragraph = paragraphs[index];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 28),
    child: Html(
      data: paragraph.element.outerHtml,
      onLinkTap: (href, _, __) {
        if (href != null) onExternalLinkPressed(href);
      },
      style: {
        'html': Style(
          padding: HtmlPaddings.zero,
          margin: Margins.zero,
        ).merge(Style.fromTextStyle(ReaderTheme.bodySerif(fontSize))),
        'p': Style(
          margin: Margins.only(bottom: 18),
        ),
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
      },
      extensions: [
        TagExtension(
          tagsToExtend: const {'img'},
          builder: (imageContext) => _buildSafeImage(document, imageContext),
        ),
      ],
    ),
  );
}

Widget _buildSafeImage(epub.EpubBook document, ExtensionContext imageContext) {
  final src = imageContext.attributes['src'];
  if (src == null || src.isEmpty) return const SizedBox.shrink();

  final url = src.replaceAll('../', '');
  final images = document.Content?.Images;
  if (images == null) return const SizedBox.shrink();

  final imageEntry = images[url] ?? images[Uri.decodeFull(url)];
  final content = imageEntry?.Content;
  if (content == null || content.isEmpty) return const SizedBox.shrink();

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Image(
      image: MemoryImage(Uint8List.fromList(content)),
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    ),
  );
}
