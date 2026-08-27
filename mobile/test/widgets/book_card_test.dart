import 'package:flutter/material.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/widgets/book_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ebook = Ebook(
    id: 1,
    title: 'Clean Architecture',
    author: 'Robert Martin',
    status: 'active',
    fileType: 'application/pdf',
    fileSize: 1024,
    filename: 'clean.pdf',
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  testWidgets('BookCard renders title, author, and menu', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 180,
            height: 320,
            child: BookCard(
              ebook: ebook,
              onTap: () {},
              onDownload: () {},
              onDelete: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Clean Architecture'), findsOneWidget);
    expect(find.text('Robert Martin'), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz_rounded), findsOneWidget);
  });

  testWidgets('BookCard highlights search query', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 180,
            height: 320,
            child: BookCard(
              ebook: ebook,
              highlightQuery: 'Clean',
              onTap: () {},
              onDownload: () {},
              onDelete: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(RichText), findsWidgets);
  });
}
