require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: 'Top.Science',
    skip_general: true,
    max_length: 17,
    max_value: '814865cd-5a1d-4771-9306-4268f188fe9e',
    max_title: true
end
