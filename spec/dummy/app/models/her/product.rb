module Her
  class Product
    include Her::Model
    collection_path 'products'
    attributes :label, :sku, :name
    has_many :orders, class_name: Her::Order.name
    default_scope -> { where(fields: [:sku, :name]) }
  end
end
