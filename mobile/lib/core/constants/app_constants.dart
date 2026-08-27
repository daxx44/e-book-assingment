class AppConstants {
  AppConstants._();

  static const String appName = 'Ebook Library';
  static const int maxUploadBytes = 100 * 1024 * 1024;
  static const Duration searchDebounce = Duration(milliseconds: 400);
}
