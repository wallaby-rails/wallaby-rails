require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} csv partial", field_name,
    value: Time.zone.parse('Tue, 11 Feb 2014 23:59:59 +0000'),
    expected_value: 'Tue, 11 Feb 2014 23:59:59 +0000'
end
