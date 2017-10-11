require 'rails_helper'

field_name = 'float'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: 88.8888 do

    context 'when value is 0' do
      let(:value) { 0.0 }

      it 'renders the float' do
        expect(rendered).to include value.to_s
      end
    end
  end
end
