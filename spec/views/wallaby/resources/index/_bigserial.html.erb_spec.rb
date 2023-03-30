# frozen_string_literal: true

require 'rails_helper'

field_name = Rails::VERSION::MAJOR >= 5 ? field_name_from(__FILE__) : 'integer'
type = type_from __FILE__
describe field_name do
  it_behaves_like \
    "#{type} partial", field_name,
    partial_name: 'bigserial',
    value: BigDecimal('42')**20 do
    context 'when value is 0' do
      let(:value) { 0 }

      it 'renders the bigserial' do
        expect(rendered).to include value.to_s
      end
    end
  end
end
