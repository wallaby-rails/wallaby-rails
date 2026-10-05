---
title: Security Audit Report
layout: default
nav_exclude: true
---

# Wallaby Rails — OWASP Security Audit Report

- **Repository:** `wallaby-rails` (monorepo: `wallaby`, `wallaby-core`,
  `wallaby-active_record`, `wallaby-view`, `wallaby-cop`)
- **Audit type:** OWASP Top 10 (2021)-style review of the gems, the dummy host
  app (`spec/dummy`), and the Docker/CI setup
- **Branch with fixes:** `security/owasp-hardening`
- **Base commit:** `d4173ca` (critical/high hardening) + second commit
  (medium/low hardening) on top of `main`
- **Status:** All critical/high/medium/low items below are implemented and
  verified (full suite: 1940 examples, 0 failures, 100% line coverage;
  RuboCop clean on changed files).

> This report is intentionally self-contained. It lists each finding with
> severity, evidence (file:line), impact, the fix, and its status, so another
> session can continue the work without re-doing the analysis.

---

## How to reproduce the environment

The gem pins Ruby 4.0.7 and needs **PostgreSQL and MySQL** running (the dummy
app loads all three schemas regardless of `DB`). A Docker dev stack is provided.

```shell
cd /Users/tian/Desktop/workspace/wallaby-rails
docker compose up -d                 # app + postgres 18 + mysql 9
docker compose exec app bundle exec rspec            # full suite
docker compose exec app bundle exec rspec spec/security  # security suite
docker compose exec app bundle exec rubocop <changed files>
```

Notes:
- `spec/rails_helper.rb` enforces `SimpleCov.minimum_coverage 100`. Any new
  production line must be covered by a spec or the suite exits non-zero.
- The dummy app's `ApplicationController` and `Api::PicturesController`
  deliberately opt out of authentication (test harness only). Do not copy that
  into a real app.

---

## Summary table

| ID | Severity | Category | Title | Status |
|----|----------|----------|-------|--------|
| C1 | Critical | A01/A03 | `?filter=` can invoke arbitrary model methods | **Fixed** |
| C2 | Critical | A01/A07 | Fail-open auth + allow-all default authorizer | **Fixed** |
| C3 | Critical | A03 | Request input broadens into SQL/method surface | **Fixed** (C1/M4/M1) |
| H1 | High | A03 | `raw`/`html_safe` on model values & flash (XSS) | **Fixed** |
| H2 | High | A03 | CSV formula injection | **Fixed** |
| H3 | High | A04 | Mass-assignment default is permissive | Documented, by design pinned to authorizer |
| H4 | High | A09 | Sensitive params not filtered from logs | **Fixed** |
| M1 | Medium | A01 | `constantize` of user-controlled resource names | **Fixed** |
| M2 | Medium | A03 | Method invocation by name from metadata | Hardened (no user-controlled names left) |
| M3 | Medium | A03 | Inline JS with server data | **Fixed** (external asset) |
| M4 | Medium | A03 | `Arel.sql` sort built from request input | **Fixed** |
| M5 | Medium | A03 | `ClassHash`/`ClassArray` strings→classes | Accepted, internal |
| M6 | Medium | A10 | `URI.open` in seeds (SSRF primitive) | **Fixed** |
| M7 | Medium | A06/A08 | Unpinned CI images, no dependency audit | **Fixed** |
| L1 | Low | A02 | Gravatar leaks email hash by default | **Fixed** |
| L2 | Low | — | `user.methods.grep(/email/i)` picks arbitrary method | **Fixed** (gravatar gated) |
| L3 | Low | A03 | Flash `type` injected into class attribute | **Fixed** |
| L4 | Low | A03 | `body_class` attribute injection | **Fixed** |
| L5 | Low | A03 | Error page message rendering | OK (escaped) |
| L6 | Low | A01/A07 | Pundit `NotDefinedError` surfaces as 500 | **Fixed** |
| L7 | Low | A04 | No rate limiting / enumeration | Documented (host responsibility) |
| L8 | Low | A05 | Unbounded query parser (DoS) | **Fixed** |

---

## Critical

### C1 — `?filter=` can invoke arbitrary model class methods
- **Category:** A01 Broken Access Control / A03 Injection
- **Evidence:** `wallaby-active_record/lib/adapters/wallaby/active_record/model_service_provider/querier.rb`
  `filtered_by` (was `@model_class.try(scope)` with `scope` coming from
  `params[:filter]` via `FilterUtils.filter_name_by`).
- **Impact:** Any public model class method could be called, including
  destructive ones (`delete_all`, `destroy_all`, …). At minimum a method-name
  oracle; at worst data loss. Reachable whenever a `ModelDecorator` produced a
  non-empty `filters` hash (see `querier_spec.rb`).
- **Fix (committed):**
  - `filtered_by` only honours a filter when `@model_decorator.filters.key?(name)`.
  - A filter's `:scope` may no longer point at a method name different from the
    filter name itself.
  - Added `valid_filter?` guard.
- **Regression specs:** `spec/security/filter_injection_spec.rb`.

### C2 — Fail-open authentication and allow-all default authorizer
- **Category:** A01 / A04 Insecure Design / A07 Auth Failures
- **Evidence:**
  - `wallaby-core/lib/concerns/wallaby/authentication_concern.rb`:
    `raise NotAuthenticated if authenticated == false` — a missing
    `authenticate_user!` returned `nil`, treated as success.
  - `wallaby-core/lib/authorizers/wallaby/default_authorization_provider.rb`
    (`authorized?` → `true`) and `wallaby-core/app/security/ability.rb`
    (`can :manage, :all`).
  - Generated `Admin::ApplicationController` had authentication commented out.
- **Impact:** A fresh mount was an unauthenticated, fully-privileged CRUD console
  over every model. The highest real-world risk.
- **Fix (committed):**
  - `authenticate_wallaby_user!` now fails closed (`raise ... unless authenticated`);
    `super` is honoured so hosts can define it on the base controller.
  - One-off warning when the default authorizer is used
    (`ModelAuthorizer.warn_on_default_provider`).
  - Generator `application_controller.rb.erb` documents Devise/HTTP-Basic
    examples; `filter_parameter_logging.rb.erb` added.
- **Host action required:** override `authenticate_wallaby_user!` and install
  CanCanCan/Pundit (or a custom authorizer) before exposing a mount.
- **Regression specs:** `spec/security/authentication_spec.rb`,
  `spec/wallaby-core/concerns/wallaby/authentication_concern_spec.rb`.

### C3 — Request input broadens into SQL/method surface
- **Category:** A03
- **Resolution:** Addressed by C1 (filter), M4 (sort), M1 (resource lookup).
  `json_fields_of` was reviewed and is safe (intersected with
  `index_field_names`).

---

## High

### H1 — `raw`/`html_safe` rendered model values and flash (XSS)
- **Category:** A03
- **Evidence (pre-fix):**
  - `wallaby/app/views/wallaby/resources/show/_raw.html.erb:8`,
    `index/_raw.html.erb:8` → `value.html_safe`
  - `wallaby/app/views/wallaby/resources/_flash_messages.html.erb:11` → `raw message`
  - `wallaby/app/views/wallaby/resources/_form.html.erb:4` → `raw message`
  - `index/_json.html.erb`, `_jsonb`, `_hstore`, `_xml` → `imodal label, "<pre>#{h value}</pre>".html_safe`
  - ~40 `index/*.csv.erb` use `raw value`
- **Impact:** Stored XSS via any `raw`-type field; reflected XSS via error/flash
  text (the router writes attacker-influenced `resources` into `flash[:alert]`).
- **Fix (committed):**
  - flash + form errors: `<%= message %>` (escaped).
  - `_raw` (show/index): `sanitize value.to_s`.
  - `imodal` label/body no longer `.html_safe`; label escaped, body via
    `content_tag(:pre, value)`.
- **Regression specs:** `spec/security/output_encoding_spec.rb`.

### H2 — CSV formula injection
- **Category:** A03
- **Evidence:** `wallaby/app/views/wallaby/resources/index.csv.erb`,
  `ResourcesResponder#to_csv`, all `index/*.csv.erb` (`raw value`).
- **Impact:** Cells beginning with `=`, `+`, `-`, `@`, tab or CR execute as
  formulas in Excel/Sheets when the export is opened.
- **Fix (committed):** new `Wallaby::IndexHelper#csv_escape` prefixes such cells
  with `'`. Applied to header and data cells in `index.csv.erb`.
  Verified end-to-end (`'=cmd|;/C calc`).
- **Regression specs:** `spec/security/csv_injection_spec.rb`.

### H3 — Permissive mass-assignment default
- **Category:** A04
- **Evidence:** `wallaby-active_record/.../model_service_provider/permitter.rb`
  (`simple_field_names` allowlists essentially every column except PK/timestamps).
- **Assessment:** By design; field-level restriction is delegated to the
  authorizer (`permit_params`/`attributes_for`). No change made.
- **Action:** Keep documenting that per-role attribute restriction must be
  implemented in the authorizer/policy.

### H4 — Sensitive parameters not filtered from logs
- **Category:** A09
- **Evidence:** `spec/dummy/config/initializers/filter_parameter_logging.rb`
  filtered only `:password`.
- **Fix (committed):** filter list expanded; install generator now writes
  `config/initializers/filter_parameter_logging.rb` into host apps.
- **Regression specs:** `spec/security/parameter_filtering_spec.rb`.

---

## Medium

### M1 — `constantize` of user-controlled resource names
- **Category:** A01
- **Evidence:** `wallaby-core/lib/routes/wallaby/resources_router.rb`
  (`validate_model_by`), `wallaby-core/lib/wallaby/classifier.rb#to_class`.
- **Fix (committed):** router uses `String#safe_constantize`; unknown/non-model
  resources are rejected (404/422), never dispatched.
- **Regression specs:** `spec/security/router_resolution_spec.rb`.

### M2 — Method invocation by name from metadata
- **Category:** A03
- **Evidence:** `json_api_responder.rb:78` (`decorated.try(name)`),
  `model_decorator.rb:136` (`resource.try(title_method)`), `Utils::HashCloner`.
- **Assessment:** Names come from schema/metadata, not the request (C1 was the
  only user-controlled case). No further change.

### M3 — Inline JS with server data
- **Category:** A03
- **Evidence:** `form/_belongs_to.html.erb`, `form/_has_many.html.erb`,
  `form/_has_and_belongs_to_many.html.erb` (`javascript_tag`).
- **Assessment:** Server data was rendered into `data-*` attributes (escaped),
  not interpolated into the script text, so practical risk was low.
- **Fix (committed):** the auto-select setup moved to an external asset
  (`wallaby/app/assets/javascripts/wallaby/auto_select_init.js`, required from
  `base.js`); the three partials emit no inline `<script>`. The remaining
  type-partial inline scripts (summernote/codemirror/date widgets) are static
  and were left as-is to bound risk.

### M4 — `Arel.sql` sort built from request input
- **Category:** A03
- **Evidence:** `wallaby-active_record/.../querier.rb#sort`/`normalize_sort`;
  `wallaby-core/lib/services/wallaby/sorting/hash_builder.rb`.
- **Assessment pre-fix:** Not exploitable (three validations: field allowlist,
  `sort_disabled`, identifier shape; direction regex), but brittle.
- **Fix (committed):** added `plain_identifier?` guard in
  `normalize_sort` (field must match `/\A[a-zA-Z_][a-zA-Z0-9_]*\z/`).
- **Regression specs:** `spec/security/query_hardening_spec.rb`.

### M5 — `ClassHash`/`ClassArray` convert strings back to classes
- **Category:** A03
- **Evidence:** `wallaby-core/lib/wallaby/class_hash.rb#to_class`.
- **Assessment:** Internal maps only; keep as a hardening note.

### M6 — `URI.open` in seeds (SSRF primitive)
- **Category:** A10 SSRF
- **Evidence:** `spec/dummy/db/seeds.rb` fetched `https://picsum.photos/100`.
- **Fix (committed):** a `placeholder_image` helper restricts the
  host, caps size (`5 MB`), and sets a read timeout; `StringIO` for Active
  Storage attach.

### M7 — CI supply-chain / dependency audit
- **Category:** A06 / A08
- **Evidence:** `.github/workflows/pr-build.yml` (`postgres:latest`,
  `mysql:latest`, `actions/checkout@v2`, no audit).
- **Fix (committed):** pinned `postgres:18-alpine` / `mysql:9`, bumped
  `actions/checkout@v4`, added `permissions: contents: read`, added a
  `bundler-audit` step.

---

## Low / Informational

### L1 — Gravatar leaks email hash by default
- **Category:** A02 Cryptographic Failures / privacy
- **Evidence:** `wallaby-core/lib/helpers/wallaby/secure_helper.rb#user_portrait`
  built a gravatar URL from `MD5(email)` on every render.
- **Fix (committed):** new
  `Configurable::ClassMethods#gravatar_enabled` (default `false`); portrait
  returns the local icon unless explicitly enabled.
- **Regression specs:** `spec/wallaby-core/helpers/wallaby/secure_helper_spec.rb`
  (updated).

### L2 — `user.methods.grep(/email/i).min` picks an arbitrary method
- **Resolution:** unreachable unless gravatar is enabled; `email_method`
  remains the preferred explicit configuration.

### L3 — Flash `type` injected into class attribute
- **Category:** A03
- **Evidence:** `_flash_messages.html.erb` (`alert-<%= flash_classes[...] || type %>`).
- **Fix (committed):** fallback sanitised with
  `gsub(/[^a-zA-Z0-9_-]/, '')`.

### L4 — `body_class` attribute injection
- **Category:** A03
- **Evidence:** `wallaby-core/lib/helpers/wallaby/base_helper.rb#body_class`.
- **Fix (committed):** new `safe_class_token`; each token
  reduced to `[a-zA-Z0-9_-]`.

### L5 — Error page message rendering
- **Category:** A03
- **Evidence:** `error.html.erb:16` (`<%= @exception.try(:message) || flash[:alert] %>`).
- **Assessment:** Escaped by ERB; safe. The `raw` flash path (H1) was the risk
  and is fixed.

### L6 — Pundit `NotDefinedError` surfaces as 500
- **Category:** A01 / A07
- **Evidence:** `wallaby-core/lib/authorizers/wallaby/pundit_authorization_provider.rb`
  (`authorize`, `authorized?`, `accessible_for` only rescued
  `NotAuthorizedError`).
- **Fix (committed):** `authorize` rescues `NotDefinedError` →
  `Forbidden`; `authorized?` → `false`; `accessible_for` → returns scope + warns.
- **Regression specs:** `spec/security/pundit_provider_spec.rb`.

### L7 — No rate limiting / enumeration
- **Category:** A04
- **Assessment:** `find` accepts arbitrary ids/slugs; no throttling in the gem.
  Documentation should state rate limiting is a host concern.
- **Action:** add to `docs/security.md`.

### L8 — Unbounded query parser (DoS)
- **Category:** A05 Misconfiguration
- **Evidence:** `wallaby-active_record/.../querier/transformer.rb#execute`
  parses `params[:q]` with Parslet.
- **Fix (committed):** `Querier::MAX_QUERY_LENGTH = 1000`;
  `query_string` raises `Wallaby::UnprocessableEntity` when exceeded.
- **Regression specs:** `spec/security/query_hardening_spec.rb`.

---

## Files changed

Committed in `d4173ca`:

- `wallaby-active_record/lib/adapters/wallaby/active_record/model_service_provider/querier.rb`
- `wallaby-core/lib/authorizers/wallaby/model_authorizer.rb`
- `wallaby-core/lib/concerns/wallaby/authentication_concern.rb`
- `wallaby-core/lib/generators/wallaby/engine/install/install_generator.rb`
- `wallaby-core/lib/generators/wallaby/engine/install/templates/application_controller.rb.erb`
- `wallaby-core/lib/generators/wallaby/engine/install/templates/filter_parameter_logging.rb.erb` (new)
- `wallaby-core/lib/helpers/wallaby/index_helper.rb`
- `wallaby-core/lib/routes/wallaby/resources_router.rb`
- `wallaby/app/views/wallaby/resources/_flash_messages.html.erb`
- `wallaby/app/views/wallaby/resources/_form.html.erb`
- `wallaby/app/views/wallaby/resources/index.csv.erb`
- `wallaby/app/views/wallaby/resources/index/_hstore.html.erb`
- `wallaby/app/views/wallaby/resources/index/_json.html.erb`
- `wallaby/app/views/wallaby/resources/index/_jsonb.html.erb`
- `wallaby/app/views/wallaby/resources/index/_raw.html.erb`
- `wallaby/app/views/wallaby/resources/index/_xml.html.erb`
- `wallaby/app/views/wallaby/resources/show/_raw.html.erb`
- `spec/security/{authentication,csv_injection,filter_injection,output_encoding,parameter_filtering,router_resolution}_spec.rb` (new)
- `spec/wallaby-core/concerns/wallaby/authentication_concern_spec.rb`
- `spec/dummy/app/controllers/application_controller.rb`
- `spec/dummy/app/controllers/api/pictures_controller.rb`
- `spec/dummy/config/initializers/filter_parameter_logging.rb`
- `.github/workflows/pr-build.yml`
- `.rubocop.yml`
- `docs/security.md` (new), `index.md`
- CHANGELOGs: `wallaby-core`, `wallaby-active_record`, `wallaby`

Working tree at the time of writing → committed as the **second commit**
(medium/low batch) on `security/owasp-hardening`:

- `wallaby-active_record/lib/adapters/wallaby/active_record/model_service_provider/querier.rb` (M4, L8)
- `wallaby-core/lib/authorizers/wallaby/pundit_authorization_provider.rb` (L6)
- `wallaby-core/lib/concerns/wallaby/configurable.rb` (L1)
- `wallaby-core/lib/helpers/wallaby/base_helper.rb` (L4)
- `wallaby-core/lib/helpers/wallaby/secure_helper.rb` (L1)
- `wallaby/app/views/wallaby/resources/_flash_messages.html.erb` (L3)
- `spec/dummy/db/seeds.rb` (M6)
- `spec/wallaby-core/helpers/wallaby/secure_helper_spec.rb` (L1)
- `spec/security/pundit_provider_spec.rb` (L6, new)
- `spec/security/query_hardening_spec.rb` (M4/L8, new)
- `spec/security/class_token_spec.rb` (L3/L4, new)
- `.rubocop.yml` (added `RSpec/VerifiedDoubleReference` spec exclusion)
- CHANGELOGs and `docs/security.md` updated for the medium/low items

---

## Notes on behavior changes that hosts may notice

- **Authentication is now required.** Any controller that previously rendered
  anonymously without `authenticate_user!` now returns `401`. Hosts must either
  define `authenticate_user!` (e.g. Devise) or override
  `authenticate_wallaby_user!` explicitly (returning `true` opts out).
- **Gravatar portraits are off by default.** Set
  `self.gravatar_enabled = true` on the controller to restore the old behavior.
- **Long queries now 422.** Requests with `q` longer than 1000 characters are
  rejected. Raise `MAX_QUERY_LENGTH` if your use case needs bigger searches.
- **Missing Pundit policies now 403** instead of 500. Define policies/scopes
  (or an `ApplicationPolicy`/`ApplicationScope`) to keep resources reachable.

---

## Remaining work / suggested next steps

1. **CHANGELOG entries** — done (wallaby-core, wallaby-active_record, wallaby).
2. **Docs** — `docs/security.md` covers gravatar opt-in (L1), query length
   (L8), missing-policy behavior (L6), and rate limiting (L7).
3. **Follow-ups — done:**
   - M3: auto-select setup moved to
     `wallaby/app/assets/javascripts/wallaby/auto_select_init.js`; the
     `belongs_to` / `has_many` / `has_and_belongs_to_many` partials no longer
     emit inline `<script>`.
   - Root `SECURITY.md` added (supported versions, private reporting, scope).
   - `.github/dependabot.yml` (github-actions + npm) and a scheduled
     `.github/workflows/dependency-audit.yml` (weekly bundler-audit) added.
4. **Do not** commit a `Gemfile.lock` (gitignored by convention).

---

## Verification checklist (run in this order)

```shell
docker compose up -d
docker compose exec app bundle exec rspec spec/security   # 41 examples, 0 failures
docker compose exec app bundle exec rspec                 # expect 100% coverage
git diff --name-only --diff-filter AMT main -- '*.rb' \
  | xargs docker compose exec app bundle exec rubocop --force-exclusion
```

Verified state: **1940 examples, 0 failures, 100% line coverage**; RuboCop clean
on all changed files.
