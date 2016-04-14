class Picture < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
  validates_presence_of :name
end
