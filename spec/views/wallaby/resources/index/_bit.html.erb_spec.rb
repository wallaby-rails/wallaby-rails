require 'rails_helper'

field_name = 'bit'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: '1',
    code_value: true,
    skip_general: true
end
