require 'rails_helper'

field_name = 'product_detail'
describe field_name, :current_user do
  it_behaves_like \
    'index partial', field_name,
    value: ProductDetail.new(id: 1),
    model_class: Product,
    partial_name: 'has_one',
    skip_general: true do

    it 'renders the has_one' do
      expect(rendered).to include view.show_link(value)
    end
  end
end
