class Order < ActiveRecord::Base
  has_many :items, class_name: Item.name
  has_many :products, through: :items
end
