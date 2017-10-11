require 'rails_helper'

field_name = 'tinytext'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: '<b>1234567890123</b>',
    model_class: AllMysqlType,
    max_length: 20,
    max_value: "<b>this's a text for more than 20 characters</b>",
    modal_value: true
end
