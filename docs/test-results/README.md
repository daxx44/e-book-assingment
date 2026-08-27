# Test results (submission evidence)

Automated test output for reviewers. This folder includes **copy-pasted terminal logs** from the developer machine (4 Jul 2026).

Screenshots or a combined image are optional; the text files below are the primary evidence that tests were run successfully.

---

## Terminal log files

| File | Command run | Key result |
|------|-------------|------------|
| [backend-test](backend-test) | `bundle exec rspec` | **42 examples, 0 failures** |
| [backend-robocop](backend-robocop) | `bundle exec rubocop` | 41 files inspected, 2 minor style offenses |
| [flutter-analyze](flutter-analyze) | `flutter analyze` | **No issues found!** |
| [flutter-test](flutter-test) | `flutter test` | **All tests passed!** (15 tests) |

Each file contains the full command and terminal output as copied from PowerShell.

---

## Summary (markdown)

[TEST_RUN_OUTPUT.md](TEST_RUN_OUTPUT.md) — short summary and how to reproduce the same commands.

---

## Reproduce locally

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

---

## App demo media

UI screenshots and demo video are in [../screenshots/](../screenshots/README.md).
