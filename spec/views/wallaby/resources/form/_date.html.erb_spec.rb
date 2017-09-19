require 'rails_helper'

field_name = 'date'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: Date.new(2014, 2, 11),
    expected_value: '2014-02-11',
    content_for: true
end
