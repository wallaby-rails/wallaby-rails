require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: BigDecimal(10)**13..BigDecimal(9) * 10**14,
    skip_general: true do

    it 'renders the int8range' do
      expect(rendered).to include '<span class="from">10000000000000.0</span>'
      expect(rendered).to include '<span class="to">900000000000000.0</span>'
    end
  end
end
