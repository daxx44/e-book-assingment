import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/repositories/ebook_repository.dart';
import 'package:frontend/screens/upload_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
    Get.put(UploadController(repository: EbookRepository()));
  });

  tearDown(Get.reset);

  testWidgets('UploadScreen shows required fields and upload button', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: UploadScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Author'), findsOneWidget);
    expect(find.text('Select ebook file'), findsOneWidget);
    expect(find.text('Cover image'), findsOneWidget);
    expect(find.text('Add to Library'), findsWidgets);
  });
}
