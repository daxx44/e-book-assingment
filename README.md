# Digital Ebook Library

Full-stack ebook library for uploading, browsing, searching, reading, downloading, and deleting **PDF and EPUB** ebooks.

| Layer | Stack |
|-------|--------|
| Backend | Ruby 3.3+, Rails 8 API, PostgreSQL, Active Storage |
| Mobile | Flutter 3, GetX, Dio, Syncfusion PDF viewer, epub_view |

**Assignment:** Sagar Fab International Company — Full Stack Developer (Rails + Flutter)

**What is covered:** See [docs/IMPLEMENTATION_STATUS.md](docs/IMPLEMENTATION_STATUS.md) for assignment checklist vs implementation.

**Demo included:** UI screenshots + screen recording in [`docs/screenshots/`](docs/screenshots/README.md); test logs in [`docs/test-results/`](docs/test-results/README.md).

---

## Project structure

Clone the repo anywhere on your machine. Example layout:

```
ebook-library/          ← your clone folder (name is up to you)
├── backend/            # Rails 8 API-only app
├── mobile/             # Flutter client (package name: frontend)
├── docs/               # Spec, API, testing, screenshots
├── scripts/            # Helper scripts (e.g. Windows firewall)
└── docker-compose.yml  # Optional PostgreSQL in Docker
```

---

## Prerequisites

### Backend

- [Ruby 3.3+](https://rubyinstaller.org/) — check **Add Ruby to PATH** during install
- [PostgreSQL 17+](https://www.postgresql.org/download/)
- Bundler: `gem install bundler`

### Mobile

- [Flutter 3](https://docs.flutter.dev/get-started/install) (Dart 3.9+)
- Android Studio (emulator) **or** a physical Android device with USB debugging

---

## Quick start

You need **two terminals**: Rails API first, then Flutter.

Replace `path/to/ebook-library` with wherever you cloned this repo.

### 1. Backend setup (first time)

**PowerShell (Windows):**

```powershell
cd path/to/ebook-library/backend
bundle install
$env:DATABASE_PASSWORD = "postgres"   # use your PostgreSQL password
bundle exec rails db:create db:migrate
bundle exec rails db:seed             # optional: 3 sample PDFs
```

**macOS / Linux:**

```bash
cd path/to/ebook-library/backend
bundle install
export DATABASE_PASSWORD=postgres
bundle exec rails db:create db:migrate
bundle exec rails db:seed
```

> **Windows:** If `bundle` is not found, add Ruby to PATH, e.g. `C:\Ruby33-x64\bin`, or run:
> ```powershell
> $env:Path = "C:\Ruby33-x64\bin;" + $env:Path
> ```

### 2. Start the API server

```powershell
cd path/to/ebook-library/backend
$env:DATABASE_PASSWORD = "postgres"
bundle exec rails server
```

Wait until you see:

```
* Listening on http://0.0.0.0:3000
```

Puma is configured to bind `0.0.0.0` so phones on the same Wi-Fi can reach the API.

**Verify** (second terminal):

```powershell
Invoke-WebRequest http://localhost:3000/api/v1/health
```

Expected: HTTP `200` with `"status":"ok"`.

### 3. Configure Flutter API URL

Edit **`mobile/lib/core/config/api_config.dart`** before running the app:

| How you run the app | Set in `api_config.dart` |
|---------------------|----------------------------|
| **Android emulator** | `androidMode = AndroidConnectionMode.emulator` → host `10.0.2.2` |
| **Physical phone (Wi-Fi)** | `androidMode = AndroidConnectionMode.physicalDevice` and `pcLanIp = '<YOUR_PC_IP>'` |
| **Physical phone (USB)** | `androidMode = AndroidConnectionMode.usbAdbReverse`, then run `adb reverse tcp:3000 tcp:3000` |

**Find your PC IP (Windows):**

```powershell
ipconfig
```

Use the **IPv4 Address** of your active adapter (Wi-Fi or Ethernet), e.g. `192.168.1.42`.  
Do **not** use a developer-specific path or IP from this README — each machine is different.

Example `api_config.dart`:

```dart
static const AndroidConnectionMode androidMode = AndroidConnectionMode.emulator;
static const String pcLanIp = '192.168.1.42'; // only used for physicalDevice mode
```

### 4. Run the Flutter app

```powershell
cd path/to/ebook-library/mobile
flutter pub get
flutter run
```

> Android Studio only launches the Flutter app. **Rails must already be running** in another terminal.

After changing `api_config.dart` or adding assets, do a **full restart** (`flutter run`), not hot reload.

---

## API URLs summary

| Client | Base URL |
|--------|----------|
| Rails on same PC | `http://localhost:3000/api/v1` |
| Android emulator | `http://10.0.2.2:3000/api/v1` |
| Physical Android device | `http://<YOUR_PC_IP>:3000/api/v1` |
| USB + adb reverse | `http://127.0.0.1:3000/api/v1` |

---

## Physical device networking (Windows)

If the phone cannot reach the API:

1. Confirm Rails shows `Listening on http://0.0.0.0:3000`
2. Set `pcLanIp` to your current `ipconfig` IPv4
3. Phone and PC on the **same Wi-Fi**
4. Allow inbound port 3000 — PowerShell **as Administrator**:
   ```powershell
   cd path/to/ebook-library/scripts
   .\allow-rails-port-3000.ps1
   ```
5. Test in phone browser: `http://<YOUR_PC_IP>:3000/api/v1/health`
6. Full restart the Flutter app

**USB alternative (no firewall change):**

```powershell
adb reverse tcp:3000 tcp:3000
```

Set `androidMode = AndroidConnectionMode.usbAdbReverse` in `api_config.dart`.

---

## Demo walkthrough

With backend running and the app open:

1. **Library** — Bookshelf home; empty state if no books; **Continue Reading** when you have history
2. **Upload** — FAB → title (required), author, description → PDF or EPUB → optional cover → Upload
3. **Browse** — Wooden shelf layout; pull to refresh; sort from header
4. **Search** — Search icon → debounced search, filters, highlighted results
5. **Read** — Open book → in-app PDF or EPUB reader; progress saved
6. **Download** — Download with progress → **Downloads** tab for offline read
7. **Delete** — Delete on card → confirm dialog
8. **About** — App info (bottom nav)

**Recorded demo:** A screen capture and UI screenshots are included in the repository — see [Screenshots & demo](#screenshots--demo) below.

---

## Testing

### Backend

```powershell
cd backend
$env:DATABASE_PASSWORD = "postgres"
bundle exec rspec
bundle exec rubocop
```

**Last run (4 Jul 2026):** `42 examples, 0 failures`

### Mobile

```powershell
cd mobile
flutter analyze
flutter test
```

**Last run (4 Jul 2026):** analyze clean, **15 tests passed**

Full output and file list: [docs/test-results/TEST_RUN_OUTPUT.md](docs/test-results/TEST_RUN_OUTPUT.md)  
Strategy: [docs/TESTING.md](docs/TESTING.md)  
Manual checklist: [docs/MANUAL_TESTING.md](docs/MANUAL_TESTING.md)

---

## Documentation

| Document | Description |
|----------|-------------|
| [docs/README.md](docs/README.md) | Documentation index |
| [docs/IMPLEMENTATION_STATUS.md](docs/IMPLEMENTATION_STATUS.md) | Assignment coverage vs built features |
| [docs/API.md](docs/API.md) | REST API reference |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | System architecture |
| [docs/DATABASE.md](docs/DATABASE.md) | Database schema |
| [docs/TESTING.md](docs/TESTING.md) | Automated testing guide |
| [docs/MANUAL_TESTING.md](docs/MANUAL_TESTING.md) | Pre-submission manual checklist |
| [docs/AI_USAGE.md](docs/AI_USAGE.md) | AI tools usage report |
| [backend/README.md](backend/README.md) | Backend-only setup |
| [mobile/README.md](mobile/README.md) | Flutter-only setup |

---

## Troubleshooting

### `bundle` or `ruby` not recognized

Add Ruby `bin` folder to PATH (see Quick start).

### App cannot connect (emulator)

- Rails must be running
- Use `AndroidConnectionMode.emulator` (`10.0.2.2`, not `localhost` on the device)

### App cannot connect (physical phone)

See [Physical device networking](#physical-device-networking-windows) above.

### Asset not found (`app_icon.png`)

Run from `mobile/` folder, then:

```powershell
flutter pub get
flutter run
```

If needed: `flutter clean` → `flutter pub get` → `flutter run`.

### “A server is already running”

`Ctrl+C` in the Rails terminal, or delete `backend/tmp/pids/server.pid`.

### VIPS warnings on Rails boot

Harmless on Windows when optional image modules are missing.

### Database connection errors

- PostgreSQL service running
- `DATABASE_PASSWORD` matches your `postgres` user
- Run `bundle exec rails db:create db:migrate`

---

## Docker (PostgreSQL only)

```powershell
cd path/to/ebook-library
docker compose up -d
cd backend
$env:DATABASE_PASSWORD = "postgres"
bundle exec rails db:create db:migrate db:seed
bundle exec rails server
```

---

## API overview

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/health` | Health check |
| GET | `/api/v1/ebooks?sort=recent\|title\|author` | List ebooks |
| POST | `/api/v1/ebooks` | Upload PDF/EPUB (+ optional cover) |
| GET | `/api/v1/ebooks/:id` | Ebook details |
| GET | `/api/v1/ebooks/search?q=&sort=` | Search |
| GET | `/api/v1/ebooks/:id/download` | Download file |
| DELETE | `/api/v1/ebooks/:id` | Soft delete |

Full reference: [docs/API.md](docs/API.md)

---

## Screenshots & demo

Demo media is **included in this repo** under `docs/screenshots/` (no external links required).

### Demo video

[docs/screenshots/screen-20260704-165340~2-compressed.mp4](docs/screenshots/screen-20260704-165340~2-compressed.mp4) — full walkthrough: upload, library, search, read, download, delete.

> On GitHub: open the file above and use **Download** or **View raw** to play.

### App screenshots

| Flow | File |
|------|------|
| Library / home | [Screenshot_20260704-162616.png](docs/screenshots/Screenshot_20260704-162616.png) |
| Upload | [Screenshot_20260704-162757.png](docs/screenshots/Screenshot_20260704-162757.png) |
| Bookshelf | [Screenshot_20260704-162832.png](docs/screenshots/Screenshot_20260704-162832.png) |
| Search | [Screenshot_20260704-162900.png](docs/screenshots/Screenshot_20260704-162900.png) |
| Reader | [Screenshot_20260704-163531.png](docs/screenshots/Screenshot_20260704-163531.png) |
| Download / details | [Screenshot_20260704-163544.png](docs/screenshots/Screenshot_20260704-163544.png) |
| Delete confirmation | [Screenshot_20260704-163552.png](docs/screenshots/Screenshot_20260704-163552.png) |
| Downloads / About | [Screenshot_20260704-165410.png](docs/screenshots/Screenshot_20260704-165410.png) |

Preview (bookshelf):-

![Bookshelf library](docs/screenshots/Screenshot_20260704-165410.png)

Full index: [docs/screenshots/README.md](docs/screenshots/README.md)

### Automated test evidence

Terminal output was copy-pasted into plain-text files (not screenshots):

| Log file | Command |
|----------|---------|
| [docs/test-results/backend-test](docs/test-results/backend-test) | `bundle exec rspec` → 42 examples, 0 failures |
| [docs/test-results/backend-robocop](docs/test-results/backend-robocop) | `bundle exec rubocop` |
| [docs/test-results/flutter-analyze](docs/test-results/flutter-analyze) | `flutter analyze` → no issues |
| [docs/test-results/flutter-test](docs/test-results/flutter-test) | `flutter test` → 15 passed |

Index: [docs/test-results/README.md](docs/test-results/README.md)

---

## AI tools used

See [docs/AI_USAGE.md](docs/AI_USAGE.md).

---

## Known limitations

- No user authentication (single-user local library)
- Active Storage on local disk (no S3)
- No API pagination
- Tested primarily on Android
- RuboCop: 2 minor style offenses in one spec file

---

## Submission checklist

| Deliverable | Location |
|-------------|----------|
| GitHub repository | Backend + mobile monorepo |
| README | This file |
| Implementation status | [docs/IMPLEMENTATION_STATUS.md](docs/IMPLEMENTATION_STATUS.md) |
| API docs | [docs/API.md](docs/API.md) |
| Manual testing | [docs/MANUAL_TESTING.md](docs/MANUAL_TESTING.md) |
| Test results (terminal logs) | [docs/test-results/README.md](docs/test-results/README.md) |
| Demo screenshots & video | [docs/screenshots/](docs/screenshots/) |
| AI usage report | [docs/AI_USAGE.md](docs/AI_USAGE.md) |
| CI | [.github/workflows/ci.yml](.github/workflows/ci.yml) |

---

## License

Educational / assignment project — Sagar Fab International Company.
