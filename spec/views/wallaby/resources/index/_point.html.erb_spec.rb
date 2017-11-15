require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: [3, 4],
    skip_general: true do
    it 'renders the point' do
      expect(rendered).to eq "  (<span class=\"x\">3</span>,\n  <span class=\"y\">4</span>)\n"
    end
  end
end
