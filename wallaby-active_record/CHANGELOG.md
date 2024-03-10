# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [TODO]

- Refactor Transformer
- Consider to move the ActiveRecord related documents (.md files) back to this repo.
- Review the tests, consider to add request specs.

## [0.3.0.beta2](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.3.0.beta2) -

### Changed

- chore: cache pagination total ([#39](https://github.com/wallaby-rails/wallaby-active_record/pull/39))

## [0.3.0.beta1](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.3.0.beta1) - 2023-09-22

### Changed

- fix: documentation for search syntax related to end-with ([#35](https://github.com/wallaby-rails/wallaby-active_record/pull/35))
- fix: broken page when no primary key ([#34](https://github.com/wallaby-rails/wallaby-active_record/pull/34))
- chore: Update rubocop to run only on the changed files ([#33](https://github.com/wallaby-rails/wallaby-active_record/pull/33))
- chore: documentation by docsify ([#31](https://github.com/wallaby-rails/wallaby-active_record/pull/31))
- chore: update test matrix with what Ruby and Rails support ([#30](https://github.com/wallaby-rails/wallaby-active_record/pull/30))
- feat: allow nulls option and preload associations for index query ([#29](https://github.com/wallaby-rails/wallaby-active_record/pull/29))
- chore: hide foreign and polymorphic keys instead of removing them from field_names ([#28](https://github.com/wallaby-rails/wallaby-active_record/pull/28))
- chore: fix new rubocop issues e.g. Layout/IndentationWidth ([#27](https://github.com/wallaby-rails/wallaby-active_record/pull/27))
- chore: revert the env step and fix the branch name in gemfiles ([#26](https://github.com/wallaby-rails/wallaby-active_record/pull/26))
- chore: add step to echo env ([#25](https://github.com/wallaby-rails/wallaby-active_record/pull/25))
- chore: add GITHUB_REF_NAME as well ([#24](https://github.com/wallaby-rails/wallaby-active_record/pull/24))
- chore: use GITHUB_BASE_REF for gemfiles ([#23](https://github.com/wallaby-rails/wallaby-active_record/pull/23))
- chore: use Github Actions instead ([#22](https://github.com/wallaby-rails/wallaby-active_record/pull/22))
- chore: use Wallaby.controller_configuration instead of Wallaby.configuration ([#21](https://github.com/wallaby-rails/wallaby-active_record/pull/21))
- chore: use Wallaby.controller_configuration instead of Wallaby.configuration ([#21](https://github.com/wallaby-rails/wallaby-active_record/pull/21))

### Added

- feat: support NULLS FIRST | LAST ([#32](https://github.com/wallaby-rails/wallaby-active_record/pull/32))

## [0.2.7](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.2.7) - 2022-02-03

### Changed

- chore: use wallaby-core 0.2.3

## [0.2.6](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.2.6) - 2020-04-19

### Changed

- chore: filter out the classes that have invalid class name, e.g. primary::SchemaMigration ([#19](https://github.com/wallaby-rails/wallaby-active_record/pull/19))
- fix: make sure index/show/form fields returns empty hash when database or table doesn't exist ([#18](https://github.com/wallaby-rails/wallaby-active_record/pull/18))

## [0.2.5](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.2.5) - 2020-04-12

### Changed

- chore: take out Logger and use the one from wallaby-core and update the documents ([#16](https://github.com/wallaby-rails/wallaby-active_record/pull/16))
- feat: change to use native ActiveRecord pagination ([#15](https://github.com/wallaby-rails/wallaby-active_record/pull/15))
- chore: update the specs for authorizer changes ([#14](https://github.com/wallaby-rails/wallaby-active_record/pull/14))

## [0.2.4](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.2.4) - 2020-03-22

### Changed

- feat: custom logger to provide better information output to the Rails' log ([#11](https://github.com/wallaby-rails/wallaby-active_record/pull/11))
- fix: use and to join the conditions for not in ([#10](https://github.com/wallaby-rails/wallaby-active_record/pull/10))

## [0.2.2](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.2.2) - 2020-03-19

### Changed

- fix: nil must be handled differently in a sequence sub query ([#9](https://github.com/wallaby-rails/wallaby-active_record/pull/9))
- fix: check database and table's existence before getting the metadata. ([#8](https://github.com/wallaby-rails/wallaby-active_record/pull/8))
- chore: use simplecov 0.17 for codeclimate report ([#7](https://github.com/wallaby-rails/wallaby-active_record/pull/7))

## [0.2.1](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.2.1) - 2020-02-17

### Changed

- fix: convert per_page param to integer for will_paginate ([#6](https://github.com/wallaby-rails/wallaby-active_record/pull/6))

## [0.2.0](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.2.0) - 2020-02-16

### Changed

- chore: remove kaminari from dependency but make it work with both kaminari and will_paginate ([#5](https://github.com/wallaby-rails/wallaby-active_record/pull/5))
- feat: improve querier to allow null, empty string and string matching query ([#4](https://github.com/wallaby-rails/wallaby-active_record/pull/4))

## [0.1.0](https://github.com/wallaby-rails/wallaby-active_record/releases/tag/0.1.0) - 2019-10-01

### Added
Extracted code from Wallaby
