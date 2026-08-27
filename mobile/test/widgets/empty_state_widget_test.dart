import 'package:flutter/material.dart';
import 'package:frontend/widgets/empty_state_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EmptyStateWidget renders title and message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyStateWidget(
            title: 'No books yet',
            message: 'Upload your first PDF.',
          ),
        ),
      ),
    );

    expect(find.text('No books yet'), findsOneWidget);
    expect(find.text('Upload your first PDF.'), findsOneWidget);
  });
}
