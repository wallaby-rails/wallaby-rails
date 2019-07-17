# Features

- It allows developer to customize things in different aspects (e.g. Decorator/Controller/Servicer/Authorizer/Paginator/View/Cell)
- In a decorator, field type can be customized and filters can be set for index page.
- It applies Devise authentication and allows custom authentication to be made.
- It applies CanCanCan/Pundit authorization across the admin section and allows custom authorization to be in place.
- It allows user to do advanced search using colon syntax, e.g. `ordered_at:>2017-07-01 name_start_with:^tian`
- It handles Single Table Inheritance (STI) and all kinds of ActiveRecord associations, including polymorphism.
- Besides ActiveRecord, it supports HER and any other ORMs.
- Be able to use themes.
- Data can be exported to CSV.
- It provides interactive UI for editing values (e.g. Text editor for text types, syntax highlight for JSON/XML types, datepicker for date/time types, auto-complete for association types).

# Requirements / Support

- Ruby >= 2.0.0
- Rails >= 4.2.0
- ActiveRecord >= 4.2.0
- Devise
- CanCanCan/Pundit
- Bootstrap 4 (or Bootstrap 3 for versions below 5.2.0)
- Turbolinks (disabled by default)
