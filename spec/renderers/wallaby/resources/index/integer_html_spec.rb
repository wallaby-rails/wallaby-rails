require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    "#{type} cell", field_name,
    value: 100 do

    context 'when value is 0' do
      let(:value) { 0 }

      it 'renders the integer' do
        expect(rendered).to include value.to_s
      end
    end
  end
end
