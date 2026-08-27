import 'package:flutter/material.dart';
import 'package:frontend/controllers/search_controller.dart';
import 'package:frontend/screens/search_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
    Get.put(EbookSearchController());
  });

  tearDown(Get.reset);

  testWidgets('SearchScreen shows idle empty state', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: SearchScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Search your library'), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsWidgets);
  });
}
