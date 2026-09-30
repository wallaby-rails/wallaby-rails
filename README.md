# Wallaby

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Wallaby is a family of Rails engine gems that autocomplete resourceful
controllers and views for an ORM (ActiveRecord) to build admin interfaces.

It can be extended to support any ORM model and can be easily and deeply
customized at MVC's different aspects by using
[decorators](docs/decorator.md), [controllers](docs/api-references/controller.md),
[type partials](docs/view.md), [servicers](docs/servicer.md),
[authorizers](docs/authorizer.md), [paginators](docs/paginator.md) and
[themes](docs/theme.md).

## Documentation

Documentation is available at
<https://wallaby-rails.github.io/wallaby-rails>, or in the repository under
[`docs/`](docs/).

## Repository layout

This is a monorepo of five independently released gems:

| Gem | Path | Description |
| --- | --- | --- |
| `wallaby-view` | [`wallaby-view/`](wallaby-view/) | Plain view/rendering helpers, no Rails app |
| `wallaby-core` | [`wallaby-core/`](wallaby-core/) | Core: decorators, servicers, paginators, providers |
| `wallaby-active_record` | [`wallaby-active_record/`](wallaby-active_record/) | ActiveRecord adaptor for `wallaby-core` |
| `wallaby` | [`wallaby/`](wallaby/) | Rails engine (`app/`), assets, generators, JS |
| `wallaby-cop` | [`wallaby-cop/`](wallaby-cop/) | Shared RuboCop config, standalone |

Each gem has its own `README.md` and `CHANGELOG.md`.

## Quick start

Add `wallaby` to the `Gemfile` and mount the engine (see the
[documentation](https://wallaby-rails.github.io/wallaby-rails) for details):

```ruby
# Gemfile
gem 'wallaby'
```

```ruby
# config/routes.rb
mount Wallaby::Engine, at: '/admin'
```

Then run the installer to set everything up:

```shell
rails g wallaby:install admin
```