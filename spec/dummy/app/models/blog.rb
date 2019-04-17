class Blog < ActiveRecord::Base
  has_one_attached :image
end
