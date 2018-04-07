[ AllPostgresType, Category, Order, Order::Item, Picture, Product, Tag ].each do |model|
  ActiveRecord::Base.connection.execute("TRUNCATE #{ model.table_name } RESTART IDENTITY")
end
ActiveRecord::Base.connection.execute("TRUNCATE products_tags RESTART IDENTITY")

10.times.each do
  all_postgres_type = AllPostgresType.new
  all_postgres_type.string = FFaker::Name.name
  all_postgres_type.text = FFaker::Lorem.paragraph
  all_postgres_type.integer = rand 100
  all_postgres_type.float = rand(1000) / rand(10).to_f
  all_postgres_type.decimal = rand 10000
  all_postgres_type.datetime = FFaker::Time.date
  all_postgres_type.time = FFaker::Time.date
  all_postgres_type.date = FFaker::Time.date
  date = Time.zone.parse FFaker::Time.date
  all_postgres_type.daterange = date..(date + rand(10).days)
  all_postgres_type.numrange = rand(10)..(rand(100) + 10)
  date = Time.zone.parse FFaker::Time.date
  all_postgres_type.tsrange = date..(date + rand(10).days)
  date = Time.zone.parse FFaker::Time.date
  all_postgres_type.tstzrange = date..(date + rand(10).days)
  all_postgres_type.int4range = rand(10)..(rand(100) + 10)
  all_postgres_type.int8range = rand(10)..(rand(100) + 10)
  all_postgres_type.binary = nil
  all_postgres_type.boolean = [ true, false, nil ].sample
  all_postgres_type.bigint = 100
  all_postgres_type.xml = "<text>#{ FFaker::Lorem.paragraph }</text>"
  all_postgres_type.tsvector =
  all_postgres_type.hstore = { 'system' => 'test' }
  all_postgres_type.inet = FFaker::Internet.ip_v4_address
  all_postgres_type.cidr = FFaker::Internet.ip_v4_address
  all_postgres_type.macaddr = 12.times.map{ '0123456789ABCDEF'[rand(16)] }.join('')
  all_postgres_type.uuid = FFaker::Guid.guid
  all_postgres_type.json = { 'system' => 'test' }.to_json
  all_postgres_type.jsonb = { 'system' => 'test' }.to_json
  all_postgres_type.ltree = "#{ FFaker::Lorem.word }.#{ FFaker::Lorem.word }.#{ FFaker::Lorem.word }"
  all_postgres_type.citext = FFaker::Lorem.paragraph
  all_postgres_type.point = [ rand(10), rand(10) ]
  all_postgres_type.bit = [ 0, 1 ].sample
  all_postgres_type.bit_varying = (1..(rand(5) + 1)).to_a.map{ [ 0, 1 ].sample }.join('')
  all_postgres_type.money = rand(99999999)
  all_postgres_type.save!
end

10.times.each do
  category = Category.new
  category.name = FFaker::Product.product.split(' ').sample
  category.save!
end

10.times.each do
  tag = Tag.new
  tag.name = FFaker::Product.product.split(' ').sample.downcase
  tag.save!
end

100.times.each do
  product = Product.new
  product.category = Category.all.sample
  product.tags = Tag.all.shuffle.first 3
  product.name = FFaker::Product.product_name
  product.sku = FFaker::Product.model
  product.description = FFaker::Lorem.paragraph
  product.stock = rand 100
  product.price = rand * 100
  product.featured = FFaker::Boolean.random
  product.available_to_date = FFaker::Time.date
  product.available_to_time = FFaker::Time.date
  product.published_at = FFaker::Time.date
  product.save!
end

10.times.each do
  order = Order.new
  order.customer = FFaker::Name.name
  order.ordered_at = FFaker::Time.date
  order.save!

  product = Product.all.sample
  rand(5).times.each do
    item = Order::Item.new
    item.order_id = order.id
    item.product_id = product.id
    item.quantity = rand(100)
    item.price = product.price
    item.total = item.quantity * item.price
    item.save!
  end
end
