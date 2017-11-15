## Decorator

The following scenarios are the perfect use cases for choosing a Wallaby decorator:

- change what fields to show/list
- update the metadata information of a field, e.g. title, type
- add custom field

```ruby
#!app/decorators/product_decorator.rb

# NOTE: Product in ProductDecorator must be singular
class ProductDecorator < Wallaby::ResourceDecorator
  # example of metadata:
  # {
  #   column_name: { # minimum data requires type and label
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

Similarly, if the name ProductDecorator is taken, we could use another name and add a method to specify the model class.

```ruby
#!app/decorators/admin/product_decorator.rb
class Admin::ProductDecorator < Wallaby::ResourceDecorator
  def self.model_class
    Product
  end
end
```
