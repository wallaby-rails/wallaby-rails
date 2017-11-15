require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: '(1,2),(3,4)',
    skip_general: true,
    code_value: true,
    max_length: 20,
    max_value: '(1.0000008,2.00000008),(3.99999999,4.5555555555)',
    max_title: true
end
