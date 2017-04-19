class Tag < ActiveRecord::Base
  has_and_belongs_to_many :products
  has_many :categories, through: :products
end
