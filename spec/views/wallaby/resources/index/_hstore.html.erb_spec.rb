require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    value: { 'key' => 'very long long long long text' },
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
