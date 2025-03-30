# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :products
  has_many :tags, through: :products
end
