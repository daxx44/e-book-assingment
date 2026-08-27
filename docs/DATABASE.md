# Database Design

## Database

PostgreSQL

## Main Table

### ebooks

| Column | Type | Required | Default | Description |
|---------|------|----------|---------|-------------|
| id | bigint | Yes | — | Primary key |
| title | string | Yes | — | Ebook title |
| author | string | No | `NULL` | Author name |
| description | text | No | `NULL` | Short description |
| status | integer | Yes | `0` (active) | Lifecycle: `active` or `deleted` |
| created_at | datetime | Yes | — | Record creation time |
| updated_at | datetime | Yes | — | Last update time |

Ebook **files** and **covers** are not stored in this table. Binaries use Active Storage.

File metadata (`filename`, `byte_size`, `content_type`) is read from `active_storage_blobs` at serializer/API time.

## Active Storage

| Attachment | Name | Purpose |
|------------|------|---------|
| Ebook file | `file` | PDF or EPUB blob |
| Cover image | `cover` | Optional JPEG/PNG/WebP |

Tables:

- `active_storage_blobs` — key, filename, content_type, byte_size
- `active_storage_attachments` — polymorphic link to `Ebook`
- `active_storage_variant_records` — reserved for future image variants

## Relationships

```
Ebook
   ├── has_one_attached :file
   └── has_one_attached :cover
```

## Delete Strategy

Soft delete via `status` enum (`active` → `deleted`). Deleted ebooks are excluded from list and search. Blobs remain until an explicit purge policy is added.

## Validations

- Title required (max 255 characters)
- Author optional (max 255 characters)
- Description optional (max 5000 characters)
- File required — PDF or EPUB only
- Maximum file size: 100 MB
- Cover optional — image types only, max 10 MB

## Scopes

- `active` — non-deleted library entries
- `recent` — newest first (`created_at DESC`)
- `alphabetical` — `title ASC`
- `search_by(query)` — active ebooks only; ILIKE on title, author, blob filename

## Indexes

| Index | Column(s) | Purpose |
|-------|-----------|---------|
| `index_ebooks_on_title` | title | Sort/filter by title |
| `index_ebooks_on_author` | author | Author search |
| `index_ebooks_on_created_at` | created_at | Recent ordering |
| `index_ebooks_on_status` | status | Fast active-only queries |

## Client-side persistence (Flutter)

Not in PostgreSQL — stored on device:

- **Recently read** — `SharedPreferences` (`RecentlyReadService`)
- **Downloaded files** — app documents directory (`DownloadService`)
