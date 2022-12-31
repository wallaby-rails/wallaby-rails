# frozen_string_literal: true
require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} csv partial", field_name,
    value: Time.zone.parse('2016-03-16 14:55:10 UTC')..Time.zone.parse('2016-03-18 14:55:10 UTC'),
    expected_value: 'Wed, 16 Mar 2016 14:55:10 +0000...Fri, 18 Mar 2016 14:55:10 +0000'
end
