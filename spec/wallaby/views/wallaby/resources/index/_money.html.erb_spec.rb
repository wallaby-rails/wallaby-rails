# frozen_string_literal: true

require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
    value: 100.88 do
    context 'when value is 0' do
      let(:value) { 0 }

      it 'renders the money' do
        expect(rendered).to include h(value)
      end
    end
  end
end
