# TODOs

- Add dropdown partial
- Setup Travis to test Wallaby under 2.2/2.3/2.4 and rails 5.0/5.1
- Add support for pundit
- Localization support: to be able to use localization for all the model labels
- Add support for image, activestorage/paperclip/carrierwave/dragonfly
- Add lint check for stylesheet
- Data audit (use papertrail) (maybe..)
- Batch data action (maybe..)

# Known issues

N/A

# History:

## 5.1.0

1. Feature: added support for Active Record Single Table Inheritance (STI) ([issue 27](#27)) and navigation for STI ([issue 30](#30))
2. Feature: added filters metadata for provide quick access for predefined query ([issue 34](#34))
3. Feature: added responder to handle different request formats ([issue 35](#35))
5. Feature: export function ([issue 37](#37))
6. Feature: UI Re-design, and mobile first ([issue 39](#39))
7. Feature: used turbolinks to boost page load and used font-awesome to replace glyphicon ([issue 29](#29))
4. Enhancement: colon search is enhanced using parselet ([issue 28](#28))
9. Enhancement: typeahead for form partials (has\_many/has\_and\_belongs\_to\_many/belongs\_to) ([issue 40](#40))
9. Chore: source code improvement ([issue 26](#26))
9. Chore: remove the dependency of devise ([issue 31](#31))
10. Chore: refactor map service ([issue 25](#25))
10. Chore: refactor to extract/move the code into abstract classes ([issue 33](#33))
10. Chore: added rubocop to enforce high coding standard ([issue 32](#32), [issue 38](#38))
11. Chore: refactor service object to keep authorizer on initialization ([issue 36](#36))
12. Chore: refactor imodal method ([issue 41](#41))
14. Bugfix: fix how object is clone ([issue 23](#23))

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
4. Ensure all hashes used for fields is instance of HashWithIndifferentAccess

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
