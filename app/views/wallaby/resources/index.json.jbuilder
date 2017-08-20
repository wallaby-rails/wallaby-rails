json.array! decorate(collection) do |decorated|
  json.id decorated.primary_key_value
  json.label decorated.to_label
end
