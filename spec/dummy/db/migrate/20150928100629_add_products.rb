class AddProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer   :category_id
      t.string    :sku
      t.string    :name
      t.text      :description
      t.integer   :stock
      t.float     :price
      t.boolean   :featured
      t.date      :available_to_date
      t.time      :available_to_time
      t.datetime  :published_at
    end

    create_table :categories do |t|
      t.string    :name
    end

    create_table :tags do |t|
      t.string    :name
    end

    create_join_table :products, :tags do |t|
      t.index :product_id
      t.index :tag_id
    end
  end
end
