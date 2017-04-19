class Order
  class Item < ActiveRecord::Base
    belongs_to :order
    belongs_to :product
  end
end
