# AI Usage Report

**Project:** Digital Ebook Library  
**Company:** Sagar Fab International Company  
**Developer:** Darshan  

## Tools used

| Tool | Purpose |
|------|---------|
| **Cursor** (AI-assisted IDE) | Primary development environment — architecture, implementation, debugging |
| **Claude / GPT** (via Cursor) | Code generation, spec review, troubleshooting |

## How AI was used

### Planning and architecture

- Summarized assignment requirements and designed API envelope, folder structure, and phased delivery.
- Chose **GetX** for Flutter state management and navigation.

### Backend (Rails)

- AI-assisted scaffolding of Rails 8 API-only app, models, migrations, services, serializers, and RSpec request specs.
- **Manually reviewed:** soft-delete semantics, search scope (JOIN on Active Storage blobs), error JSON format, upload validations, CORS.

### Frontend (Flutter)

- AI-assisted GetX controllers, Dio client, bookshelf UI, EPUB reader, downloads tab, and widget tests.
- **Manually reviewed and fixed:** `File.writeAsBytes` in download, `api_config.dart` connection modes, Windows firewall, reader UX, server-down state.

### Documentation

- AI drafted README, API docs, testing guide, and this report.
- **Manually reviewed** for accuracy against actual setup on Windows (Ruby PATH, PostgreSQL password, LAN IP).

### Debugging

- AI helped diagnose `bundle` not on PATH, PowerShell paste errors, `10.0.2.2` vs real-device IP, and Windows Firewall blocking port 3000.

## AI-generated code that was rejected or corrected

| Issue | Resolution |
|-------|------------|
| `snackBarBehavior` on `ThemeData` | Replaced with `snackBarTheme` |
| `androidLanHost` hardcoded to old Wi-Fi IP | Replaced with `AndroidConnectionMode` + `pcLanIp`; documented for reviewers |
| Default counter `widget_test.dart` | Removed; replaced with focused widget tests |
| `directory.writeAsBytes` in download | Fixed to `File(path).writeAsBytes` |

## Ownership and review

All AI output was:

- Run through `bundle exec rspec`, `rubocop`, `flutter analyze`, and `flutter test` (42 + 15 tests — see [test-results/TEST_RUN_OUTPUT.md](test-results/TEST_RUN_OUTPUT.md))
- Tested manually on physical Android device against local Rails API
- Adjusted to match assignment deliverables and product UX (loading, empty, error states)

The final codebase reflects deliberate technical choices, not unchecked copy-paste.

## What AI helped most with

- Faster boilerplate (Rails API structure, Flutter screen wiring)
- Consistent error envelope across backend and Dio client
- Documentation and troubleshooting checklists
- Identifying network vs database issues during device testing

## What was done manually

- Environment setup (Ruby, PostgreSQL, Flutter on Windows)
- Physical device networking (IP, firewall, `adb reverse` option)
- Product decisions (bookshelf layout, cover color generation, sort options)
- Final verification of upload → read → search → download → delete flow
