import 'package:flutter/material.dart';
import 'package:frontend/widgets/highlighted_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HighlightedText bolds matching query', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HighlightedText(text: 'Flutter Guides', query: 'guide'),
        ),
      ),
    );

    expect(find.byType(RichText), findsOneWidget);
  });
}
