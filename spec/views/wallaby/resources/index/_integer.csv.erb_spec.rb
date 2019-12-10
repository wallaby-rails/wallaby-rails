require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} csv partial", field_name,
    value: 100 do
    context 'when value is 0' do
      let(:value) { 0 }

      it 'renders the money' do
        expect(rendered).to eq '0'
      end
    end
  end
end
