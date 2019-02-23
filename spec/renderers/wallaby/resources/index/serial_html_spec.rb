require 'rails_helper'

field_name = Rails::VERSION::MAJOR >= 5 ? field_name_from(__FILE__) : 'integer'
type = type_from __FILE__
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    "#{type} cell", field_name,
    value: BigDecimal(42)**20 do

    context 'when value is 0' do
      let(:value) { 0 }
      it 'renders the serial' do
        expect(rendered).to include value.to_s
      end
    end
  end
end
