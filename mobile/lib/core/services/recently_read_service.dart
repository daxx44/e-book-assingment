import 'dart:convert';

import 'package:frontend/models/recent_read_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentlyReadService {
  RecentlyReadService({SharedPreferences? prefs}) : _prefs = prefs;

  static const _storageKey = 'recently_read_entries';
  static const maxEntries = 10;

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> record({
    required int ebookId,
    required double progress,
    int? currentPage,
    int? totalPages,
  }) async {
    final prefs = await _preferences;
    final entries = await _loadRaw();
    entries.removeWhere((entry) => entry.ebookId == ebookId);
    entries.insert(
      0,
      RecentReadEntry(
        ebookId: ebookId,
        readAt: DateTime.now(),
        progress: progress.clamp(0.0, 1.0),
        currentPage: currentPage,
        totalPages: totalPages,
      ),
    );

    final trimmed = entries.take(maxEntries).toList();
    await prefs.setString(_storageKey, jsonEncode(trimmed.map((e) => e.toJson()).toList()));
  }

  Future<List<RecentReadItem>> loadAll() async {
    final entries = await _loadRaw();
    return entries
        .map(
          (entry) => RecentReadItem(
            ebookId: entry.ebookId,
            readAt: entry.readAt,
            progress: entry.progress,
            currentPage: entry.currentPage,
            totalPages: entry.totalPages,
          ),
        )
        .toList();
  }

  Future<void> remove(int ebookId) async {
    final prefs = await _preferences;
    final entries = await _loadRaw();
    entries.removeWhere((entry) => entry.ebookId == ebookId);
    await prefs.setString(_storageKey, jsonEncode(entries.map((e) => e.toJson()).toList()));
  }

  Future<List<RecentReadEntry>> _loadRaw() async {
    final prefs = await _preferences;
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => RecentReadEntry.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
