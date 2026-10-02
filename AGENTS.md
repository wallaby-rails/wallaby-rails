# AGENTS.md

Wallaby is a family of Rails engine gems that autocomplete resourceful
controllers and views for an ORM (ActiveRecord) to build admin interfaces.

## Repository layout

Monorepo of five gems plus the documentation site. Dependency direction
(low → high):

| Gem | Path | Role |
| --- | --- | --- |
| `wallaby-view` | `wallaby-view/` | Plain view/rendering helpers, no Rails app |
| `wallaby-core` | `wallaby-core/` | Core: decorators, servicers, paginators, providers |
| `wallaby-active_record` | `wallaby-active_record/` | ActiveRecord adaptor for `wallaby-core` |
| `wallaby` | `wallaby/` | Rails engine (`app/`), assets, generators, JS |
| `wallaby-cop` | `wallaby-cop/` | Shared RuboCop config, standalone |

Supporting structure at the repository root:

| Area | Path | Role |
| --- | --- | --- |
| Documentation site | `docs/`, `index.md`, `_config.yml` | just-the-docs (Jekyll) site covering the whole project; home page is `index.md`, pages under `docs/` |
| Docs deployment | `.github/workflows/pages.yml` | Builds the Jekyll site and deploys to GitHub Pages on pushes to `main` (also `workflow_dispatch`) |
| CI (lint) | `.github/workflows/pr-build.yml` | RuboCop only, on changed files (does not run specs) |
| Test harness | `spec/` | Host dummy app at `spec/dummy`; `spec/support/` holds helpers/shared examples |
| Version matrix | `.gemfiles/` | `Gemfile.rails-8.0` / `Gemfile.rails-8.1` for the CI matrix; do not pin Ruby |
| Agent files | `.opencode/` | Skills for running specs and releasing gems (see [Skills](#skills)) |

- `wallaby-core` is the bulk of the logic under `lib/wallaby/`; the `wallaby`
  gem is mostly the mountable engine in `app/` plus `lib/wallaby/generators/`.
- Gem versions are independent. `wallaby`'s gemspec comment
  (`This will determine wallaby-core's version`) means the dependency
  constraints in the gemspecs must stay in sync when releasing.
- The docs site is built by GitHub Pages with the `github-pages` gem, which
  only bundles its own themes — so `_config.yml` must keep using
  `remote_theme: just-the-docs/just-the-docs` (fetched at build time), not
  `theme: just-the-docs`. Jekyll build artifacts (`.jekyll-cache/`, `_site/`)
  are gitignored.

## Toolchain

- Ruby: root `Gemfile` pins `ruby '4.0.7'`; gems require `>= 3.3.0`.
  The `.gemfiles/*` matrix gemfiles do **not** pin a Ruby version.
- Rails: `~> 8.1.0` in the root Gemfile; CI matrix is Rails `8.0` / `8.1`.
- `Gemfile.lock` is gitignored. Never commit it.

## Commands

Run from the repository root.

```shell
bundle install                 # root Gemfile (requires Ruby 4.0.7)
bundle exec rspec              # full suite
bundle exec rspec path/to_spec.rb:42   # single example
bundle exec rake               # default task == spec
bundle exec rubocop            # lint
bundle exec rubocop path/to/file.rb
bundle exec yard               # API docs (.yardopts)
```

Rails/Ruby version matrix (used by CI and for compatibility checks):

```shell
BUNDLE_GEMFILE=.gemfiles/Gemfile.rails-8.0 bundle install
BUNDLE_GEMFILE=.gemfiles/Gemfile.rails-8.0 bundle exec rspec
# same with .gemfiles/Gemfile.rails-8.1
```

## Docker

`Dockerfile`, `docker-compose.yml` and `docker/entrypoint.sh` provide a
self-contained dev environment (Ruby 4.0.7, Node/Yarn, Postgres 18, MySQL 9) so
the suite and the dummy app can run without a local toolchain. SQLite is
file-based and needs no service.

```shell
docker compose build                                 # build the app image
docker compose up -d                                 # app + Postgres + MySQL
docker compose exec app bin/rails db:schema:load     # load the test schemas
docker compose exec app bundle exec rspec            # full suite
docker compose exec app bundle exec rspec spec/foo_spec.rb:42
```

- Gems are installed into the `bundle` named volume; the entrypoint runs
  `bundle install` on first boot and whenever the Gemfile changes.
- The `app` service defaults to `RAILS_ENV=test`, like CI. To boot the dummy app
  (the service publishes `${APP_PORT:-3000}`), override the environment:

  ```shell
  docker compose exec -e RAILS_ENV=development app bin/rails db:schema:load
  docker compose exec -e RAILS_ENV=development app bin/rails server -b 0.0.0.0
  ```

- Database ports are intentionally not published, so the stack does not clash
  with a local Postgres/MySQL. Publish them per service if a host client needs
  access. `postgres:18` mounts its data at `/var/lib/postgresql` (not `.../data`).
- Node 20 / Yarn 1 are in the image for the `wallaby` gem's asset build, kept in
  the `node_modules` volume:

  ```shell
  docker compose exec app bash -lc 'cd wallaby && yarn install'
  docker compose exec app bash -lc 'cd wallaby && yarn build:js && yarn build:scss'
  ```
- `db:seed` populates demo data for the dummy app (products, categories, orders,
  blogs with Active Storage images). It downloads placeholder images from
  `picsum.photos`, so it needs network access.
- `ostruct` and `puma` were added as development dependencies so the dummy app
  boots on Ruby 4.0 (`massa` requires `ostruct`, which is no longer a default
  gem) and so `bin/rails server` has a server gem. The specs need neither.

## Testing

- Specs boot the **host dummy app** at `spec/dummy`, not the gems in isolation.
  `spec/rails_helper.rb` requires `dummy/config/environment`.
- `DB` selects the adapter the specs run against (default `postgresql`):

  ```shell
  DB=postgresql POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rspec
  DB=mysql MYSQL_ROOT_PASSWORD=password bundle exec rspec
  DB=sqlite bundle exec rspec
  ```

  Schemas live in `spec/dummy/db/{sqlite,postgresql,mysql}_schema.rb` and all
  three carry the shared tables. `AllPostgresType` is pinned to the `postgresql`
  connection (like `AllMysqlType`/`AllSqliteType`), so its PostgreSQL-only
  columns work regardless of which adapter `DB` selects.
- **All three databases must be running**, regardless of `DB`. The dummy app
  overrides `db:test:load_schema` and `db:test:purge` in
  `spec/dummy/lib/tasks/database.rake` to loop over `postgresql`, `mysql` and
  `sqlite`; the purge task also touches every configured connection. `DB=sqlite`
  therefore does **not** avoid needing Postgres and MySQL. CI supplies Postgres
  and MySQL services for this reason.
- Coverage: `simplecov` enforces `SimpleCov.minimum_coverage 100` in
  `spec/rails_helper.rb`. Adding untested code fails the suite. Set `DEEP=1`
  to switch to `deep-cover` instead.
- CI (`.github/workflows/pr-build.yml`) runs **RuboCop only**, and only on
  changed files. It does not run the test suite. A green CI does not mean the
  specs pass — run them yourself.

## Conventions

- Every Ruby file starts with `# frozen_string_literal: true`.
- RuboCop config is inherited from the local `wallaby-cop` gem
  (`gitlab-styles` + `rubocop-rails` + `rubocop-rspec`, `Layout/LineLength`
  max 120). Spec files are excluded from several cops — see `.rubocop.yml`.
- Follow Keep a Changelog + SemVer. Each gem has its own `CHANGELOG.md` with an
  `## [Unreleased]` section; add entries there.
- Test support lives in `spec/support/` (helpers, metadata, shared examples,
  custom spec types), auto-required by `rails_helper.rb`.

## Gotchas

- **Docs live in this repo.** The documentation site (just-the-docs/Jekyll) is
  built from the root `_config.yml` and the markdown under `docs/`. The
  `docs/*.md` links in `wallaby/README.md` point at these local files. When
  adding or updating documentation, edit the markdown in `docs/` and add Jekyll
  build artifacts (`.jekyll-cache/`, `_site/`) to `.gitignore`, not the repo.
- `wallaby-cop`'s version constant is in `lib/wallaby-cop.rb`
  (`Wallaby::Cop::VERSION`), not a `version.rb`.
- `wallaby` has a separate JS/asset build (`package.json`, `yarn.lock`);
  `node_modules/` is gitignored.
- RuboCop command in CI uses `--force-exclusion` against `git diff` output.
- **`csv` must stay declared.** It is not a default gem since Ruby 3.4, but
  `wallaby-core` and `wallaby` `require 'csv'` at runtime, so each gemspec
  declares it. Do not remove those dependencies.
- Building Ruby 4.0.7 locally on macOS needs `MACOSX_DEPLOYMENT_TARGET` set to
  the Homebrew libraries' target (e.g. `26.0`); the default in some shell setups
  is lower, and `ld` warnings then make Ruby's configure probes report false
  negatives.

## Skills

- `.opencode/skills/run-wallaby-specs` — running/debugging the suite.
- `.opencode/skills/release-wallaby-gems` — version bumps and releases.
