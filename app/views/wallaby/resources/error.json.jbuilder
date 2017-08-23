decorated = decorate resoruce
json.error do
  json.code 400
  json.message t('json_errors.bad_request')
  json.errors decorated.errors
end
