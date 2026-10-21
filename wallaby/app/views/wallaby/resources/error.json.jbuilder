# frozen_string_literal: true

json.error do
  json.code @code

  if @user_facing_message.present?
    json.message @user_facing_message
  else
    json.message wt("json_errors.#{@symbol}")
  end
end
