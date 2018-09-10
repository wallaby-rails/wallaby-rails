# custom json to serve the frontend javascript auto_select feature
decorated_collection = decorate(collection)
json_fields = json_fields_of decorated_collection
json.array! decorated_collection do |decorated|
  json.id decorated.primary_key_value
  json.label decorated.to_label

  json.call decorated, *json_fields
end
