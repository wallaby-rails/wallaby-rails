# History:

# WIP Feature list
- Form errors
- Authentication (use device)
- Pagination for collection
- Search for collection

## v0.0.2
1. Moved and refactored core methods from resources controller to core controller.
2. Moved prefix builder to core controller.
2. Created general tempaltes for resources index action.
3. Created a wrapper to speed up view rendering by caching the `find_template` result.

## v0.0.3
1. Refactored model decorator and use `fields` as base information for all fields
2. Included association fields and exclude those foreign keys for these associations
3. Created general templates for show/form
