# frozen_string_literal: true

require 'rails_helper'

field_name = 'products'
describe field_name, :wallaby_user, type: :helper do
  it_behaves_like \
    'index csv partial', field_name,
    value: [
      Product.new(id: 1, name: 'Hiking shoes'),
      Product.new(id: 2, name: 'Hiking pole'),
      Product.new(id: 3, name: 'Hiking jacket')
    ],
    model_class: Category,
    partial_name: 'has_many',
    expected_value: 'Hiking shoes, Hiking pole, and Hiking jacket',
    skip_nil: true do
    context 'when value is []' do
      let(:value) { [] }

      it 'renders empty string' do
        expect(rendered).to eq ''
      end
    end
  end
end
