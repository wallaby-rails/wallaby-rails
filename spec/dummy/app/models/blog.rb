class Blog < ActiveRecord::Base
  has_one_attached :image if defined?(ActiveStorage)
end
