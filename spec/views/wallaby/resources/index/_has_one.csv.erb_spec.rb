# frozen_string_literal: true
require 'rails_helper'

field_name = 'product_detail'
describe field_name, :wallaby_user do
  it_behaves_like \
    'index csv partial', field_name,
    value: ProductDetail.new(id: 1),
    model_class: Product,
    partial_name: 'has_one',
    expected_value: '1'
end
