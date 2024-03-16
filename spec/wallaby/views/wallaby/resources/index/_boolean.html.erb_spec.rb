# frozen_string_literal: true

require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
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
