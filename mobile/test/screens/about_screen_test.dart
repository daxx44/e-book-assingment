import 'package:flutter/material.dart';
import 'package:frontend/screens/about_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AboutScreen shows app and developer info', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
    await tester.pumpAndSettle();

    expect(find.text('About'), findsOneWidget);
    expect(find.text('Digital Ebook Library'), findsOneWidget);
    expect(find.text('Version 1.0.0'), findsOneWidget);
    expect(find.text('Darshan Chaitanyswami'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('© 2026 Darshan Chaitanyswami'), findsOneWidget);
  });
}
