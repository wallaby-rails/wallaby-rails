class Customer < Person
  has_one :picture, as: :imageable
end
