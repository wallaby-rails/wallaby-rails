module Her
  class Product
    include Her::Model
    collection_path 'products'
    attributes :label, :sku, :name

    has_one :picture, class_name: Her::Picture.name
    belongs_to :category, class_name: Her::Category.name
    has_many :orders, class_name: Her::Order.name
  end
end
