# Customization

This engine allows us to do further development in Rails way from the following sections.

First of all, let, if you have a model call `Product` and it has the following columns:

- sku:string
- name:string
- category_id:integer
- description:text
- stock:integer
- price:float
- featured:boolean
- available_to_date:date
- available_to_time:time
- published_at:datetime

And it has model declaration as below:

```ruby
class Product < ActiveRecord::Base
  has_one :product_detail
  has_one :picture, as: :imageable
  has_many :order_items, class_name: Order::Item.name
  has_many :orders, through: :order_items
  belongs_to :category
  has_and_belongs_to_many :tags

  validates_presence_of :name, :sku
end
```

## Configuration

This engine by default uses ActiveRecord adaptor, you could change this to other adaptor (e.g. Mongo / HER adaptor) as below:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  config.adaptor = Wallaby::SomeOtherAdaptor
end
```

By default, there is no authentication, and you need to do the following config if you need one:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  config.security.authenticate do
    # you could use any controller methods here
    authenticate_or_request_with_http_basic do |username, password|
      username == 'too_simple' && password == 'too_naive'
    end
  end

  config.security.current_user do
    # you could use any controller methods here
    Class.new do
      def email
        'user@example.com'
      end
    end.new
  end
end
```

You could hide some models using configuration as below:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  config.models.exclude ProductDetail, Order, Order::Item
end
```

## Controller

You could modify the logics for Post model by defining a controller as below:

```ruby
class PostsController < Wallaby::ResourceController
  def create
    # do something else
    super
  end
end

# OR any controller name you want, but specifying the `model_class`
class Admin::CustomPostsController < Wallaby::ResourceController
  def self.model_class
    Post
  end

  def create
    # do something else
    super
  end
end
```

## Decorator

Similar to the controller above, you could use two ways to define a decorator.
Having a decorator, you could then modify what fields to use for views index/show/form

```ruby
class PostDecorator < ResourceDecorator
  index_field_names.delete 'body'
  show_fields['body'][:type] = 'markdown'
  form_fields['body'][:label] = 'Content'
end
```

## View

You could easily define any field view for any custom type (e.g. markdown) for Post by defining a partial under `app/views/posts/index/_markdown`

```erb
<%# The local variables in the partial are `value` %>
<%= markdown.render value %>
```

If you want to make it available for other models, you could move it to `app/views/resources/index/_markdown`

