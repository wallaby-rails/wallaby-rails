require 'rails_helper'

field_name = 'time'
describe field_name do
  it_behaves_like 'form partial', field_name,
    value: Time.new(2014, 2, 11, 23, 59, 59, '+00:00'),
    type: 'time',
    expected_value: '2014-02-11 23:59:59 +0000'
end
