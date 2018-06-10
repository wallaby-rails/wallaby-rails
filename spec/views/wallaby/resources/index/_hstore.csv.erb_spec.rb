require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} csv partial", field_name,
    value: { 'key' => 'very long long text' },
    expected_value: "{\"key\"=>\"very long long text\"}"
end
