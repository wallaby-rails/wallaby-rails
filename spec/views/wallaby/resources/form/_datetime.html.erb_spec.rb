require 'rails_helper'

field_name = 'datetime'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: Time.new(2014, 2, 11, 23, 59, 59, '+00:00'),
    expected_value: '2014-02-11 23:59:59 +0000',
    content_for: true
end
