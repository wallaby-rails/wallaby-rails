# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## TODOs

- change to all lables to be prefixed with controller/name

## [0.3.0-beta2]

### Added

- Support readonly option ([#86](https://github.com/wallaby-rails/wallaby-core/pull/86))
- Support custom mapping_actions ([#73](https://github.com/wallaby-rails/wallaby-core/pull/73))
- feat: support `nulls first`/`nulls last` for `params[:sort]`  ([#71](https://github.com/wallaby-rails/wallaby-core/pull/71))
- feat: support to hide a field by setting `field_metadata[:hidden]` ([#68](https://github.com/wallaby-rails/wallaby-core/pull/68))
- feat: allow dynamic x_fields/x_field_names/x_metadata_of/x_type_of/x_label_of ([#54](https://github.com/wallaby-rails/wallaby-core/pull/54))
- feat: add generators for controller/decorator/servicer/authorizer/paginator ([#37](https://github.com/wallaby-rails/wallaby-core/pull/37))
- feat: add wallaby:engine:install generator ([#36](https://github.com/wallaby-rails/wallaby-core/pull/36))
- feat: be able to add custom routes using wallaby_mount ([#29](https://github.com/wallaby-rails/wallaby-core/pull/29))

### Changed

- fix: object is not decorated by Rails' convert_to_model change ([#81](https://github.com/wallaby-rails/wallaby-core/pull/81))
- Fix eager_load_paths issue for Rails 7.1.2 and above ([#78](https://github.com/wallaby-rails/wallaby-core/pull/78))
- Fix issue related to empty primary key ([#73](https://github.com/wallaby-rails/wallaby-core/pull/73))
- Improve the error messages in ResourceRouter ([#72](https://github.com/wallaby-rails/wallaby-core/pull/72))
- chore: refactor sorting related builders ([#69](https://github.com/wallaby-rails/wallaby-core/pull/69))
- fix: URL engine by moving recall params to the last place ([#67](https://github.com/wallaby-rails/wallaby-core/pull/67))
- chore: change to use Array.wrap ([#65](https://github.com/wallaby-rails/wallaby-core/pull/65))
- chore: improve url handling for different cases ([#63](https://github.com/wallaby-rails/wallaby-core/pull/63))
- chore: fix clone for HashWithIndifferentAccess ([#58](https://github.com/wallaby-rails/wallaby-core/pull/58))
- chore: refactor controller actions and add more helper methods related params methods ([#57](https://github.com/wallaby-rails/wallaby-core/pull/57))
- chore: support clone for different objects ([#56](https://github.com/wallaby-rails/wallaby-core/pull/56), [#55](https://github.com/wallaby-rails/wallaby-core/pull/55))
- chore: add `.options_from` for authorizers ([#53](https://github.com/wallaby-rails/wallaby-core/pull/53))
- chore: use `wallaby_controller` for easy access to controller level configuration ([#52](https://github.com/wallaby-rails/wallaby-core/pull/52))
- chore: replace mappings with finders ([#51](https://github.com/wallaby-rails/wallaby-core/pull/51))
- chore: replace mappings with naming convention for ResourcesRouter ([#50](https://github.com/wallaby-rails/wallaby-core/pull/50))
- chore: improve engine name finder ([#48](https://github.com/wallaby-rails/wallaby-core/pull/48))
- chore: misc updates ([#47](https://github.com/wallaby-rails/wallaby-core/pull/47))
- chore: refactor generators and move common codes into application generator ([#46](https://github.com/wallaby-rails/wallaby-core/pull/46))
- chore: extract url helpers into urlable ([#45](https://github.com/wallaby-rails/wallaby-core/pull/45))
- chore: cleanup document for deprecated methods ([#44](https://github.com/wallaby-rails/wallaby-core/pull/44))
- chore: deprecate type_render and remove Wallaby::TypeRenderer ([#43](https://github.com/wallaby-rails/wallaby-core/pull/43))
- chore: update url helpers and override form_for ([#42](https://github.com/wallaby-rails/wallaby-core/pull/42))
- chore: deprecate `Wallaby::ModuleUtils.try_to` ([#41](https://github.com/wallaby-rails/wallaby-core/pull/41))
- chore: deprecate `Wallaby::Baseable.namespace` attribute ([#40](https://github.com/wallaby-rails/wallaby-core/pull/40))
- chore: suppress preload until it's Wallaby related request ([#39](https://github.com/wallaby-rails/wallaby-core/pull/39))
- chore: be able to include Wallaby::ResourcesConcern to get the same feature as Wallaby::ResourcesController ([#38](https://github.com/wallaby-rails/wallaby-core/pull/38))
- chore: deprecate features config and rename to max_text_length ([#35](https://github.com/wallaby-rails/wallaby-core/pull/35))
- chore: deprecate configuration and move to controller_configuration ([#34](https://github.com/wallaby-rails/wallaby-core/pull/34))
- chore: deprecate security config ([#33](https://github.com/wallaby-rails/wallaby-core/pull/33))
- feat: Deprecator to mark a method deprecated ([#32](https://github.com/wallaby-rails/wallaby-core/pull/32))
- chore: update resource responder ([#31](https://github.com/wallaby-rails/wallaby-core/pull/31))
- chore: be able to fall back to form partial and metadata ([#30](https://github.com/wallaby-rails/wallaby-core/pull/30))


### Removed

- chore: remove gem kaminari from gemfiles ([#64](https://github.com/wallaby-rails/wallaby-core/pull/64))


## [0.2.10](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.2.10) - 2024-01-17

### Changed

- Suppress preloading ([#83](https://github.com/wallaby-rails/wallaby-core/pull/83), [#85](https://github.com/wallaby-rails/wallaby-core/pull/85))

## [0.2.9](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.2.9) - 2023-11-19

### Changed

- Fix for Rails 7.1.2 moving app folders out of eager_load_paths ([#77](https://github.com/wallaby-rails/wallaby-core/pull/77))

## [0.2.8](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.2.8) - 2023-09-23

### Changed

- Update keyword syntax to support Ruby 3.0 ([#74](https://github.com/wallaby-rails/wallaby-core/pull/74))

## [0.2.7](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.2.7) - 2022-05-10

### Changed

- fix: object is not decorated by Rails' convert_to_model change ([#59](https://github.com/wallaby-rails/wallaby-core/pull/59))

## [0.2.6](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.2.6) - 2022-03-13

### Changed

- chore: fix the clone for HashWithIndifferentAccess

## [0.2.5](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.2.5) - 2022-02-28

### Changed

- fix: fix issue while cloning the hash with default

## [0.2.4](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.2.4) - 2022-02-06

### Changed

- chore: implement custom clone since Marshal is no longer working for Rails

## [0.2.3](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.2.3) - 2022-02-02

### Changed

- chore: use deep_dup as Rails 7.0.1 introduced broken change

## [0.2.2](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.2.2) - 2020-04-11

### Added

- feat: add options to authorizer and its providers ([#25](https://github.com/wallaby-rails/wallaby-core/pull/25))

### Changed

- chore: move related spec from wallaby to here ([#27](https://github.com/wallaby-rails/wallaby-core/pull/27))
- chore: refactor guess_associated_class_of to allow suffix and attr_name ([#26](https://github.com/wallaby-rails/wallaby-core/pull/26))
- chore: refactor model authorizer ([#24](https://github.com/wallaby-rails/wallaby-core/pull/24))
- chore: helper_method wallaby_user and update ensure_type_is_present ([#23](https://github.com/wallaby-rails/wallaby-core/pull/23))
- chore: use ClassHash to prevent Class constants from being cached in global method e.g. Wallaby::Map.mode_map ([#22](https://github.com/wallaby-rails/wallaby-core/pull/22))
- chore: use require_dependency instead of constantize ([#21](https://github.com/wallaby-rails/wallaby-core/pull/21))
- feat: user wallaby_user and authenticate_wallaby_user to avoid conflicts with current_user ([#20](https://github.com/wallaby-rails/wallaby-core/pull/20))

## [0.2.1](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.2.1) - 2020-03-24

### Added

- feat: better logger to output more information including the caller ([#18](https://github.com/wallaby-rails/wallaby-core/pull/18))
- chore: rename Utils.t to Locale.t ([#17](https://github.com/wallaby-rails/wallaby-core/pull/17))
- feat: put all translation under wallaby namespace and use custom translator method ([#16](https://github.com/wallaby-rails/wallaby-core/pull/16))

### Changed

- chore: ensure layout is set and not impacted by ApplicationController's layout ([#15](https://github.com/wallaby-rails/wallaby-core/pull/15))
- chore: only define Ability when CanCan exists ([#14](https://github.com/wallaby-rails/wallaby-core/pull/14))
- chore: extract everything into a concern for ResourcesController ([#13](https://github.com/wallaby-rails/wallaby-core/pull/13))
- chore: use simplecov 0.17 for codeclimate report ([#12](https://github.com/wallaby-rails/wallaby-core/pull/12))

## [0.2.0](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.2.0) - 2020-02-14

### Changed

- chore: remove number rule from Wallaby::Parser ([#11](https://github.com/wallaby-rails/wallaby-core/pull/11))
- feat: handle basic data type for colon query ([#9](https://github.com/wallaby-rails/wallaby-core/pull/9))
- chore: use `wallaby-view` gem ([#8](https://github.com/wallaby-rails/wallaby-core/pull/8))
- fix: Wallaby::PreloadUtils#eager_load_paths for Pathname objects ([#7](https://github.com/wallaby-rails/wallaby-core/pull/7))

## [0.1.2](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.1.2) - 2019-12-17

### Changed

- fix: make cell utils to work with path that starts with /app/vendor ([#6](https://github.com/wallaby-rails/wallaby-core/pull/6))

## [0.1.1](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.1.1) - 2019-12-11

### Changed

- fix: same options being used for multiple index_link ([#5](https://github.com/wallaby-rails/wallaby-core/pull/5))
- chore: test_files and require_paths shouldn't be included in the gemspec ([#4](https://github.com/wallaby-rails/wallaby-core/pull/4))

## [0.1.0](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.1.0) - 2019-12-05

### Added

- feat: support Rails 6 ([#3](https://github.com/wallaby-rails/wallaby-core/pull/3))
