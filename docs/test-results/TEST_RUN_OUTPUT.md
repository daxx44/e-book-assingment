# Automated Test Run Output

Captured on **4 July 2026** on the developer machine. Reviewers can reproduce with the commands below.

> **Tip:** Terminal output can be saved as text files in `docs/test-results/` (see [README.md](README.md)) or as a screenshot `docs/screenshots/07-tests.png`.

---

## Backend — RSpec

```powershell
cd backend
$env:DATABASE_PASSWORD = "postgres"
bundle exec rspec
```

**Result:** `42 examples, 0 failures`

```
Finished in 14.35 seconds (files took 51.05 seconds to load)
42 examples, 0 failures

Randomized with seed 27375
```

**Suites covered:**

- `spec/models/ebook_spec.rb` — validations, scopes, search
- `spec/requests/api/v1/health_spec.rb` — health check
- `spec/requests/api/v1/ebooks_spec.rb` — upload, list, show, search, download, delete, sort

---

## Backend — RuboCop

```powershell
cd backend
bundle exec rubocop
```

**Result:** 41 files inspected, 2 minor style offenses (array bracket spacing in one spec). No functional impact.

---

## Flutter — analyze

```powershell
cd mobile
flutter analyze
```

**Result:** `No issues found!`

---

## Flutter — widget & screen tests

```powershell
cd mobile
flutter test
```

**Result:** `All tests passed!` (15 tests)

| Test file | What it covers |
|-----------|----------------|
| `test/screens/about_screen_test.dart` | About tab content |
| `test/screens/library_screen_test.dart` | Server-unavailable state |
| `test/screens/search_screen_test.dart` | Search idle state |
| `test/screens/upload_screen_test.dart` | Upload form fields |
| `test/services/recently_read_service_test.dart` | Continue reading persistence |
| `test/widgets/book_card_test.dart` | Card render + search highlight |
| `test/widgets/cover_preview_test.dart` | Cover initials |
| `test/widgets/delete_confirmation_dialog_test.dart` | Delete confirm flow |
| `test/widgets/empty_state_widget_test.dart` | Empty state |
| `test/widgets/highlighted_text_test.dart` | Search highlighting |
| `test/widgets/loading_widget_test.dart` | Library shimmer |

**Sample output:**

```
00:50 +15: All tests passed!
```

---

## CI

GitHub Actions workflow: [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) — runs `rspec`, `rubocop`, `flutter analyze`, and `flutter test` on push/PR.
