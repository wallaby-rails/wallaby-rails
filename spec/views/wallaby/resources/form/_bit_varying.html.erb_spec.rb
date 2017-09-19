require 'rails_helper'

field_name = 'bit_varying'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: '11010100',
    type: 'number'
end
