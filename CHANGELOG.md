# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## TODOs

- Make Wallaby::ResourcesConcern with with general controllers
- Localization support: to be able to use localization for all the model labels (maybe a new gem)
- Move generator to wallaby-core
- Move documentation to wallaby-core

- documentation for interface
- documentation for localization
- Data audit (use papertrail) (maybe..)
- Batch data action (maybe..)

## [6.1.2](https://github.com/wallaby-rails/wallaby-core/releases/tag/6.1.2) - 2020-04-12

- chore: use wallaby_user instead, will take out current_user in the future ([#185](https://github.com/wallaby-rails/wallaby/pull/185))

## [6.1.1](https://github.com/wallaby-rails/wallaby-core/releases/tag/6.1.1) - 2020-03-24

- chore: use wt for I18n ([#184](https://github.com/wallaby-rails/wallaby/pull/184))
- chore: use simplecov 0.17 for codeclimate report ([#163](https://github.com/wallaby-rails/wallaby/pull/163))

## [6.1.0](https://github.com/wallaby-rails/wallaby-core/releases/tag/6.1.0) - 2020-02-19

- chore: upgrade to use latest wallaby-* gems and remove Cell ([#162](https://github.com/wallaby-rails/wallaby/pull/162))

## [6.0.2](https://github.com/wallaby-rails/wallaby-core/releases/tag/6.0.2)

- chore(css): get rid of bootstrap deprecation warning ([#161](https://github.com/wallaby-rails/wallaby/pull/161))
- fix(js): remove the warning of moment by format the date string properly ([#160](https://github.com/wallaby-rails/wallaby/pull/160))

## [6.0.1](https://github.com/wallaby-rails/wallaby-core/releases/tag/6.0.1)

- fix(gemspec): include vendor folder ([#159](https://github.com/wallaby-rails/wallaby/pull/159))

## [6.0.0](https://github.com/wallaby-rails/wallaby-core/releases/tag/6.0.0)

- feat: Rails 6 support ([#158](https://github.com/wallaby-rails/wallaby/pull/158))
- chore: extract files to separate gems (wallaby-core/wallaby-active_record/wallaby-her) ([#156](https://github.com/wallaby-rails/wallaby/pull/156))
- [Chore] Document update for 5.2 ([#155](https://github.com/wallaby-rails/wallaby/pull/155))
- [Feature] Make sure Wallaby still works without specifying resources_name in routes ([#154](https://github.com/wallaby-rails/wallaby/pull/154))
- [Feature] Namespace ([#153](https://github.com/wallaby-rails/wallaby/pull/153))
- [Chore] Change authorizer's initialize to take away the dependence of context ([#152](https://github.com/wallaby-rails/wallaby/pull/152))
- [Feature] wallaby:install generator ([#151](https://github.com/wallaby-rails/wallaby/pull/151))
- [Feature] Remove usage of `index_params` ([#150](https://github.com/wallaby-rails/wallaby/pull/150))
- [Feature] Router helper and support singular resourceful route ([#149](https://github.com/wallaby-rails/wallaby/pull/149))
- [Feature] Custom mode ([#148](https://github.com/wallaby-rails/wallaby/pull/148))
- [Chore] Theme specs ([#147](https://github.com/wallaby-rails/wallaby/pull/147))
- [Chore] Remove abstract classes ([#146](https://github.com/wallaby-rails/wallaby/pull/146))
- [Feature] options for controller and move servicer's mass assignment to create/update ([#145](https://github.com/wallaby-rails/wallaby/pull/145))
- [Feature] Add ActiveStorage partial and `at` cell helper ([#144](https://github.com/wallaby-rails/wallaby/pull/144))
- [Chore] Defult to exclude model ActiveRecord::SchemaMigration ([#143](https://github.com/wallaby-rails/wallaby/pull/143))
- [Feature] Upgrade to bootstrap4 and font-awesome ([#142](https://github.com/wallaby-rails/wallaby/pull/142))
- [Chore] Update dropdown html syntax and remove Font Awesome ([#141](https://github.com/wallaby-rails/wallaby/pull/141))
- [Chore] Update docs and make sure corresponding helper methods exists ([#140](https://github.com/wallaby-rails/wallaby/pull/140))
- [Feature] Add support for single column sorting ([#139](https://github.com/wallaby-rails/wallaby/pull/139))
- [Feature] Move error page to proper place so that it can be customized ([#138](https://github.com/wallaby-rails/wallaby/pull/138))
- [Feature] Base class and JSON API responder ([#137](https://github.com/wallaby-rails/wallaby/pull/137))
- [Chore] Reduce code duplication ([#136](https://github.com/wallaby-rails/wallaby/pull/136))
- [Chore] Refactor utils ([#135](https://github.com/wallaby-rails/wallaby/pull/135))
- [Feature] Support for cell to improve performance ([#134](https://github.com/wallaby-rails/wallaby/pull/134))
- [Chore] HER and auto select ([#133](https://github.com/wallaby-rails/wallaby/pull/133))
- [Support] Rails 4.2 and specs ([#131](https://github.com/wallaby-rails/wallaby/pull/131))
- [Feature] Permitted parameters for has_many-through associations ([#129](https://github.com/wallaby-rails/wallaby/pull/129))
- [Fix] Float form partial options ([#128](https://github.com/wallaby-rails/wallaby/pull/128))
- [Feature] Support Pundit 2.0 ([#127](https://github.com/wallaby-rails/wallaby/pull/127))
- [Feature] Sort disabled ([#126](https://github.com/wallaby-rails/wallaby/pull/126))
- [Feature] Extract frontend partial ([#125](https://github.com/wallaby-rails/wallaby/pull/125))
- [Chore] Resolve conflicts ([#124](https://github.com/wallaby-rails/wallaby/pull/124))
- [Chore] Remove resources helper methods and update documentation ([#123](https://github.com/wallaby-rails/wallaby/pull/123))
- [Feature] Authorizable and resourcable ([#122](https://github.com/wallaby-rails/wallaby/pull/122))
- [Feature] Resourcable and paginatable concerns ([#120](https://github.com/wallaby-rails/wallaby/pull/120))
- [Feature] Servicable ([#119](https://github.com/wallaby-rails/wallaby/pull/119))
- [Feature] Adding link type for links in show and index partials ([#118](https://github.com/wallaby-rails/wallaby/pull/118))
- [Feature] Decoratable ([#117](https://github.com/wallaby-rails/wallaby/pull/117))
- [Chore] Pagination check for ActiveRecord collection ([#116](https://github.com/wallaby-rails/wallaby/pull/116))
- [Chore] Support FontAwesome 5 ([#115](https://github.com/wallaby-rails/wallaby/pull/115))
- [Feature] Remove errors layout ([#114](https://github.com/wallaby-rails/wallaby/pull/114))
- [Feature] Themeable ([#113](https://github.com/wallaby-rails/wallaby/pull/113))
- [Chore] Update engine url/links helper methods ([#112](https://github.com/wallaby-rails/wallaby/pull/112))
- [Chore] Create helper methods to use in both controllers and views ([#111](https://github.com/wallaby-rails/wallaby/pull/111))
- [Feature] Her adapter and pundit ([#98](https://github.com/wallaby-rails/wallaby/pull/98))

## [5.1.8](https://github.com/wallaby-rails/wallaby-core/releases/tag/5.1.8)

1. [Fix] Keep filter param for search ([#102](https://github.com/wallaby-rails/wallaby/pull/102))
2. [Feature] Allow custom csv partials ([#103](https://github.com/wallaby-rails/wallaby/pull/103))
3. [Chore] Use mapping configuration for servicer class method `model_class` ([#104](https://github.com/wallaby-rails/wallaby/pull/104))
4. [Feature] Add url_params for index and export link helper methods ([#105](https://github.com/wallaby-rails/wallaby/pull/105))
5. [Security] Remove option `html: true` for bootstrap tooltip to prevent XSS attack ([#108](https://github.com/wallaby-rails/wallaby/pull/108)). Patch for issue ([#107](https://github.com/wallaby-rails/wallaby/pull/107))

## [5.1.7](https://github.com/wallaby-rails/wallaby-core/releases/tag/5.1.7)

1. [Fix] Routes update for configurable `resources_controller` ([#99](https://github.com/wallaby-rails/wallaby/pull/99))
2. [Fix] Update resources router to reflect the resources controller configuration ([#100](https://github.com/wallaby-rails/wallaby/pull/100))

## [5.1.6](https://github.com/wallaby-rails/wallaby-core/releases/tag/5.1.6)

1. [Chore] upgrade to robucop 0.53 standard ([#88](https://github.com/wallaby-rails/wallaby/pull/88))
2. [Feature] Configurable global base controller/decorator/paginator/servicer ([#91](https://github.com/wallaby-rails/wallaby/pull/91))
3. [Feature] Add 'step' to float field (partial view) ([#89](https://github.com/wallaby-rails/wallaby/pull/89))
4. [Chore] Update documentation ([#93](https://github.com/wallaby-rails/wallaby/pull/93))
5. [Feature] Be able to use default base class of controller/decorator/paginator/servicer ([#95](https://github.com/wallaby-rails/wallaby/pull/95))
6. [Feature] Add test helper for controller tests ([#96](https://github.com/wallaby-rails/wallaby/pull/96))

## [5.1.5](https://github.com/wallaby-rails/wallaby-core/releases/tag/5.1.5)

1. [Chore] Simplify 'resources/show/_image.html.erb' ([#80](https://github.com/wallaby-rails/wallaby/pull/80))
2. [Chore] Add more information to the type validation message ([#81](https://github.com/wallaby-rails/wallaby/pull/81))
3. [Feature] Be able to customize hint in form view ([#82](https://github.com/wallaby-rails/wallaby/pull/82))
4. [Fix] Link of Strong Parameters ([#84](https://github.com/wallaby-rails/wallaby/pull/84))
5. [Fix] Restrict font-awesome-sass version to 5 and below ([#85](https://github.com/wallaby-rails/wallaby/pull/85))
6. [Chore] Reload should be triggered in `to_prepare` instead of `ResourcesRouter` ([#86](https://github.com/wallaby-rails/wallaby/pull/86))

## [5.1.4](https://github.com/wallaby-rails/wallaby-core/releases/tag/5.1.4)

1. Chore: Only use resource_params for create and update action ([#73](https://github.com/wallaby-rails/wallaby/pull/73))
2. Chore: Localization for style helpers ([#74](https://github.com/wallaby-rails/wallaby/pull/74))
3. Chore: Refactor class mapper to allow descendents ([#75](https://github.com/wallaby-rails/wallaby/pull/75))
4. Chore: Remove is_origin metadata ([#76](https://github.com/wallaby-rails/wallaby/pull/76))
5. Support: Manual tested under Rails 4.2 ([#77](https://github.com/wallaby-rails/wallaby/pull/77))
6. Feature: Ability to customize logout_path, logout_method, email_method ([#78](https://github.com/wallaby-rails/wallaby/pull/78))


## [5.1.3](https://github.com/wallaby-rails/wallaby-core/releases/tag/5.1.3)

1. Chore: Remove `jquery-turbolinks` gem ([#66](https://github.com/wallaby-rails/wallaby/pull/66))
2. Feature: Add html attribute `title` to the links ([#67](https://github.com/wallaby-rails/wallaby/pull/67))
3. Chore: normalize the partials that user could replace/override ([#69](https://github.com/wallaby-rails/wallaby/pull/69))
4. Fix: Have to make sure that `app/models` are loaded before Rails eager load ([#68](https://github.com/wallaby-rails/wallaby/pull/68))
5. Chore: index_params should not contain `resources`, `utf8` ([#71](https://github.com/wallaby-rails/wallaby/pull/71))

## [5.1.2](https://github.com/wallaby-rails/wallaby-core/releases/tag/5.1.2)

1. Chore: prevent the reference to model decorator from being cached ([#65](https://github.com/wallaby-rails/wallaby/pull/65))

## [5.1.1](https://github.com/wallaby-rails/wallaby-core/releases/tag/5.1.1)

1. Chore: update lookup context wrapper ([#59](https://github.com/wallaby-rails/wallaby/pull/59))
2. Chore: update application.html ([#62](https://github.com/wallaby-rails/wallaby/pull/62))
3. Chore: fix deprecated styling (@extend :before) ([#63](https://github.com/wallaby-rails/wallaby/pull/63))
4. Chore: add manual preload into initializer as well ([#64](https://github.com/wallaby-rails/wallaby/pull/64))

## [5.1.0](https://github.com/wallaby-rails/wallaby-core/releases/tag/5.1.0)

1. Feature: added support for ActiveRecord Single Table Inheritance (STI) ([#27](https://github.com/wallaby-rails/wallaby/pull/27)) and navigation for STI ([#30](https://github.com/wallaby-rails/wallaby/pull/30))
2. Feature: added filters metadata for provide quick access for predefined query ([#34](https://github.com/wallaby-rails/wallaby/pull/34))
3. Feature: added responder to handle different request formats ([#35](https://github.com/wallaby-rails/wallaby/pull/35))
4. Feature: export function ([#37](https://github.com/wallaby-rails/wallaby/pull/37))
5. Feature: UI Re-design, and mobile first ([#39](https://github.com/wallaby-rails/wallaby/pull/39))
6. Feature: used turbolinks to boost page load and used font-awesome to replace glyphicon ([#29](https://github.com/wallaby-rails/wallaby/pull/29))
7. Enhancement: colon search is enhanced using parselet ([#28](https://github.com/wallaby-rails/wallaby/pull/28))
8. Enhancement: typeahead for form partials (has\_many/has\_and\_belongs\_to\_many/belongs\_to) ([#40](https://github.com/wallaby-rails/wallaby/pull/40))
9. Chore: source code improvement ([#26](https://github.com/wallaby-rails/wallaby/pull/26))
10. Chore: remove the dependency of devise ([#31](https://github.com/wallaby-rails/wallaby/pull/31))
11. Chore: refactor map service ([#25](https://github.com/wallaby-rails/wallaby/pull/25))
12. Chore: refactor to extract/move the code into abstract classes ([#33](https://github.com/wallaby-rails/wallaby/pull/33))
13. Chore: added rubocop to enforce high coding standard ([#32](https://github.com/wallaby-rails/wallaby/pull/32), [#38](https://github.com/wallaby-rails/wallaby/pull/38))
14. Chore: refactor service object to keep authorizer on initialization ([#36](https://github.com/wallaby-rails/wallaby/pull/36))
15. Chore: refactor imodal method ([#41](https://github.com/wallaby-rails/wallaby/pull/41))
16. Bugfix: fix how object is clone ([#23](https://github.com/wallaby-rails/wallaby/pull/23))
17. Feature: Add partials for type box/circle/line/lseg/path/polygon that are newly supported in Rails 5.0.* ([#42](https://github.com/wallaby-rails/wallaby/pull/42))
18. Feature: Add dropdown partial ([#46](https://github.com/wallaby-rails/wallaby/pull/46))
19. Feature: Add file partial ([#47](https://github.com/wallaby-rails/wallaby/pull/47))
20. Feature: Add markdown partial ([#48](https://github.com/wallaby-rails/wallaby/pull/48))
21. Feature: Add image partial ([#49](https://github.com/wallaby-rails/wallaby/pull/49))
22. Feature: Authorization check for relationship partials ([#50](https://github.com/wallaby-rails/wallaby/pull/50))
23. Feature: Configurable maxlength for partials ([#52](https://github.com/wallaby-rails/wallaby/pull/52))
24. Feature: Refactor resource new and find and expose permit method to controller ([#53](https://github.com/wallaby-rails/wallaby/pull/53))
25. Chore: Setup travis to test on rails 5.0/5.1 ([#54](https://github.com/wallaby-rails/wallaby/pull/54))
26. Feature: Add JSON respond for form/show ([#56](https://github.com/wallaby-rails/wallaby/pull/56))
27. Feature: Documentation ([#57](https://github.com/wallaby-rails/wallaby/pull/57))
28. Feature: Make turbolinks optional ([#58](https://github.com/wallaby-rails/wallaby/pull/58))

## [5.0.1](https://github.com/wallaby-rails/wallaby-core/releases/tag/5.0.1)

1. Bugfix: database migrations fail when decorator invokes form_fields and table does not exist ([#4](https://github.com/wallaby-rails/wallaby/pull/4))
2. Feature: Add partial to support password field ([#9](https://github.com/wallaby-rails/wallaby/pull/9))
3. Bugfix: Using the right metadata for index/show/form partials respectively ([#12](https://github.com/wallaby-rails/wallaby/pull/12))

## [5.0.0](https://github.com/wallaby-rails/wallaby-core/releases/tag/5.0.0)

1. Feature: Support for Rails 5

## [4.1.6](https://github.com/wallaby-rails/wallaby-core/releases/tag/4.1.6)

1. Bugfix: database migrations fail when decorator invokes form_fields and table does not exist ([#4](https://github.com/wallaby-rails/wallaby/pull/4))
2. Feature: Add partial to support password field ([#9](https://github.com/wallaby-rails/wallaby/pull/9))
3. Bugfix: Using the right metadata for index/show/form partials respectively ([#12](https://github.com/wallaby-rails/wallaby/pull/12))

## [4.1.5](https://github.com/wallaby-rails/wallaby-core/releases/tag/4.1.5)

1. Support for Devise 4

## [4.1.4](https://github.com/wallaby-rails/wallaby-core/releases/tag/4.1.4)

1. Bugfix: rescue NameError for Rails reload
2. Bugfix: replace send to public_send

## [4.1.3](https://github.com/wallaby-rails/wallaby-core/releases/tag/4.1.3)

1. Bugfix: when it's belongs-to relationship, it should take foreign_key instead of association_foreign_key as foreign key.

## [4.1.2](https://github.com/wallaby-rails/wallaby-core/releases/tag/4.1.2)

1. Moved all helpers into lib folder and included these helpers explicitly in controllers so that they won't be shared with the main_app
2. Resolved an assets issue for summernote by dynamically converting summernote.css into wallaby/summernote.scss

## [4.1.1](https://github.com/wallaby-rails/wallaby-core/releases/tag/4.1.1)

1. Update view paths precedence from high to low:

    - app/views/WALLABY_ENGINE_MOUNT_PATH/RESOURCES_NAME/*
    - app/views/CUSTOM_CONTROLLER_PATH/*
    - app/view/wallaby/resources/*

    > **WALLABY_ENGINE_MOUNT_PATH** is the path where wallaby engine is mounted to. e.g. admin
    > **RESOURCES_NAME** is the path formed by model class's plural noun. e.g. order/items
    > **CUSTOM_CONTROLLER_PATH** is the controller path of the controller that inherits from *Wallaby::ResourcesController*


2. Bugfix: replace @import with require for summernote to avoid error `invalid byte sequence in UTF-8`
3. Enforce wallaby application controller to use designated layout `wallaby/application` especially when it inherits from main app's application controller.
4. Rescue pagination entry from throwing error when Kaminari is not used.

## [4.1.0](https://github.com/wallaby-rails/wallaby-core/releases/tag/4.1.0)

1. Added concept Mode to allow Wallaby to pick up multiple ORM adaptors apart from ActiveRecord
2. Caching improvements:
- Cached compiled ERB template (not for development)
- Most Rails cache implementation for delete_match takes string instead of regex
- Cached Calculations for finding a subclass
3. Resolve an issue when a file under `/app` folder is not following Rails convention (e.g. class `CSV` in `csv.rb`) or if it is a module declaration under `concerns` folder, it raises load error on booting up Rails server

## [4.0.1](https://github.com/wallaby-rails/wallaby-core/releases/tag/4.0.1)

1. Fixed an issue for loading irregular classes/files under /app folder
2. Ensure to support mysql and sqlite

## [4.0.0](https://github.com/wallaby-rails/wallaby-core/releases/tag/4.0.0)

1. Used model class to dispatch requests to controllers
2. Fixed sorting / remove link for custom fields on index page table headers
3. Added types email and color for index/show/form
4. Ensure all hashes used for fields is instance of ::ActiveSupport::HashWithIndifferentAccess

## [4.0.0.rc](4.0https://github.com/wallaby-rails/wallaby-core/releases/tag/.0.rc)

1. Used Rails cache for caching subclasses
2. Added support for CanCanCan (authorization)
3. Added support for all Postgres types
4. Added support for sorting
5. Added model servicer to take away the responsibilities (collection/find/initialize) for model decorator and extract all actions for resource controller

## [0.0.6](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.0.6)

1. Resolved Autoload issue

## [0.0.5](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.0.5)

1. Resolved Autoload (failed)
2. Reduced view path set and speeded up page render
3. Broke down resources_helper into styling_helper/links_helper/form_helper
4. Added partial for type inet

## [0.0.4](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.0.4)

1. Basic search for collection
2. Kaminari pagination for collection.
3. Basic flash message.
4. Authentication. It can be configured.
5. Basic form errors

## [0.0.3](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.0.3)

1. Refactored model decorator and use `fields` as base information for all fields
2. Included association fields and exclude those foreign keys for these associations
3. Created general templates for show/form

## [0.0.2](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.0.2)

1. Moved and refactored core methods from resources controller to core controller.
2. Moved prefix builder to core controller.
2. Created general templates for resources index action.
3. Created a wrapper to speed up view rendering by caching the `find_template` result.
