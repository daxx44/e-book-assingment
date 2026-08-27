import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/controllers/library_controller.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/repositories/ebook_repository.dart';
import 'package:frontend/screens/library_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeEbookRepository extends EbookRepository {
  FakeEbookRepository(this.ebooks, {this.onFetch});

  final List<Ebook> ebooks;
  final Future<List<Ebook>> Function()? onFetch;

  @override
  Future<List<Ebook>> fetchEbooks({String sort = 'recent'}) async {
    if (onFetch != null) return onFetch!();
    return ebooks;
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    Get.reset();
  });

  tearDown(Get.reset);

  testWidgets('LibraryScreen shows empty state when no ebooks', (tester) async {
    Get.put(LibraryController(repository: FakeEbookRepository([])));

    await tester.pumpWidget(const GetMaterialApp(home: LibraryScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('No books yet'), findsOneWidget);
  });

  testWidgets('LibraryScreen shows bookshelf when ebooks exist', (tester) async {
    final ebooks = [
      Ebook(
        id: 1,
        title: 'Book One',
        author: 'Author',
        status: 'active',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    ];
    Get.put(LibraryController(repository: FakeEbookRepository(ebooks)));

    await tester.pumpWidget(const GetMaterialApp(home: LibraryScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Book One'), findsWidgets);
    expect(find.text('My Library'), findsOneWidget);
  });

  testWidgets('LibraryScreen shows server down state when backend is unreachable', (tester) async {
    Get.put(
      LibraryController(
        repository: FakeEbookRepository(
          [],
          onFetch: () => throw ApiException(
            code: 'NETWORK_ERROR',
            message: 'Unable to reach the server.',
          ),
        ),
      ),
    );

    await tester.pumpWidget(const GetMaterialApp(home: LibraryScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Server unavailable'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Run the Rails API on port 3000'), findsOneWidget);
  });
}
