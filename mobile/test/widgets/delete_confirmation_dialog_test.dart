import 'package:flutter/material.dart';
import 'package:frontend/widgets/delete_confirmation_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Delete confirmation sheet returns true when confirmed', (tester) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await showDeleteConfirmationDialog(context, 'Sample Book');
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Delete ebook?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });
}
