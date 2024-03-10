# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [TODO]

Continously to work on the rendering performance.

## [0.1.7](https://github.com/wallaby-rails/wallaby-view/releases/tag/0.1.7) - 2021-01-27

### Changed

- Allow Rails 7 ([#12](https://github.com/wallaby-rails/wallaby-view/pull/12))
- chore: change to use github actions instead of travis ([#13](https://github.com/wallaby-rails/wallaby-view/pull/13))

## [0.1.6](https://github.com/wallaby-rails/wallaby-view/releases/tag/0.1.6) - 2020-12-20

### Changed

- chore: remove PartialRenderer and support Rails 6.1 ([#11](https://github.com/wallaby-rails/wallaby-view/pull/11))

## [0.1.5](https://github.com/wallaby-rails/wallaby-view/releases/tag/0.1.5) - 2020-04-13

### Changed

- chore: refactor class_methods to ClassMethods ([#9](https://github.com/wallaby-rails/wallaby-view/pull/9))

## [0.1.4](https://github.com/wallaby-rails/wallaby-view/releases/tag/0.1.4) - 2020-02-28

### Removed

- feat: allow mapped action to be inserted instead of replacing existing action ([#8](https://github.com/wallaby-rails/wallaby-view/pull/8))
- chore: use simplecov 0.17 for codeclimate report ([#7](https://github.com/wallaby-rails/wallaby-view/pull/7))

## [0.1.3](https://github.com/wallaby-rails/wallaby-view/releases/tag/0.1.3) - 2020-02-16

### Removed

- chore: remove View.try_to method and use Rails' try method ([#6](https://github.com/wallaby-rails/wallaby-view/pull/6))

## [0.1.2](https://github.com/wallaby-rails/wallaby-view/releases/tag/0.1.2) - 2020-02-14

### Removed

- chore: remove activemodel gem dependency ([#5](https://github.com/wallaby-rails/wallaby-view/pull/5))

## [0.1.1](https://github.com/wallaby-rails/wallaby-view/releases/tag/0.1.1) - 2020-02-08

### Changed

- chore: be able to reset theme_name to false/nil ([#4](https://github.com/wallaby-rails/wallaby-view/pull/4))

## [0.1.0](https://github.com/wallaby-rails/wallaby-view/releases/tag/0.1.0) - 2020-02-07

First version of `Wallaby::View` extracted from `Wallaby` gem:

### Added

- Method `_prefixes` can be easily extended using a block passing to `super`.

### Changed

- Allow searching template/partial using theme name and action name.

### Removed

- Removed Cell related function (since Cell rendering is no faster than general template/partial).
