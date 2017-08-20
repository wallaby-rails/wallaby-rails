decorated = decorate resoruce
json.error do
  json.code 400
  json.message I18n.t('json_errors.bad_request')
  json.errors decorated.errors
end
