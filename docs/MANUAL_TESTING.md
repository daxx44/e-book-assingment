# Manual Testing Checklist

Use before sharing the repo or submitting the assignment. Run the **Rails API** and **Flutter app** together.

**Status:** All items below verified manually (Jul 2026).

**Setup reminder:** Configure `mobile/lib/core/config/api_config.dart` for your device (emulator / LAN IP / USB). See root [README.md](../README.md#3-configure-flutter-api-url).

---

## Environment

- [x] PostgreSQL running
- [x] `DATABASE_PASSWORD` set when starting Rails
- [x] API health: `GET http://localhost:3000/api/v1/health` → 200
- [x] `api_config.dart` matches your device mode
- [x] Physical device: health URL works in phone browser (if using Wi-Fi mode)

---



## Upload

- [x] Open Upload from library FAB
- [x] Validation: title required without file → error shown
- [x] Validation: file required without title → error shown
- [x] Upload valid PDF → success → appears in library
- [x] Upload valid EPUB → success → appears in library
- [x] Optional cover image → shows on book card
- [x] Upload non-PDF/EPUB → server validation error
- [x] Upload > 100 MB → rejected with clear message

---



## Library

- [x] Empty state when no books
- [x] Bookshelf layout after upload
- [x] Continue Reading strip (after reading a book)
- [x] Pull-to-refresh reloads list
- [x] Sort by Recent / Title / Author
- [x] Loading shimmer while fetching
- [x] Server stopped → themed “server unavailable” + Try again
- [x] Generic error + Retry for other failures

---



## Search

- [x] Idle state before typing
- [x] Debounced search (not every keystroke)
- [x] Search by title, author, filename
- [x] No results → empty state
- [x] Match highlighting on cards
- [x] Sort on search results
- [x] File-type quick filters (PDF / EPUB)

---



## Read

- [x] PDF opens in reader
- [x] EPUB opens in reader
- [x] Page / chapter navigation
- [x] PDF zoom (double-tap)
- [x] Reading settings (font size for EPUB)
- [x] Re-open book → last position remembered
- [x] Progress footer shows page / percent

---



## Download

- [x] Download from library → progress sheet
- [x] Book appears in **Downloads** tab
- [x] Read downloaded book offline (local file)
- [x] Remove download from Downloads tab

---



## Delete

- [x] Delete shows confirmation dialog
- [x] Cancel keeps book
- [x] Confirm removes from library and server
- [x] Failure snackbar when server offline

---



## Dashboard & About

- [x] Bottom nav: Library, Downloads, About
- [x] About shows app name and developer info

---



## Automated tests

```powershell
# Backend
cd backend
$env:DATABASE_PASSWORD = "postgres"
bundle exec rspec
bundle exec rubocop

# Flutter
cd mobile
flutter analyze
flutter test
```

- [x] RSpec: 42 examples, 0 failures
- [x] Flutter: all tests pass
- [x] `flutter analyze`: no issues

See [test-results/README.md](test-results/README.md) for pasted terminal logs (`backend-test`, `flutter-test`, etc.).

---



## Demo capture (submission)

Record or screenshot:

1. Empty library
2. Upload flow (PDF or EPUB)
3. Bookshelf with books + Continue Reading
4. Search with highlights
5. Reader (PDF or EPUB)
6. Downloads tab with offline book
7. Delete confirmation
8. Terminal: `rspec` + `flutter test` passing

Save to `docs/screenshots/` — see [screenshots/README.md](screenshots/README.md).