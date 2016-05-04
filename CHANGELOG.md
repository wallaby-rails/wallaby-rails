# v4.0.1

1. Fixed an issue for loading irregular classes/files under /app folder
2. Ensure to support mysql and sqlite

# WIP Wish list

- Add lint check
- Change to use a mode so that multiple mode (active_record/mongoid/etc.) can be used at the same time
- Support for Single Table Inheritance (STI)
- Improve colon search (maybe..)
- Data audit (use papertrail) (maybe..)
- Data export (maybe..)
- Batch data action (maybe..)

# Known issues

N/A

# History:

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
