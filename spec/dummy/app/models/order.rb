# frozen_string_literal: true

class Order < ActiveRecord::Base
  has_many :items, class_name: 'Item'
  has_many :products, through: :items
end
