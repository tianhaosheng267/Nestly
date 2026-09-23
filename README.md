# Nestly

A rental housing web application originally developed for CSE 3901. Built with Ruby on Rails, server-rendered ERB views, SQLite, Hotwire, and Bootstrap.

## Features

- Account registration, login, and password recovery with Devise.
- Property listings with multiple photos, upload previews, and featured-photo selection.
- Like/pass browsing with rent, bedroom, and bathroom filters.
- Saved properties with pinned favorites.
- Tour requests with owner approval and completion states.
- Property-specific conversations between users and property owners.
- Free ZIP/radius apartment discovery, a separate results page, and a mixed community/property swipe deck.
- Gmail OAuth integration for apartment email threads (requires owner configuration).

Messaging uses HTTP requests and page navigation; it currently has no live WebSocket delivery.

## Windows development

The local environment was verified with RubyInstaller Ruby 3.3.12, Bundler 4.0.15, Rails 8.1.3, and libvips 8.18.4. Dependency versions remain locked in `Gemfile.lock`. The original `.ruby-version` and Dockerfile specify Ruby 3.3.3; Windows uses a newer patch release of the same 3.3 series.

From a newly opened PowerShell terminal in the project directory:

```powershell
.\start.cmd
```

Open http://127.0.0.1:3000 and press Ctrl+C in the terminal to stop the server. Alternatively:

```powershell
ruby bin/rails server -b 127.0.0.1
```

See [Windows environment instructions](docs/WINDOWS_SETUP.zh-CN.md) for installation, database handling, and verification commands.

## Tests and current limitations

```powershell
$env:RAILS_ENV = "test"
ruby bin/rails db:prepare
Remove-Item Env:RAILS_ENV
$env:PARALLEL_WORKERS = "1"
ruby bin/rails test
bundle exec rspec
```

The legacy `users.role` test setup has been repaired. The suite includes discovery, access isolation, Gmail thread rendering, and duplicate-send protection. External API behavior is mocked in automated tests; Gmail still needs a real OAuth account for end-to-end verification.

See [free discovery and Gmail setup](docs/FREE_SEARCH_AND_GMAIL.zh-CN.md) for configuration and limits. The earlier [project review](docs/PROJECT_REVIEW.zh-CN.md) is a historical review, not a current test report.

Local development uses SQLite files and disk-backed uploads; no PostgreSQL, MySQL, Redis, Node.js build step, or SMTP account is required. Bootstrap is loaded from a CDN and needs internet access. Development password-reset emails are available at `/letter_opener`.
