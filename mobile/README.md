# Ebook Library — Flutter App

Mobile client for the Digital Ebook Library (Rails API backend).

## Stack

- Flutter 3 / Dart 3
- **GetX** — state, DI, navigation
- **Dio** — REST client
- Material 3
- `syncfusion_flutter_pdfviewer` (PDF), `epub_view` (EPUB)
- `file_picker`, `image_picker`, `path_provider`, `shared_preferences`

## Prerequisites

- Flutter SDK installed (`flutter doctor`)
- Rails backend running on port 3000 (see [../README.md](../README.md))

## API base URL

Edit **`lib/core/config/api_config.dart`** before `flutter run`:

| Mode | `androidMode` | Host used |
|------|---------------|-----------|
| Android emulator | `AndroidConnectionMode.emulator` | `10.0.2.2` |
| Phone on same Wi-Fi | `AndroidConnectionMode.physicalDevice` | `pcLanIp` (your PC IPv4 from `ipconfig`) |
| Phone over USB | `AndroidConnectionMode.usbAdbReverse` | `127.0.0.1` after `adb reverse tcp:3000 tcp:3000` |

Example:

```dart
static const AndroidConnectionMode androidMode = AndroidConnectionMode.emulator;
static const String pcLanIp = '192.168.1.42'; // replace with YOUR ipconfig IPv4
```

**Do not** copy a developer-specific IP from documentation — each machine differs.

## Run

```bash
cd mobile          # from repo root
flutter pub get
flutter run
```

Use a **full restart** after changing `api_config.dart` or `pubspec.yaml` assets.

## Test

```bash
flutter analyze
flutter test
```

Last verified: **15 tests passed**, analyze clean (see [../docs/test-results/TEST_RUN_OUTPUT.md](../docs/test-results/TEST_RUN_OUTPUT.md)).

## Architecture

```
Screen → GetX Controller → Repository → ApiClient (Dio) → Rails API
```

Main tabs: **Library**, **Downloads**, **About** (`DashboardScreen`).

See [../docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md) and [../docs/IMPLEMENTATION_STATUS.md](../docs/IMPLEMENTATION_STATUS.md).
