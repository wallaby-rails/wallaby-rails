require 'rails_helper'

field_name = 'string'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: '<b>1234567890123</b>',
    max_length: 20,
    max_value: "<b>this's a text for more than 20 characters</b>",
    max_title: true
end
