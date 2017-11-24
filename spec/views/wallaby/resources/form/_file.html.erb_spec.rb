require 'rails_helper'

field_name = 'blob'
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: '001111000001',
    partial: 'file',
    type: 'file',
    model_class: AllMysqlType,
    input_selector: 'input.hidden',
    skip_value_check: true
end
