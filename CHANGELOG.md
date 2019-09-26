# TODOs

- support rails 6
- Localization support: to be able to use localization for all the model labels
- extract core, active record mode and her mode into their own gems

- documentation for interface
- documentation for localization
- Data audit (use papertrail) (maybe..)
- Batch data action (maybe..)

# Known issues

N/A

# History:

## 5.2.0

- [Feature] Make sure Wallaby still works without specifying resources_name in routes ([issue 154](#154))
- [Feature] Namespace ([issue 153](#153))
- [Chore] Change authorizer's initialize to take away the dependence of context ([issue 152](#152))
- [Feature] wallaby:install generator ([issue 151](#151))
- [Feature] Remove usage of `index_params` ([issue 150](#150))
- [Feature] Router helper and support singular resourceful route ([issue 149](#149))
- [Feature] Custom mode ([issue 148](#148))
- [Chore] Theme specs ([issue 147](#147))
- [Chore] Remove abstract classes ([issue 146](#146))
- [Feature] options for controller and move servicer's mass assignment to create/update ([issue 145](#145))
- [Feature] Add ActiveStorage partial and `at` cell helper ([issue 144](#144))
- [Chore] Defult to exclude model ActiveRecord::SchemaMigration ([issue 143](#143))
- [Feature] Upgrade to bootstrap4 and font-awesome ([issue 142](#142))
- [Chore] Update dropdown html syntax and remove Font Awesome ([issue 141](#141))
- [Chore] Update docs and make sure corresponding helper methods exists ([issue 140](#140))
- [Feature] Add support for single column sorting ([issue 139](#139))
- [Feature] Move error page to proper place so that it can be customized ([issue 138](#138))
- [Feature] Base class and JSON API responder ([issue 137](#137))
- [Chore] Reduce code duplication ([issue 136](#136))
- [Chore] Refactor utils ([issue 135](#135))
- [Feature] Support for cell to improve performance ([issue 134](#134))
- [Chore] HER and auto select ([issue 133](#133))
- [Support] Rails 4.2 and specs ([issue 131](#131))
- [Feature] Permitted parameters for has_many-through associations ([issue 129](#129))
- [Fix] Float form partial options ([issue 128](#128))
- [Feature] Support Pundit 2.0 ([issue 127](#127))
- [Feature] Sort disabled ([issue 126](#126))
- [Feature] Extract frontend partial ([issue 125](#125))
- [Chore] Resolve conflicts ([issue 124](#124))
- [Chore] Remove resources helper methods and update documentation ([issue 123](#123))
- [Feature] Authorizable and resourcable ([issue 122](#122))
- [Feature] Resourcable and paginatable concerns ([issue 120](#120))
- [Feature] Servicable ([issue 119](#119))
- [Feature] Adding link type for links in show and index partials ([issue 118](#118))
- [Feature] Decoratable ([issue 117](#117))
- [Chore] Pagination check for ActiveRecord collection ([issue 116](#116))
- [Chore] Support FontAwesome 5 ([issue 115](#115))
- [Feature] Remove errors layout ([issue 114](#114))
- [Feature] Themeable ([issue 113](#113))
- [Chore] Update engine url/links helper methods ([issue 112](#112))
- [Chore] Create helper methods to use in both controllers and views ([issue 111](#111))
- [Feature] Her adapter and pundit ([issue 98](#98))

## 5.1.8

1. [Fix] Keep filter param for search ([issue 102](#102))
2. [Feature] Allow custom csv partials ([issue 103](#103))
3. [Chore] Use mapping configuration for servicer class method `model_class` ([issue 104](#104))
4. [Feature] Add url_params for index and export link helper methods ([issue 105](#105))
5. [Security] Remove option `html: true` for bootstrap tooltip to prevent XSS attack ([issue 108](#108)). Patch for issue ([issue 107](#107))

## 5.1.7

1. [Fix] Routes update for configurable `resources_controller` ([issue 99](#99))
2. [Fix] Update resources router to reflect the resources controller configuration ([issue 100](#100))

## 5.1.6

1. [Chore] upgrade to robucop 0.53 standard ([issue 88](#88))
2. [Feature] Configurable global base controller/decorator/paginator/servicer ([issue 91](#91))
3. [Feature] Add 'step' to float field (partial view) ([issue 89](#89))
4. [Chore] Update documentation ([issue 93](#93))
5. [Feature] Be able to use default base class of controller/decorator/paginator/servicer ([issue 95](#95))
6. [Feature] Add test helper for controller tests ([issue 96](#96))

## 5.1.5

1. [Chore] Simplify 'resources/show/_image.html.erb' ([issue 80](#80))
2. [Chore] Add more information to the type validation message ([issue 81](#81))
3. [Feature] Be able to customize hint in form view ([issue 82](#82))
4. [Fix] Link of Strong Parameters ([issue 84](#84))
5. [Fix] Restrict font-awesome-sass version to 5 and below ([issue 85](#85))
6. [Chore] Reload should be triggered in `to_prepare` instead of `ResourcesRouter` ([issue 86](#86))

## 5.1.4

1. Chore: Only use resource_params for create and update action ([issue 73](#73))
2. Chore: Localization for style helpers ([issue 74](#74))
3. Chore: Refactor class mapper to allow descendents ([issue 75](#75))
4. Chore: Remove is_origin metadata ([issue 76](#76))
5. Support: Manual tested under Rails 4.2 ([issue 77](#77))
6. Feature: Ability to customize logout_path, logout_method, email_method ([issue 78](#78))


## 5.1.3

1. Chore: Remove `jquery-turbolinks` gem ([issue 66](#66))
2. Feature: Add html attribute `title` to the links ([issue 67](#67))
3. Chore: normalize the partials that user could replace/override ([issue 69](#69))
4. Fix: Have to make sure that `app/models` are loaded before Rails eager load ([issue 68](#68))
5. Chore: index_params should not contain `resources`, `utf8` ([issue 71](#71))

## 5.1.2

1. Chore: prevent the reference to model decorator from being cached ([issue 65](#65))

## 5.1.1

1. Chore: update lookup context wrapper ([issue 59](#59))
2. Chore: update application.html ([issue 62](#62))
3. Chore: fix deprecated styling (@extend :before) ([issue 63](#63))
4. Chore: add manual preload into initializer as well ([issue 64](#64))

## 5.1.0

1. Feature: added support for ActiveRecord Single Table Inheritance (STI) ([issue 27](#27)) and navigation for STI ([issue 30](#30))
2. Feature: added filters metadata for provide quick access for predefined query ([issue 34](#34))
3. Feature: added responder to handle different request formats ([issue 35](#35))
4. Feature: export function ([issue 37](#37))
5. Feature: UI Re-design, and mobile first ([issue 39](#39))
6. Feature: used turbolinks to boost page load and used font-awesome to replace glyphicon ([issue 29](#29))
7. Enhancement: colon search is enhanced using parselet ([issue 28](#28))
8. Enhancement: typeahead for form partials (has\_many/has\_and\_belongs\_to\_many/belongs\_to) ([issue 40](#40))
9. Chore: source code improvement ([issue 26](#26))
10. Chore: remove the dependency of devise ([issue 31](#31))
11. Chore: refactor map service ([issue 25](#25))
12. Chore: refactor to extract/move the code into abstract classes ([issue 33](#33))
13. Chore: added rubocop to enforce high coding standard ([issue 32](#32), [issue 38](#38))
14. Chore: refactor service object to keep authorizer on initialization ([issue 36](#36))
15. Chore: refactor imodal method ([issue 41](#41))
16. Bugfix: fix how object is clone ([issue 23](#23))
17. Feature: Add partials for type box/circle/line/lseg/path/polygon that are newly supported in Rails 5.0.* ([issue 42](#42))
18. Feature: Add dropdown partial ([issue 46](#46))
19. Feature: Add file partial ([issue 47](#47))
20. Feature: Add markdown partial ([issue 48](#48))
21. Feature: Add image partial ([issue 49](#49))
22. Feature: Authorization check for relationship partials ([issue 50](#50))
23. Feature: Configurable maxlength for partials ([issue 52](#52))
24. Feature: Refactor resource new and find and expose permit method to controller ([issue 53](#53))
25. Chore: Setup travis to test on rails 5.0/5.1 ([issue 54](#54))
26. Feature: Add JSON respond for form/show ([issue 56](#56))
27. Feature: Documentation ([issue 57](#57))
28. Feature: Make turbolinks optional ([issue 58](#58))

## 5.0.1

1. Bugfix: database migrations fail when decorator invokes form_fields and table does not exist ([issue 4](#4))
2. Feature: Add partial to support password field ([issue 9](#9))
3. Bugfix: Using the right metadata for index/show/form partials respectively ([issue 12](#12))

## 5.0.0

1. Feature: Support for Rails 5

## 4.1.6

1. Bugfix: database migrations fail when decorator invokes form_fields and table does not exist ([issue 4](#4))
2. Feature: Add partial to support password field ([issue 9](#9))
3. Bugfix: Using the right metadata for index/show/form partials respectively ([issue 12](#12))

## 4.1.5

1. Support for Devise 4

## 4.1.4

1. Bugfix: rescue NameError for Rails reload
2. Bugfix: replace send to public_send

## 4.1.3

1. Bugfix: when it's belongs-to relationship, it should take foreign_key instead of association_foreign_key as foreign key.

## 4.1.2

1. Moved all helpers into lib folder and included these helpers explicitly in controllers so that they won't be shared with the main_app
2. Resolved an assets issue for summernote by dynamically converting summernote.css into wallaby/summernote.scss

## 4.1.1

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

## 4.1.0

1. Added concept Mode to allow Wallaby to pick up multiple ORM adaptors apart from ActiveRecord
2. Caching improvements:
- Cached compiled ERB template (not for development)
- Most Rails cache implementation for delete_match takes string instead of regex
- Cached Calculations for finding a subclass
3. Resolve an issue when a file under `/app` folder is not following Rails convention (e.g. class `CSV` in `csv.rb`) or if it is a module declaration under `concerns` folder, it raises load error on booting up Rails server

## 4.0.1

1. Fixed an issue for loading irregular classes/files under /app folder
2. Ensure to support mysql and sqlite

## 4.0.0

1. Used model class to dispatch requests to controllers
2. Fixed sorting / remove link for custom fields on index page table headers
3. Added types email and color for index/show/form
4. Ensure all hashes used for fields is instance of ::ActiveSupport::HashWithIndifferentAccess

## 4.0.0.rc

1. Used Rails cache for caching subclasses
2. Added support for CanCanCan (authorization)
3. Added support for all Postgres types
4. Added support for sorting
5. Added model servicer to take away the responsibilities (collection/find/initialize) for model decorator and extract all actions for resource controller

## 0.0.6

1. Resolved Autoload issue

## 0.0.5

1. Resolved Autoload (failed)
2. Reduced view path set and speeded up page render
3. Broke down resources_helper into styling_helper/links_helper/form_helper
4. Added partial for type inet

## 0.0.4

1. Basic search for collection
2. Kaminari pagination for collection.
3. Basic flash message.
4. Authentication. It can be configured.
5. Basic form errors

## 0.0.3

1. Refactored model decorator and use `fields` as base information for all fields
2. Included association fields and exclude those foreign keys for these associations
3. Created general templates for show/form

## 0.0.2

1. Moved and refactored core methods from resources controller to core controller.
2. Moved prefix builder to core controller.
2. Created general templates for resources index action.
3. Created a wrapper to speed up view rendering by caching the `find_template` result.
