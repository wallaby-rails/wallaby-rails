require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: 100.88 do

    context 'when value is 0' do
      let(:value) { 0 }
      it 'renders the money' do
        expect(rendered).to include h(value)
      end
    end
  end
end
