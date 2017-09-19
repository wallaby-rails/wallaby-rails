require 'rails_helper'

field_name = 'mediumblob'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: '001111000001',
    type: 'file',
    model_class: AllMysqlType,
    input_selector: 'input.hidden',
    skip_value_check: true
end
