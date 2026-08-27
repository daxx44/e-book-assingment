import 'package:flutter/material.dart';
import 'package:frontend/widgets/loading_widget.dart';
import 'package:frontend/widgets/shimmer_loading.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoadingWidget shows library shimmer', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LoadingWidget(),
        ),
      ),
    );

    expect(find.byType(LibraryShimmer), findsOneWidget);
  });
}
