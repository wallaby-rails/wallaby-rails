require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: '<b>1234567890123</b>',
    max_length: 20,
    max_value: "<b>this's a text for more than 20 characters</b>",
    modal_value: true
end
