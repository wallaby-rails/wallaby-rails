require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: BigDecimal(42)**20 do

    context 'when value is 0' do
      let(:value) { 0 }
      it 'renders the bigserial' do
        expect(rendered).to include value.to_s
      end
    end
  end
end
