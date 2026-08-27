# Testing Guide

How to run automated tests and what they cover.

**Submission evidence:** Full terminal output is saved as plain-text logs in [test-results/](test-results/README.md) (`backend-test`, `backend-robocop`, `flutter-analyze`, `flutter-test`). A short summary is in [test-results/TEST_RUN_OUTPUT.md](test-results/TEST_RUN_OUTPUT.md).

---

## Backend (RSpec)

From the repo root:

```powershell
cd backend
$env:DATABASE_PASSWORD = "postgres"    # Windows
# export DATABASE_PASSWORD=postgres   # macOS/Linux
bundle exec rspec
bundle exec rubocop
```

### Last verified run

| Command | Result | Date |
|---------|--------|------|
| `bundle exec rspec` | **42 examples, 0 failures** | 4 Jul 2026 |
| `bundle exec rubocop` | 41 files, 2 minor style offenses | 4 Jul 2026 |
| `flutter analyze` | No issues | 4 Jul 2026 |
| `flutter test` | **15 tests passed** | 4 Jul 2026 |

### Covered (backend)

| Area | Spec file |
|------|-----------|
| Model validations, scopes, search | `spec/models/ebook_spec.rb` |
| Health endpoint | `spec/requests/api/v1/health_spec.rb` |
| Upload, list, show, search, download, delete | `spec/requests/api/v1/ebooks_spec.rb` |
| Sort parameter | `spec/requests/api/v1/ebooks_spec.rb` |
| Validation errors (missing title/file, non-PDF) | `spec/requests/api/v1/ebooks_spec.rb` |
| Soft delete excluded from list/search | `spec/requests/api/v1/ebooks_spec.rb` |

### Not covered (acceptable for scope)

- EPUB-specific upload specs (same pipeline as PDF; validated in model)
- Cover image upload in isolation (covered via manual testing)
- Load / concurrent upload testing
- Service object unit tests in isolation (covered via request specs)

---

## Flutter

```powershell
cd mobile
flutter analyze
flutter test
```

### Widget / screen tests

| Test | File |
|------|------|
| About screen | `test/screens/about_screen_test.dart` |
| Library server-down state | `test/screens/library_screen_test.dart` |
| Search idle state | `test/screens/search_screen_test.dart` |
| Upload form | `test/screens/upload_screen_test.dart` |
| Recently read service | `test/services/recently_read_service_test.dart` |
| Empty state | `test/widgets/empty_state_widget_test.dart` |
| Delete dialog | `test/widgets/delete_confirmation_dialog_test.dart` |
| Book card + highlight | `test/widgets/book_card_test.dart` |
| Cover preview | `test/widgets/cover_preview_test.dart` |
| Highlighted text | `test/widgets/highlighted_text_test.dart` |
| Loading shimmer | `test/widgets/loading_widget_test.dart` |

### Not covered

- Full integration tests against live API (see [MANUAL_TESTING.md](MANUAL_TESTING.md))
- PDF/EPUB viewer rendering (Syncfusion / epub_view — manual)
- Downloads tab end-to-end (manual)

---

## Manual testing

See [MANUAL_TESTING.md](MANUAL_TESTING.md) for the full pre-submission checklist.

---

## CI

GitHub Actions (`.github/workflows/ci.yml`):

- Backend: `rspec` + `rubocop` with PostgreSQL service
- Flutter: `flutter analyze` + `flutter test`

---

## Screenshots for reviewers

Optional: save a terminal screenshot showing:

1. `bundle exec rspec` → `0 failures`
2. `flutter test` → `All tests passed!`

**Already submitted:** copy-pasted logs in `docs/test-results/` (see [test-results/README.md](test-results/README.md)). A combined PNG such as `docs/screenshots/07-tests.png` is optional.
