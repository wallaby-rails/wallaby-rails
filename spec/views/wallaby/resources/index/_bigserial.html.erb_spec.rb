require 'rails_helper'

field_name = 'bigserial'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: BigDecimal.new(42)**20 do

    context 'when value is 0' do
      let(:value) { 0 }
      it 'renders the bigserial' do
        expect(rendered).to include value.to_s
      end
    end
  end
end
