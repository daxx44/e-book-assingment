# API Documentation

## Base URL

| Environment | Base URL |
|-------------|----------|
| Rails on developer PC | `http://localhost:3000/api/v1` |
| Android emulator | `http://10.0.2.2:3000/api/v1` |
| Physical Android device | `http://<YOUR_PC_IP>:3000/api/v1` |

Configure the Flutter client in `mobile/lib/core/config/api_config.dart`.  
All endpoints below are relative to the base URL (e.g. `GET /ebooks` → `GET /api/v1/ebooks`).

---

## Upload Ebook

POST /ebooks

Request

multipart/form-data

Fields

- title (required)
- author (optional)
- description (optional)
- file (required) — PDF (`application/pdf`) or EPUB (`application/epub+zip`)
- cover (optional) — JPEG, PNG, or WebP image

Response

201 Created

```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "Clean Architecture",
    "author": "Robert Martin",
    "description": null,
    "status": "active",
    "file_type": "application/pdf",
    "file_size": 328,
    "filename": "sample.pdf",
    "cover_url": "http://localhost:3000/rails/active_storage/blobs/.../cover.jpg",
    "created_at": "2026-07-02T17:00:00Z",
    "updated_at": "2026-07-02T17:00:00Z"
  },
  "meta": null
}
```

---

## List Ebooks

GET /ebooks

Query parameters

- `sort` (optional): `recent` (default), `title`, or `author`

Response

200 OK

Returns all **active** ebooks (excludes soft-deleted).

```json
{
  "success": true,
  "data": [ { "id": 1, "title": "..." } ],
  "meta": { "total": 1 }
}
```

---

## Get Ebook

GET /ebooks/:id

Returns ebook details.

---

## Search

GET /ebooks/search?q=flutter

Query parameters

- `q` — search term
- `sort` (optional): `recent`, `title`, or `author`

Search by

- Title
- Author
- Filename

---

## Download

GET /ebooks/:id/download

Downloads the ebook file (PDF or EPUB).

---

## Delete

DELETE /ebooks/:id

Soft deletes ebook (`status` → `deleted`). Hidden from list/search.

Response

200 OK

```json
{
  "success": true,
  "data": { "message": "Ebook deleted successfully." },
  "meta": null
}
```

---

## Response Envelope

All JSON responses use a consistent envelope.

### Success

```json
{
  "success": true,
  "data": {},
  "meta": null
}
```

- `data` — payload (object, array, or `null`)
- `meta` — optional pagination or extra info (e.g. `{ "total": 42 }`)

### Error

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "Please correct the errors below.",
    "details": [
      {
        "field": "title",
        "code": "blank",
        "message": "Title can't be blank"
      },
      {
        "field": "file",
        "code": "invalid_type",
        "message": "File must be a PDF"
      }
    ]
  }
}
```

| Field | Type | Description |
|-------|------|-------------|
| `success` | boolean | Always `false` for errors |
| `error.code` | string | Machine-readable error identifier (stable, for client logic) |
| `error.message` | string | Human-readable summary safe to show in the UI |
| `error.details` | array | Optional. Field-level errors for forms and validation |
| `error.details[].field` | string | Request field name (`title`, `file`, `author`). Use `"base"` for non-field errors |
| `error.details[].code` | string | Machine-readable reason (`blank`, `too_large`, `invalid_type`) |
| `error.details[].message` | string | Human-readable message for that field |

### Why this format

The previous flat shape mixed summary and field errors at the top level:

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": { "title": ["can't be blank"] }
}
```

Problems with that approach:

- `message` and `errors` overlap — clients must guess what to display
- Rails-style `{ "field": ["msg1", "msg2"] }` is awkward to map in Flutter/Freezed
- No stable `code` for programmatic handling, logging, or localization
- Non-validation errors (404, 500) would need a different shape

The improved format keeps one structure for every error type. Clients always read `error.code` and `error.message`; forms additionally read `error.details`.

---

## Error Codes

| HTTP Status | `error.code` | When |
|-------------|--------------|------|
| 400 | `BAD_REQUEST` | Malformed request |
| 404 | `NOT_FOUND` | Ebook not found |
| 422 | `VALIDATION_FAILED` | Model or upload validation failed |
| 500 | `INTERNAL_SERVER_ERROR` | Unexpected server failure |

### Field error codes (`details[].code`)

| Code | Meaning |
|------|---------|
| `blank` | Required field missing |
| `too_large` | File exceeds 100 MB |
| `invalid_type` | File is not PDF/EPUB, or cover is not a supported image |
| `invalid` | Generic field validation failure |

---

## Error Examples

### Validation failed (422)

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "Please correct the errors below.",
    "details": [
      {
        "field": "title",
        "code": "blank",
        "message": "Title can't be blank"
      },
      {
        "field": "file",
        "code": "blank",
        "message": "File can't be blank"
      }
    ]
  }
}
```

### Single field error (422)

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "File must be a PDF.",
    "details": [
      {
        "field": "file",
        "code": "invalid_type",
        "message": "File must be a PDF"
      }
    ]
  }
}
```

### Ebook not found (404)

```json
{
  "success": false,
  "error": {
    "code": "NOT_FOUND",
    "message": "Ebook not found."
  }
}
```

No `details` array when the error is not field-specific.

### Server error (500)

```json
{
  "success": false,
  "error": {
    "code": "INTERNAL_SERVER_ERROR",
    "message": "Something went wrong. Please try again later."
  }
}
```

Never expose stack traces or internal details in production responses.

---

## Flutter parsing notes

Map the envelope to a single `ApiError` model:

```dart
// Conceptual — not application code
class ApiError {
  final String code;
  final String message;
  final List<FieldError> details;
}

class FieldError {
  final String field;
  final String code;
  final String message;
}
```

Display rules:

1. Show `error.message` as the primary snackbar/dialog text
2. For forms, highlight fields listed in `error.details`
3. Match `details[].field` to form field names
4. Use `error.code` for branching (e.g. retry on `INTERNAL_SERVER_ERROR`, not on `VALIDATION_FAILED`)

---

## Rails implementation notes

- `Api::V1::BaseController` rescues `ActiveRecord::RecordInvalid` and `ActiveRecord::RecordNotFound`
- Convert `model.errors` to `details` array (not a nested hash)
- Example mapping: `errors.add(:title, :blank)` → `{ field: "title", code: "blank", message: "..." }`
- Always set the matching HTTP status header; the body `error.code` must agree