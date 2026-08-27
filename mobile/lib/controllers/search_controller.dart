import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/utils/app_feedback.dart';
import 'package:frontend/core/utils/app_haptics.dart';
import 'package:frontend/core/utils/download_flow.dart';
import 'package:frontend/models/ebook.dart';
import 'package:frontend/repositories/ebook_repository.dart';
import 'package:frontend/routes/app_pages.dart';
import 'package:get/get.dart';

enum SearchStatus { idle, loading, success, empty, error }

class EbookSearchController extends GetxController {
  EbookSearchController({EbookRepository? repository})
      : _repository = repository ?? EbookRepository();

  final EbookRepository _repository;
  final searchController = TextEditingController();
  Timer? _debounce;

  final Rx<SearchStatus> status = SearchStatus.idle.obs;
  final RxList<Ebook> results = <Ebook>[].obs;
  final RxString errorMessage = ''.obs;
  final RxString sortBy = 'recent'.obs;

  bool _hasSearchedOnce = false;

  void onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDebounce, () => search(value));
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      results.clear();
      status.value = SearchStatus.idle;
      return;
    }

    final background = _hasSearchedOnce && results.isNotEmpty;
    if (!background) {
      status.value = SearchStatus.loading;
    }
    errorMessage.value = '';

    try {
      final ebooks = await _repository.searchEbooks(trimmed, sort: sortBy.value);
      results.assignAll(ebooks);
      _hasSearchedOnce = true;
      status.value = ebooks.isEmpty ? SearchStatus.empty : SearchStatus.success;
    } on ApiException catch (error) {
      if (background) return;
      errorMessage.value = error.message;
      status.value = SearchStatus.error;
      _hasSearchedOnce = true;
    } catch (_) {
      if (background) return;
      errorMessage.value = 'Search failed. Please try again.';
      status.value = SearchStatus.error;
      _hasSearchedOnce = true;
    }
  }

  void changeSort(String value) {
    sortBy.value = value;
    AppHaptics.selection();
    if (searchController.text.trim().isNotEmpty) {
      search(searchController.text);
    }
  }

  void openReader(Ebook ebook) {
    AppHaptics.medium();
    Get.toNamed(AppRoutes.reader, arguments: ebook);
  }

  Future<void> downloadEbook(Ebook ebook) => downloadEbookWithProgress(ebook);

  Future<void> deleteEbook(Ebook ebook) async {
    try {
      await _repository.deleteEbook(ebook.id);
      results.removeWhere((item) => item.id == ebook.id);
      if (results.isEmpty && searchController.text.trim().isNotEmpty) {
        status.value = SearchStatus.empty;
      }
      AppFeedback.success('Removed', message: '${ebook.title} was deleted.');
    } on ApiException catch (error) {
      AppFeedback.error('Delete failed', message: error.message);
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
