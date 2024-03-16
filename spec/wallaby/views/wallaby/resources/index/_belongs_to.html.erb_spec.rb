# frozen_string_literal: true

require 'rails_helper'

field_name = 'product'
type = type_from __FILE__
describe field_name, :wallaby_user, type: :helper do
  it_behaves_like \
    "#{type} partial", field_name,
    value: Product.new(id: 1, name: 'Hiking shoes'),
    model_class: ProductDetail,
    partial_name: 'belongs_to',
    skip_general: true do
    it 'renders the belongs_to' do
      expect(rendered).to include view.show_link(value)
    end
  end
end
