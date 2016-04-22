# Customization

Customization can be done in the following sections, and all examples will be based on Product model:

- [Controller](#controller)
- [Decorator](#decorator)
- [Servicer](#servicer)
- [View](#view)

> NOTE: model class is the only thing carried through a complete request.

## Controller

In order to customize a controller action, controller should inherit from `Wallaby::ResourcesController` as below, then we could override the general RESTful actions (index/show/new/create/edit/update/destroy):

```ruby
#!app/controllers/products_controller.rb
class ProductsController < Wallaby::ResourcesController
  def index; super; end
  def show; super; end
  def new; super; end

  # @example override create action
  def create
    flash[:notice] = 'Create product is in progress'
    super
  end

  def edit; super; end
  def update; super; end
  def destroy; super; end
end
```

If you have already declared a ProductsController for other purpose, you could use other controller name and specify the model class.

```ruby
#!app/controllers/admin/products_controller.rb
class Admin::ProductsController < Wallaby::ResourcesController
  def self.model_class
    Product
  end
end
```

## Decorator

If we need to change what fields to show, or update the metadata information of a field, we consider to use decorator.

```ruby
#!app/decorators/product_decorator.rb

# NOTE: Product in ProductDecorator must be singular
class ProductDecorator < Wallaby::ResourceDecorator
  # example of metadata:
  # {
  #   column_name: {
  #     type: string,
  #     label: 'Column Name',
  #     name: 'column_name'
  #   }
  # }
  self.index_fields # metadata for index page
  self.show_fields  # metadata for show page
  self.form_fields  # metadata for new/create/edit/update page

  # example of field_names:
  # [ 'id', 'column1', ..., 'created_at', 'updated_at' ]
  self.index_field_names  # array of column names to display on index page
  self.show_field_names   # array of column names to display on show page
  self.form_field_names   # array of column names to display on form page

  # examples
  self.index_fields[:email][:type] = 'email'
  self.index_fields[:full_product_name] = { type: 'string', label: 'Product Name' }
  self.index_field_names << 'full_product_name'

  def full_product_name
    [ product_name, sku ].compact.join ' - '
  end
end
```

Similarly, if ProductDecorator is taken, we could other name and specify the model class.

```ruby
#!app/decorators/admin/product_decorator.rb
class Admin::ProductDecorator < Wallaby::ResourceDecorator
  def self.model_class
    Product
  end
end
```

## Servicer

If any actions need to be carried out in the persistence layer, we use a servicer (service object):

```ruby
#!app/servicers/product_servicer.rb
class ProductServicer < Wallaby::ModelServicer
  # @return collection of resources
  def collection(params, ability); super; end

  # @return resource
  def new(params); super; end

  # @return resource
  def find(id, params); super; end

  # @example override create method
  # @return [ resource, boolean ]
  def create(params, ability)
    product, success = super
    publish_and_index product
    [ product, success ]
  end

  # @return [ resource, boolean ]
  def update(resource, params, ability); super; end

  # @return boolean
  def destroy(resource, params); super; end
end
```

Similarly, if there is name conflict, just use other name and specify the model class.

```ruby
#!app/servicers/admin/product_servicer.rb
class Admin::ProductServicer < Wallaby::ModelServicer
  def self.model_class
    Product
  end
end
```

## View

It is easy to customize how a field should be rendered. In the following example, we will change product description to be rendered using markdown on index page:

First of all, we need to update the type in decorator:

```ruby
#!app/decorators/product_decorator.rb
class ProductDecorator < Wallaby::ResourceDecorator
  self.index_fields[:description][:type] = 'markdown'
end
```

Then we need to add a partial for it. The partial can be either created under

```
#!app/views/products/index/_markdown.html.erb
```

If it's product specific. Or

```
#!app/views/wallaby/resources/index/_markdown.html.erb
```

If it applies to all markdown fields.

```erb
<%= markdown.render value  %>
```

### Index / show partials

For index and show partial, we will have access to the following variables:

- `object`: the resource object
- `field_name`: current field name
- `value`: current value
- `metadata`: metadata for current field

### Form partials

For index and show partial, we will have access to the following variables:

- `form`: the instance of Wallaby::FormBuilder providing additional helper methods for error class and error messages
- `object`: the resource object
- `field_name`: current field name
- `value`: current value
- `metadata`: metadata for current field
