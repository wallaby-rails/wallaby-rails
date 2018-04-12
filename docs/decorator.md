## Decorator

The purposes of using a decorator are:
- [Basic Customization](#basic-customization): to customize how resource should be displayed on index/show/form page via managing metadata.
- [Advanced Customization](#advanced-customization): to encapsulate view logics for a model. for example, to define a `full_name` method to concatenate `first_name` and `last_name` together and get it to be displayed.
- [More Metadata Options](#more-metadata-options)
- [Filters](#filters): predefined filters
  - [Use Existing Named Scope](#use-existing-named-scope)
  - [Define a New Scope](#define-a-new-scope)
  - [More Filter Options](#more-filter-options)
- [Misc Customization](misc-customization)
  - [`to_label`](#to_label)
  - [`primary_key`](#primary_key)

Before we begin, it's always recommended to create a base decorator class `Admin::ApplicationDecorator` as below,
so that developers have a better control of global changes:

```ruby
# app/decorators/admin/application_decorator.rb
class Admin::ApplicationDecorator < Wallaby::ResourceDecorator
end
```

> see [Mapping](configuration.md#decorator) if `Admin::ApplicationDecorator` is taken for other purpose.

### Declaration

```ruby
# app/decorators/product_decorator.rb

# NOTE: Product in ProductDecorator must be singular
class ProductDecorator < Admin::ApplicationDecorator
end
```

If the name `ProductDecorator` is taken, it is possible to use another name, however the method `self.model_class` must be defined to specify the model as the example below:

```ruby
# app/decorators/admin/product_decorator.rb
class Admin::ProductDecorator < Admin::ApplicationDecorator
  def self.model_class
    Product
  end
end
```

### Basic Customization

There are two things that can be done with the metadata:

- change what fields to be displayed on index/show/form page. You will need to work on `index_field_names`/`show_field_names`/`form_field_names` respectively. The following example focuses on `index` page:

    ```ruby
      class ProductDecorator < Admin::ApplicationDecorator
        # Till here, Wallaby has already generated a list of field names
        # from existing database table columns or ORM,
        # and it's an array of string/symbol.
        # Therefore, you can do array operations on it.
        # For example, insert a field to the end of the list.
        self.index_field_names << 'updated_at'

        # Or it can be replaced with a brand new array.
        # Note that fields will be rendered in the array sequence on the frontend.
        self.index_field_names = ['id', 'name', 'price', 'created_at']
      end
    ```

    > NOTE: changing the `index_field_names` will not only impact how fields are displayed, but also what fields can be used for keyword search on both index page and autocomplete function. If a field will be used for autocomplete function, make sure it is listed in `index_field_names`.

- update the metadata information of a field.

    ```ruby
      class ProductDecorator < Admin::ApplicationDecorator
        # Till here, Wallaby has already generated the metadata for existing database columns or ORM.
        # Basically, metadata is just a hash that has minimum values of `:type`.
        # For example, you can update the label
        self.index_fields[:price][:label] = 'RRP'

        # Or you can update its type to `raw`
        # `raw` is built-in type to render HTML instead of escaping the HTML tags and entities.
        self.index_fields[:description][:type] = 'raw'

        # Or you can update its type to a custom one `custom_description`
        # If new type `custom_description` is assigned, a type partial created as
        # e.g. `app/views/admin/products/show/_custom_description.html.erb` will be required
        # in order to make this field rendered properly as expected:
        self.show_fields[:description][:type] = 'custom_description'
      end
    ```

    > Please check [View - Types](view.md#types) for full list of built-in types that Wallaby supports.
    > and check [View](view.md) to learn how partials can be created.


### Advanced Customization

As decorator is view-model for a resource object, it is possible to create custom method as a new field to be displayed:

```ruby
class ProductDecorator < Admin::ApplicationDecorator
  # `name` and `uid` are methods of `Product` object which decorator has delegated to.
  # or it is possible to access these methods by `resource.name` and `resource.uid`
  def slug
    [name, uid].join
  end

  # After this, two steps need to be done:
  # 1. add metadata for the the desired page (index, show or form page)
  # to specify how this field should be rendered.
  # NOTE: `type` is the minimum setup.
  self.index_fields[:slug] = {
    type: 'string'
  }

  # 2. add it to the field name list so that it can be displayed on index page.
  self.index_field_names << 'slug'
end
```

> NOTE: it is unnecessary to code in above order. Update of `index_fields`  and `index_field_names` can go before `def slug`.


### More Metadata Options

Options are:

- `:sort_field_name`: field name to be used for sorting on `index` page. Given the example in [Advanced Customization](#advanced-customization), it is possible to turn field `slug` sortable by defining the `:sort_field_name` option:

    ```ruby
    class ProductDecorator < Admin::ApplicationDecorator
      index_fields[:slug][:sort_field_name] = 'name'
    end
    ```

    > NOTE: the field name has to be one of the existing column in database table to make sorting working properly.
    > Also, this option only works with ActiveRecord models.

### Filters

> NOTE: filters only works with ActiveRecord models at the moment.

It's possible to define filters for a model in decorator to provide shortcuts to query the records apart from using the search.

#### Use Existing Named Scope

Given a model has defined a scope:

```ruby
class Product < ApplicationRecord
  scope :red, -> { where(color: 'red') }
end
```

Then a filter can be added as:

```ruby
class ProductDecorator < Admin::ApplicationDecorator
  self.filters[:red] = {
    scope: :red,
    label: 'Red Products'
  }
  # or with minimum metadata if not much customization is needed
  self.filters[:red] = {}
end
```

#### Define a New Scope

Defining a new scope in a decorator is easy as in ActiveRecord model:

```ruby
class ProductDecorator < Admin::ApplicationDecorator
  self.filters[:blue] = {
    scope: -> { where(color: 'blue') }
  }
end
```

#### More Filter Options

Options are:

- `:default`: to specify that the filter should be used on `index` page as default filter when end-user is first-time landing on it.

    ```ruby
    class ProductDecorator < Admin::ApplicationDecorator
      self.filters[:red] = {
        default: true
      }
    end
    ```

### Misc Customization

#### `to_label`

This method is used as the title for show page and autocomplete json response.

```ruby
class ProductDecorator < Admin::ApplicationDecorator
  def to_label
    product_slug + ' - ' + uuid
  end
end
```

#### `primary_key`

If a model has no primary key, it will be required to specify a field that Wallaby can be used as primary key to make show/form page working properly:

```ruby
class ActiveRecord::SchemaMigrationDecorator < Admin::ApplicationDecorator
  def primary_key
    version
  end
end
```
