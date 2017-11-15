require 'rails_helper'

partial_name = 'email'
field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: 'tian@reinteractive.net',
    type: 'email',
    partial_name: partial_name,
    input_selector: 'input.form-control' do
  end
end
