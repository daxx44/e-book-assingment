# Implementation Status (Assignment Coverage)

**Assignment:** Sagar Fab International Company — Digital Ebook Library  
**Stack delivered:** Ruby on Rails 8 API + Flutter mobile app + PostgreSQL + Active Storage

This document maps the Sagar Fab International assignment requirements to what is **implemented in this repository**.

---

## Core features (Section 4)

| Requirement | Status | Notes |
|-------------|--------|-------|
| PDF upload | Done | Multipart `POST /api/v1/ebooks` |
| EPUB upload | Done | Bonus — `application/epub+zip` accepted |
| Metadata (title, author, description) | Done | Title required |
| Optional cover image | Done | JPEG/PNG/WebP on upload; `cover_url` in API |
| Ebook listing | Done | Wooden bookshelf UI, sort by recent/title/author |
| Ebook search | Done | Title, author, filename; debounced; highlights |
| Search filters / sort | Done | File-type quick filters; sort on library & search |
| PDF reading in-app | Done | Syncfusion PDF viewer |
| EPUB reading in-app | Done | Bonus — `epub_view`, chapters, font size |
| Last read position | Done | PDF page + EPUB CFI in `SharedPreferences` |
| Continue Reading section | Done | Horizontal strip on library home |
| Download | Done | Progress sheet; offline list in **Downloads** tab |
| Delete with confirmation | Done | Soft delete on server; UI refresh |
| Loading / empty / error states | Done | Shimmer, empty illustrations, server-down UI |

---

## Bonus areas (Section 10)

| Bonus | Status |
|-------|--------|
| Bookshelf-style UI | Done — wooden shelves, realistic book covers |
| Cover preview / upload | Done — custom cover or generated initials |
| EPUB support | Done |
| Last read position | Done |
| Recently read section | Done |
| Sorting & filtering | Done |
| Docker (PostgreSQL) | Done — `docker-compose.yml` at repo root |
| Seed / demo data | Done — `rails db:seed` |
| Documentation | Done — `README.md` + `docs/` |

---

## Deliverables (Section 8)

| Deliverable | Location |
|-------------|----------|
| Monorepo (Rails + Flutter) | This repository |
| README with setup & tests | [`README.md`](../README.md) |
| API documentation | [`API.md`](API.md) |
| Manual testing checklist | [`MANUAL_TESTING.md`](MANUAL_TESTING.md) |
| Automated test summary | [`TESTING.md`](TESTING.md), [`test-results/README.md`](test-results/README.md) (pasted terminal logs) |
| AI usage report | [`AI_USAGE.md`](AI_USAGE.md) |
| Screenshots | [`screenshots/`](screenshots/README.md) |

---

## Not implemented (honest limitations)

| Item | Reason |
|------|--------|
| User authentication | Out of scope — single-user local library |
| Cloud storage (S3, etc.) | Active Storage local disk only |
| API pagination | Personal-library scale; list returns all active ebooks |
| PDF text search in reader | EPUB in-book search supported; PDF search partial |
| iOS / desktop store builds | Developed and tested primarily on Android |
| Full RuboCop zero offenses | 2 minor style offenses in one spec file (non-blocking) |

---

## Mobile app structure (implemented)

- **Dashboard** — bottom tabs: Library, Downloads, About
- **Library** — bookshelf grid, Continue Reading, search entry, sort, upload FAB
- **Search** — dedicated screen with filters and recent searches
- **Upload** — PDF/EPUB + optional cover
- **Reader** — PDF or EPUB with progress footer
- **Downloads** — offline files, read without network when cached

---

## API base path

All endpoints are under **`/api/v1`** (not `/api` alone). See [`API.md`](API.md).
