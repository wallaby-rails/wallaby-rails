# frozen_string_literal: true

require 'rails_helper'

field_name = field_name_from __FILE__
type = type_from __FILE__
describe field_name, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
    value: BigDecimal('42')**20 do
    context 'when value is 0' do
      let(:value) { BigDecimal('0') }

      it 'renders the bigint' do
        expect(rendered).to include value.to_i.to_s
      end
    end
  end
end
