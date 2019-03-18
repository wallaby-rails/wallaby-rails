require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: Time.new(2014, 2, 11, 23, 59, 59, '+00:00'),
    type: 'text',
    expected_value: '2014-02-11 23:59:59 +0000'
end
