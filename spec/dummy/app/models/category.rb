# frozen_string_literal: true

class Category < ActiveRecord::Base
  has_many :products
  has_many :tags, through: :products
end
