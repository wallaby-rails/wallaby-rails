class Category < ActiveRecord::Base
  has_many :products
  has_many :tags, through: :products

  validates :name, presence: true
end