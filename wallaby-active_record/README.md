# [Wallaby::ActiveRecord](https://github.com/wallaby-rails/wallaby-active_record)

[![Gem Version](https://badge.fury.io/rb/wallaby-active_record.svg)](https://badge.fury.io/rb/wallaby-active_record)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Travis CI](https://travis-ci.com/wallaby-rails/wallaby-active_record.svg?branch=master)](https://travis-ci.com/wallaby-rails/wallaby-active_record)
[![Maintainability](https://api.codeclimate.com/v1/badges/9ba0a610043a2e1a9e74/maintainability)](https://codeclimate.com/github/wallaby-rails/wallaby-active_record/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/9ba0a610043a2e1a9e74/test_coverage)](https://codeclimate.com/github/wallaby-rails/wallaby-active_record/test_coverage)
[![Inch CI](https://inch-ci.org/github/wallaby-rails/wallaby-active_record.svg?branch=master)](https://inch-ci.org/github/wallaby-rails/wallaby-active_record)

`Wallaby::ActiveRecord` adapter is designed to seamlessly integrate ActiveRecord models and instances with the [Wallaby::Core](https://github.com/wallaby-rails/wallaby-core)
interfaces, enabling smooth handling of CRUD operations, authorization, and pagination.

Key features of `Wallaby::ActiveRecord` include:

- Offer built-in compatibility with popular authorization frameworks like CanCanCan and Pundit, allowing you to easily manage access control for your ActiveRecord models.
- Fully support all Rails associations (`belongs_to`, `has_one`, `has_many`, `has_and_belongs_to_many`).
- All PostgreSQL types supported by Rails are fully supported to ensure smooth handling of data with different types.
- Facilitate the normalization of data during form submissions, specifically for `binary`, `point` and `range` types.
- Provide the flexibility to define custom filters for the `index` action, enabling you to create tailored queries based on your specific requirements.
- Allow sorting for single or multiple columns and provide `nulls` sorting option, enhancing the control and precision of result ordering.
- Support STI (Single Table Inheritance)
- Offer advance search capabilities using a convenient colon syntax, empowering users to perform precise searches with ease.

## Install

Add `Wallaby::ActiveRecord` to `Gemfile`.

```ruby
gem 'wallaby-active_record'
```

And re-bundle.

```shell
bundle install
```

## Documentation

- [API Reference](https://www.rubydoc.info/gems/wallaby-active_record)
- [Change Logs](https://github.com/wallaby-rails/wallaby-active_record/blob/master/CHANGELOG.md)

## Want to contribute?

Raise an [issue](https://github.com/wallaby-rails/wallaby-active_record/issues/new), discuss and resolve!

## License

This project uses [MIT License](https://github.com/wallaby-rails/wallaby-active_record/blob/master/LICENSE).
