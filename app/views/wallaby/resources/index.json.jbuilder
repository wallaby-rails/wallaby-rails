# custom json to serve the frontend javascript auto_select
json.array! decorate(collection) do |decorated|
  json.id decorated.primary_key_value
  json.label decorated.to_label

  index_field_names = decorated.index_field_names.map(&:to_s)
  fields = (params[:fields] || index_field_names).split(/\s*,\s*/).flatten
  fields &= index_field_names
  json.call(decorated, *fields) if fields.present?
end
