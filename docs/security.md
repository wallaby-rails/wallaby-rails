---
title: Security
layout: default
nav_order: 9
---

# Security

Wallaby is a generic admin interface generator: it discovers your models and
exposes resourceful CRUD pages for them. That makes the security posture of a
Wallaby mount depend heavily on how the host application wires authentication
and authorization. This page describes the defaults Wallaby provides and what a
host application must configure.

## Authentication is fail-closed

Wallaby runs `before_action :authenticate_wallaby_user!` on every resourceful
action. The default implementation:

1. calls `authenticate_user!` on the controller if it exists, and
2. **denies the request unless that call returns a truthy value.**

If your application does not define `authenticate_user!` (or you do not override
`authenticate_wallaby_user!`), every request is rejected with `401`.

Provide authentication in your Wallaby base controller:

```ruby
# app/controllers/admin/application_controller.rb
class Admin::ApplicationController < Wallaby::ResourcesController
  base_class!

  # With Devise:
  def authenticate_wallaby_user!
    authenticate_user!
  end

  # Or with HTTP Basic:
  # def authenticate_wallaby_user!
  #   authenticate_or_request_with_http_basic do |username, password|
  #     ActiveSupport::SecurityUtils.secure_compare(username, ENV.fetch('ADMIN_USER')) &
  #       ActiveSupport::SecurityUtils.secure_compare(password, ENV.fetch('ADMIN_PASSWORD'))
  #   end
  # end
end
```

Because the method is included into `Wallaby::ResourcesController`, defining it
on your base controller and calling `super` also works.

## Authorization defaults to allow-all

When neither CanCanCan nor Pundit is detected, Wallaby falls back to the
`DefaultAuthorizationProvider`, which allows every action on every resource for
every user. Wallaby logs a warning the first time this fallback is used.

For any non-trivial deployment, install one of the supported frameworks:

- [CanCanCan](https://github.com/CanCanCommunity/cancancan)
- [Pundit](https://github.com/varvet/pundit)

and define the corresponding authorizer/policy. See
[Authorizer](authorizer.md) for details.

The bundled `Ability` class (`can :manage, :all`) is only used when a host
application has not defined its own `ability.rb`.

## Mass assignment

The ActiveRecord service provider allowlists the model's own columns for mass
assignment (excluding the primary key and timestamps). To restrict which
attributes a user may change, implement `permit_params` / `attributes_for` in
your authorizer (Pundit) or use CanCanCan's attribute restrictions.

## Query input

- Keyword search (`q`) is escaped before it is used in `LIKE` clauses, and the
  query string is capped at 1000 characters (`Querier::MAX_QUERY_LENGTH`);
  longer queries are rejected with `422 Unprocessable Entity`.
- `sort` is restricted to the decorator's index fields whose names are plain
  identifiers (`[a-zA-Z_][a-zA-Z0-9_]*`); unsupported directions are dropped.
- `filter` is only honoured for filters **explicitly declared by the decorator**.
  An undeclared filter value never becomes a method call on the model class.

## Missing policies fail closed

With the Pundit provider, a resource without a policy class (or scope policy)
responds `403 Forbidden` (action) or is reported by `authorized?` as `false`
instead of raising a `500`. Scope lists fall back to the unfiltered scope with
a logged warning, so remember to define `ApplicationScope`/per-model scopes.

## Gravatar portraits are opt-in

`user_portrait` sends an MD5 hash of the user's email address to gravatar.com
only when you explicitly enable it:

```ruby
class Admin::ApplicationController < Wallaby::ResourcesController
  self.gravatar_enabled = true
end
```

By default the local FontAwesome user icon is rendered; no email-derived data
leaves your server.

## Output encoding

- Model values are HTML-escaped by default. The `raw` field type is sanitized
  before rendering, and is intended for trusted content only.
- Flash messages and validation errors are escaped (not rendered as raw HTML).
- CSV exports neutralise spreadsheet formula injection by prefixing cells that
  begin with `=`, `+`, `-`, `@`, tab or carriage return with `'`.

## Parameter filtering

The install generator writes a `config/initializers/filter_parameter_logging.rb`
that filters common credential/secret parameters. Extend the list with any
sensitive attributes specific to your models.

## Rate limiting and resource enumeration

Wallaby `find`s records by id or slug without throttling. Exposed mounts should
be protected at the application or infrastructure layer (e.g. `rack-attack` or a
reverse-proxy rate limit). This is a host responsibility.

## Reporting a vulnerability

Please report security issues privately to the maintainers rather than opening a
public issue.
