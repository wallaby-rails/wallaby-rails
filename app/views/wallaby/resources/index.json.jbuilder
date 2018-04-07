# custom json to serve the frontend javascript auto_select
json.array! decorate(collection) do |decorated|
  json.id decorated.primary_key_value
  json.label decorated.to_label

  fields = (params[:fields] || '').split(/\s*,\s*/).flatten
  fields = fields & decorated.index_field_names.map(&:to_s)
  json.(decorated, *fields) if fields.present?
end
