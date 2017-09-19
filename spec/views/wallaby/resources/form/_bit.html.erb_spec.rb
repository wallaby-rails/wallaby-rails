require 'rails_helper'

field_name = 'bit'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: '1',
    type: 'number'
end
