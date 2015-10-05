# History:

# WIP Feature list
- Refactor resource and model decorator again
- Association fields for active model
- General templates for show and form actions
- Authentication (use device)
- Pagination for collection
- Search for collection

## v0.0.2
1. Moved and refactored core methods from resources controller to core controller.
2. Moved prefix builder to core controller.
2. Created general tempaltes for resources index action.
3. Created a wrapper to speed up view rendering by caching the `find_template` result.