import 'package:flutter/material.dart';
import 'package:frontend/widgets/cover_preview.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CoverPreview shows initials and subtitle', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 160,
            child: CoverPreview(title: 'Clean Architecture', subtitle: 'PDF'),
          ),
        ),
      ),
    );

    expect(find.text('CA'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);
  });
}
