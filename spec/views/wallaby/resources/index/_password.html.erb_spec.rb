require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: 0..100,
    skip_general: true do

    it 'renders the password' do
      expect(rendered).to include '<code>********</code>'
    end
  end
end
