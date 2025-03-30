# frozen_string_literal: true

class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  has_one_attached :file if defined?(ActiveStorage)
  validates_presence_of :name
end
