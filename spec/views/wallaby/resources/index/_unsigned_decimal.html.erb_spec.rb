require 'rails_helper'

field_name = 'unsigned_decimal'
describe field_name do
  it_behaves_like 'index partial', field_name,
    model_class: AllMysqlType,
    value: BigDecimal.new(42)**13 / 10**20 do

    context 'when value is 0' do
      let(:value) { BigDecimal.new 0 }
      it 'renders the decimal' do
        expect(rendered).to include value.to_s
      end
    end
  end
end
