require 'rails_helper'

field_name = __FILE__[/_(.+)\.html\.erb_spec\.rb$/, 1]
type = __FILE__[%r{/([^/]+)/_}, 1]
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: { 'key' => 'very long long text' },
    skip_general: true,
    modal_value: true do

    context 'when value is less than 20 characters' do
      let(:value) { { 'a' => 1 } }

      it 'renders the hstore' do
        expect(rendered).to include h(value)
      end
    end

    context 'when max is set to 30' do
      let(:metadata) { Hash max: 30 }

      it 'renders the hstore' do
        expect(rendered).to include h(value)
      end
    end
  end
end
