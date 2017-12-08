# returned the changed resource if frontend needs it
decorated = decorate resource
all_field_names =
  [decorated.primary_key].concat(decorated.show_field_names).uniq
json.call(decorated, *all_field_names)
