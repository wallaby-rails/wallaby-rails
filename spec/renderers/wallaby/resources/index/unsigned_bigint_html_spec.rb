require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    "#{type} cell", field_name,
    model_class: AllMysqlType,
    value: BigDecimal(42)**20 do
    context 'when value is 0' do
      let(:value) { BigDecimal(0) }

      it 'renders the bigint' do
        expect(rendered).to include value.to_s
      end
    end
  end
end
