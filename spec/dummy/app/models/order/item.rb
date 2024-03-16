# frozen_string_literal: true

class Order
  class Item < ActiveRecord::Base
    belongs_to :order
    belongs_to :product
    has_one :product_detail, through: :product
  end
end
