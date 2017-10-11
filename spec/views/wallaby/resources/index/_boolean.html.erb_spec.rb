require 'rails_helper'

field_name = 'boolean'
describe field_name do
  it_behaves_like 'index partial', field_name,
    value: '010111',
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
