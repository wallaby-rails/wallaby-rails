require 'rails_helper'

field_name = 'product'
describe field_name, :wallaby_user do
  it_behaves_like \
    'index csv partial', field_name,
    value: Product.new(id: 1, name: 'Hiking shoes'),
    model_class: ProductDetail,
    partial_name: 'belongs_to',
    expected_value: 'Hiking shoes'
end
