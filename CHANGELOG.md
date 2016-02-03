# v0.0.6

1. Resolved Autoload issue

# WIP Feature list

- Abstract all resources controller action
- Page rendering performance improvement
- Sorting for collection (maybe)
- Authorization (use cancan/cancancan)
- Data Audit (use papertrail)

# Knonw issues

- Missing assets for kaminari and bootstrap-sass if kaminari and bootstrap-sass are not in the `Gemfile`

# History:

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
2. Created general tempaltes for resources index action.
3. Created a wrapper to speed up view rendering by caching the `find_template` result.
