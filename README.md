# Nestly

**Discover apartments, build a shortlist, and organize rental inquiries in one place.**

Nestly is a full-stack Ruby on Rails application combining location-based apartment discovery with swipe-style browsing, saved favorites, property management, and tour requests. 

## Product workflow

1. Create an account and choose a US ZIP code and search radius.
2. Explore nearby apartment records in a dedicated results page.
3. Like or pass on discovered apartments and manually listed properties; pin favorites to a shortlist.
4. View community details, request tours for manual listings, or start an email inquiry after connecting Gmail.

Property owners can create and edit listings, upload multiple photos, select a featured photo, and manage tour requests. Manual listings remain available without an external search provider.

## Engineering highlights

- **Geospatial discovery:** converts ZIP codes to coordinates, queries OpenStreetMap through Overpass, filters by Haversine distance, and deduplicates nearby records with matching names. Shared 24-hour caching and per-user request limits reduce repeated provider calls.
- **Two listing sources, one browsing flow:** imported communities and user-created properties use separate models and swipe records while sharing the browsing and favorites experience.
- **OAuth email integration:** Gmail authorization uses state validation and PKCE; tokens are encrypted at rest. Conversation access is scoped to the signed-in user, email bodies are rendered as text, and signed submission tokens protect against duplicate sends from the same form.
- **Rails application design:** Active Record associations, database constraints, owner-scoped listing updates, service objects for external APIs, and server-rendered ERB views with Turbo and Stimulus.
- **Failure handling:** unsuccessful searches preserve previous results; incomplete provider responses are rejected; uncertain email deliveries are surfaced instead of silently retried.

## Technology

| Layer | Tools |
| --- | --- |
| Backend | Ruby 3.3, Rails 8.1, Puma |
| UI | ERB, Hotwire (Turbo / Stimulus), Bootstrap, CSS |
| Persistence | SQLite, Active Record, Active Storage |
| Authentication | Devise; optional Google OAuth for Gmail |
| External services | OpenStreetMap / Overpass, Zippopotam.us, Gmail API |
| Tests | RSpec request/service/model tests and Rails Minitest |

No separate Node.js build step, PostgreSQL server, or Redis instance is required for local development.

## Run locally

Prerequisites: Ruby 3.3 with development tools, Bundler 4.0.15, and libvips for image processing. Dependencies are pinned in `Gemfile.lock`. Windows has been tested with RubyInstaller 3.3.12; `.ruby-version` and the Dockerfile specify 3.3.3.

From the cloned repository:

```sh
gem install bundler -v 4.0.15
bundle install
ruby bin/rails db:create db:migrate
ruby bin/rails server -b 127.0.0.1
```

Open **http://127.0.0.1:3000** and register a local account. On Windows, `start.cmd` can start the server after setup. Keep the terminal running while using the application.

Try ZIP `43214` with a 5-mile radius, or choose **Browse manually listed homes instead** and create a listing under **My Properties**. Map search requires internet access but no API key. Bootstrap is loaded from a CDN. Development password-reset messages can be inspected at `/letter_opener`.

The commands above create an empty database without running seeds. The legacy course seed script is optional, contains demo credentials, and is not safe to rerun against existing data or use in production. [Windows setup guide](docs/WINDOWS_SETUP.zh-CN.md).

### Optional Gmail setup

Set `GOOGLE_OAUTH_CLIENT_ID`, `GOOGLE_OAUTH_CLIENT_SECRET`, and `GOOGLE_OAUTH_REDIRECT_URI` in the server environment. The local callback is `http://127.0.0.1:3000/gmail/callback`. Enable Gmail API, configure the OAuth consent screen and test users, then connect an account from **Inbox**. Environment variables are not automatically loaded from `.env` files.

Search, listings, swiping, and favorites work without Gmail configuration. See the [configuration guide](docs/FREE_SEARCH_AND_GMAIL.zh-CN.md) for details.

## Tests

```sh
ruby bin/rails db:prepare RAILS_ENV=test
ruby bin/rails test
bundle exec rspec
```

On Windows, set `$env:PARALLEL_WORKERS = "1"` before running Minitest.

The latest verified run includes **39 RSpec examples and 15 Minitest tests**, all passing. Coverage includes search validation and import, mixed-source browsing, access isolation, OAuth callback replay protection, token encryption, escaped email rendering, and duplicate-send handling. External APIs are mocked in automated tests; these counts are not a code-coverage percentage.

## Code map

| Area | Entry points |
| --- | --- |
| Apartment search | `app/services/open_apartment_search.rb`, `app/controllers/apartments_controller.rb` |
| Swipe and shortlist | `app/controllers/swipes_controller.rb`, `app/controllers/community_swipes_controller.rb` |
| Gmail integration | `app/services/gmail_oauth.rb`, `app/services/gmail_client.rb`, `app/controllers/email_conversations_controller.rb` |
| Listings and tours | `app/models/property.rb`, `app/controllers/properties_controller.rb`, `app/controllers/tour_requests_controller.rb` |
| Regression tests | `spec/requests/`, `spec/services/`, `test/controllers/` |

## Current scope

This repository is a local development portfolio project, not a deployed rental service. Open-map coverage varies, results are capped, and records may describe individual apartment buildings rather than entire communities. Missing photos, prices, availability, and email addresses are not invented. Large-radius searches can time out on public Overpass servers.

Gmail integration is implemented and covered by mocked tests; live account authorization and end-to-end email delivery still require verification. Replies refresh on navigation or reload; attachments and real-time notifications are not implemented. Production deployment, OAuth verification, and provider capacity planning remain future work; the included Kamal configuration is a template.

## Project background and attribution

Map data is attributed to [OpenStreetMap contributors](https://www.openstreetmap.org/copyright); ZIP coordinates come from [Zippopotam.us](https://www.zippopotam.us/). Included photographs are demo assets; their source and redistribution permissions have not been documented in this repository.

## Project is still developing and updating
