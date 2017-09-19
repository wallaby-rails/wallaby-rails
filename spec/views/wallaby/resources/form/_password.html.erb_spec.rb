require 'rails_helper'

field_name = 'password'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: 'password1',
    type: 'password',
    expected_value: ''
end
