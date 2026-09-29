---
name: run-wallaby-specs
description: Use when running or debugging the Wallaby test suite or a single spec, including rspec, spec/dummy boot failures, database selection, and the 100% coverage gate. Trigger on "run the tests", "rspec", "spec/dummy", "DB=sqlite".
---

# Running Wallaby specs

Specs boot the host dummy app at `spec/dummy`, not the gems in isolation.
`spec/rails_helper.rb` requires `dummy/config/environment`, so a failure there
usually means the database or Ruby version is wrong, not the gem under test.

## Pick the command

Run from the repository root. Prefer the narrowest target while iterating.

```shell
bundle exec rspec                                   # full suite (root Gemfile)
bundle exec rspec spec/wallaby-core/parsers/foo_spec.rb:42   # single example
bundle exec rake                                    # default task == spec
```

For the supported version matrix, point `BUNDLE_GEMFILE` at a matrix gemfile.
These do not pin Ruby, unlike the root Gemfile.

```shell
BUNDLE_GEMFILE=.gemfiles/Gemfile.rails-8.1 bundle install
BUNDLE_GEMFILE=.gemfiles/Gemfile.rails-8.1 bundle exec rspec
```

- Root Gemfile requires Ruby `4.0.7`; gems require `>= 3.3.0`.
- The `.gemfiles/*` gemfiles exist so the suite can run on the CI matrix
  (Rails 8.0 / 8.1).

## Choose a database

`DB` selects the adapter the specs run against; the default is `postgresql`.
But the dummy app's `db:test:load_schema` and `db:test:purge` overrides in
`spec/dummy/lib/tasks/database.rake` loop over Postgres, MySQL **and** SQLite,
so all three servers must be reachable no matter which `DB` you pick.

```shell
DB=sqlite bundle exec rspec
DB=postgresql POSTGRES_USER=postgres POSTGRES_PASSWORD=password bundle exec rspec
DB=mysql MYSQL_ROOT_PASSWORD=password bundle exec rspec
```

Schemas live in `spec/dummy/db/{sqlite,postgresql,mysql}_schema.rb`. If a run
fails before any example with a connection error, a database service is
missing — start it rather than editing the schema.

## Coverage gate

`spec/rails_helper.rb` sets `SimpleCov.minimum_coverage 100`. A spec run that
passes every example can still exit non-zero on coverage. Set `DEEP=1` to use
`deep-cover` instead of `simplecov`.

## Checklist before reporting success

1. The command ran against the intended `BUNDLE_GEMFILE`.
2. The database service for the selected `DB` was reachable.
3. Exit status was 0 — account for the coverage gate, not just the example
   summary.
4. Report the exact command and result. CI does not run the suite; a green PR
   build only means RuboCop passed.
