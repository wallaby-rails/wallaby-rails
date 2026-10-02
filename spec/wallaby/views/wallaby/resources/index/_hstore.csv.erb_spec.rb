# frozen_string_literal: true

require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
value = { 'key' => 'very long long text' }
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} csv partial", field_name,
    value: value,
    expected_value: value.to_s
end
