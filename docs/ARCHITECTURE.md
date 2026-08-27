# Architecture

## Overview

The Digital Ebook Library is a client-server application:

```
Flutter App (Android)
      │
      │ REST JSON (Dio)
      ▼
Ruby on Rails 8 API
      │
      ├── PostgreSQL (metadata)
      └── Active Storage (PDF/EPUB files + cover images)
```

---

## Backend responsibilities

- Ebook CRUD APIs under `/api/v1`
- Multipart upload (PDF, EPUB, optional cover)
- Search (title, author, Active Storage filename)
- Download streaming
- Soft delete (`status: deleted`)
- Validation and structured error responses

**Key paths:**

```
backend/app/
  controllers/api/v1/
  models/ebook.rb
  services/ebooks/          # upload, list, search, delete
  serializers/api/v1/
```

Puma binds `0.0.0.0:3000` in development so physical devices on the LAN can connect.

---

## Frontend responsibilities

- Bookshelf library UI with Continue Reading
- Upload, search, read, download, delete
- Offline downloads tab (local files via `path_provider`)
- Loading, empty, error, and server-down states

**Key paths:**

```
mobile/lib/
  core/config/api_config.dart    # API host per device mode
  core/network/api_client.dart
  controllers/                   # GetX
  repositories/
  screens/
  widgets/
```

**Navigation:** `DashboardScreen` → Library | Downloads | About (bottom nav). Search and Upload are pushed routes.

---

## Data flow

```
Screen → GetX Controller → Repository → ApiClient (Dio) → Rails API
```

Downloads also use `DownloadService` (SharedPreferences + app documents directory) for offline copies.

---

## Design principles

- REST API with consistent JSON envelope
- Repository pattern on Flutter
- Service objects for non-trivial Rails actions
- Separation of UI and business logic (GetX controllers)
- Reusable widgets (book cards, shelf rows, reader chrome)

---

## Error handling

API errors use a single envelope — see [API.md](API.md).  
Flutter maps these to snackbars, form field errors, and dedicated error/server-down screens.

---

## What is documented elsewhere

| Topic | Document |
|-------|----------|
| Assignment coverage | [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md) |
| API endpoints | [API.md](API.md) |
| Database schema | [DATABASE.md](DATABASE.md) |
| Setup & IP config | [../README.md](../README.md) |
