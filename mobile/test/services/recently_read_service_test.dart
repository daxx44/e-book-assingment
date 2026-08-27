import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/services/recently_read_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('RecentlyReadService stores and returns recent reads in order', () async {
    final service = RecentlyReadService();

    await service.record(ebookId: 1, progress: 0.2, currentPage: 2, totalPages: 10);
    await service.record(ebookId: 2, progress: 0.5, currentPage: 5, totalPages: 10);
    await service.record(ebookId: 1, progress: 0.4, currentPage: 4, totalPages: 10);

    final items = await service.loadAll();
    expect(items.length, 2);
    expect(items.first.ebookId, 1);
    expect(items.first.progress, 0.4);
    expect(items.last.ebookId, 2);
  });

  test('RecentlyReadService removes deleted ebook entries', () async {
    final service = RecentlyReadService();
    await service.record(ebookId: 3, progress: 0.1);

    await service.remove(3);

    expect(await service.loadAll(), isEmpty);
  });
}
