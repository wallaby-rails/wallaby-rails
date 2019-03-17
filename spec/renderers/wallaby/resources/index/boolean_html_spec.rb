require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
klass = cell_class_from __FILE__
describe klass, type: :view do
  it_behaves_like \
    "#{type} cell", field_name,
    value: true,
    model_class: AllMysqlType,
    skip_general: true do

    it 'renders the boolean' do
      expect(rendered).to include view.fa_icon('check-square')
    end

    context 'when value is false' do
      let(:value) { false }
      it 'renders the boolean' do
        expect(rendered).to include view.fa_icon('square')
      end
    end
  end
end
