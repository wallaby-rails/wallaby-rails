# frozen_string_literal: true

json.error do
  json.code @code

  if @code < 500 && @exception.present?
    json.message @exception.message
  else
    json.message wt("json_errors.#{@symbol}")
  end
end
