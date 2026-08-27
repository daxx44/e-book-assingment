# Ebook Library — Rails API Backend

Ruby on Rails 8 API-only backend for the Digital Ebook Library.

## Prerequisites

- Ruby 3.3+
- PostgreSQL 17+
- MSYS2 / RubyInstaller DevKit (Windows, for native gems)

## Setup

From the **repository root**, enter `backend/`:

```bash
cd backend
cp .env.example .env   # optional: set DATABASE_PASSWORD
bundle install
```

**Windows (PowerShell):**

```powershell
$env:DATABASE_PASSWORD = "postgres"
bundle exec rails db:create db:migrate
bundle exec rails db:seed    # optional demo ebooks
```

**macOS / Linux:**

```bash
export DATABASE_PASSWORD=postgres
bundle exec rails db:create db:migrate
bundle exec rails db:seed
```

### Windows notes

If `bundle` is not found, add Ruby to PATH (e.g. `C:\Ruby33-x64\bin`).

## Run

```powershell
$env:DATABASE_PASSWORD = "postgres"
bundle exec rails server
```

Server listens on **`0.0.0.0:3000`** so Android devices on your LAN can connect.

Verify:

```powershell
Invoke-WebRequest http://localhost:3000/api/v1/health
```

## API endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/health` | Health check |
| GET | `/api/v1/ebooks` | List active ebooks |
| POST | `/api/v1/ebooks` | Upload PDF/EPUB (+ optional cover) |
| GET | `/api/v1/ebooks/:id` | Ebook details |
| GET | `/api/v1/ebooks/search?q=` | Search ebooks |
| GET | `/api/v1/ebooks/:id/download` | Download file |
| DELETE | `/api/v1/ebooks/:id` | Soft delete |

## Test

```powershell
$env:DATABASE_PASSWORD = "postgres"
bundle exec rspec
bundle exec rubocop
```

Last verified: **42 examples, 0 failures** — see [../docs/test-results/TEST_RUN_OUTPUT.md](../docs/test-results/TEST_RUN_OUTPUT.md).

## API base URL

- Local: `http://localhost:3000/api/v1`
- Flutter client config: [../mobile/lib/core/config/api_config.dart](../mobile/lib/core/config/api_config.dart)

Full API docs: [../docs/API.md](../docs/API.md)
