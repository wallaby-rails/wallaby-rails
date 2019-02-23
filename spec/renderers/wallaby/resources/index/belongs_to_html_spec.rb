require 'rails_helper'

field_name = 'product'
klass = cell_class_from __FILE__
describe klass, type: :view, current_user: true do
  it_behaves_like \
    'index cell', field_name,
    value: Product.new(id: 1, name: 'Hiking shoes'),
    model_class: ProductDetail,
    partial_name: 'belongs_to',
    skip_general: true do

    it 'renders the belongs_to' do
      expect(rendered).to include view.show_link(value)
    end
  end
end
