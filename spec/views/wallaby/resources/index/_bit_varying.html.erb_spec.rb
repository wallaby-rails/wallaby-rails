require 'rails_helper'

field_name = 'bit_varying'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: '1101',
    code_value: true,
    skip_general: true
end
