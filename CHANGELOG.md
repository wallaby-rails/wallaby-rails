# WIP Wish list

- Add lint check
- Support for Single Table Inheritance (STI)
- Improve colon search (maybe..)
- Data audit (use papertrail) (maybe..)
- Data export (maybe..)
- Batch data action (maybe..)

# Known issues

N/A

# History:

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

## v4.0.1

1. Fixed an issue for loading irregular classes/files under /app folder
2. Ensure to support mysql and sqlite

## v4.0.0

1. Used model class to dispatch requests to controllers
2. Fixed sorting / remove link for custom fields on index page table headers
3. Added types email and color for index/show/form
4. Ensure all hashes used for fields is instance of HashWithIndifferentAccess

## v4.0.0.rc

1. Used Rails cache for caching subclasses
2. Added support for CanCanCan (authorization)
3. Added support for all Postgres types
4. Added support for sorting
5. Added model servicer to take away the responsibilities (collection/find/initialize) for model decorator and extract all actions for resource controller

## v0.0.6

1. Resolved Autoload issue

## v0.0.5

1. Resolved Autoload (failed)
2. Reduced view path set and speeded up page render
3. Broke down resources_helper into styling_helper/links_helper/form_helper
4. Added partial for type inet

## v0.0.4

1. Basic search for collection
2. Kaminari pagination for collection.
3. Basic flash message.
4. Authentication. It can be configured.
5. Basic form errors

## v0.0.3

1. Refactored model decorator and use `fields` as base information for all fields
2. Included association fields and exclude those foreign keys for these associations
3. Created general templates for show/form

## v0.0.2

1. Moved and refactored core methods from resources controller to core controller.
2. Moved prefix builder to core controller.
2. Created general templates for resources index action.
3. Created a wrapper to speed up view rendering by caching the `find_template` result.
