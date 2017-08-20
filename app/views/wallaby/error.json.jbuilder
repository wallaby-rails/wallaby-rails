json.error do
  json.code @code
  if @code < 500 && @exception.present?
    json.message @exception.message
  else
    json.message I18n.t("json_errors.#{@symbol}")
  end
end
