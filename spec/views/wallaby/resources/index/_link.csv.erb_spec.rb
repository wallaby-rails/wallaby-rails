require 'rails_helper'

field_name = 'string'
describe field_name, :current_user do
  it_behaves_like \
    'index csv partial', field_name,
    value: 'https://reinteractive.com/',
    partial_name: 'link',
    expected_value: 'https://reinteractive.com/'
end
