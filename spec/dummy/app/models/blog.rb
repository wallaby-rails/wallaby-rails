# frozen_string_literal: true

class Blog < ApplicationRecord
  has_one_attached :image if defined?(ActiveStorage)
end
