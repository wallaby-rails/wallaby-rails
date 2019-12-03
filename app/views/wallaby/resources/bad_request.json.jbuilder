# frozen_string_literal: true

# returned error object if frontend needs it
decorated = decorate resource
json.error do
  json.code 400
  json.message t('json_errors.bad_request')
  json.errors decorated.errors
end
