# frozen_string_literal: true

require 'rails_helper'

describe 'Associations' do
  let!(:product) { Product.create }
  let!(:order1) { Order.create }
  let!(:order_item1) { Order::Item.create order: order1, product: product }
  let!(:order2) { Order.create }
  let!(:order_item2) { Order::Item.create order: order2 }

  it 'saves has many through' do
    expect(order_item1.reload.product).to eq product
    expect(product.reload.order_ids).to eq [order1.id]
    product.order_ids = [order2.id]
    product.save
    expect(product.reload.order_ids).to eq [order2.id]
  end
end
