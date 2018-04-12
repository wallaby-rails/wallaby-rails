## View

- [Local Variables](#local-variables)
- [Types](#types)

### Create type partial

Wallaby uses type partials to render the fields of a record. It utilizes and extends [Template Inheritance](http://guides.rubyonrails.org/layouts_and_rendering.html#using-render) so that Wallaby can search type partials.

Let's look at a complicated example, if in a decorator, a field type is updated to `markdown`:

```ruby
# app/decorators/product_decorator.rb
class ProductDecorator < Admin::ApplicationDecorator
  self.index_fields[:description][:type] = 'markdown'
end
```

> NOTE: please do not use the following names as type:
> `title`, `logo`, `header`, `footer`, `user_menu`, `navs`, `index_actions`, `resource_actions` and `resource_navs`, as they are used as the configurable partials in frontend (see [Partials](frontend.md#partials))

> see [Decorator](decorator.md) for more information about base class `Admin::ApplicationDecorator`.

Also, a Wallaby controller for `Product` is declared:

```ruby
# app/controllers/backend/goods_controller.rb
class Backend::GoodsController < Admin::ApplicationsController
  def self.model_class; Product; end
end
```

> see [Controller](controller.md) for more information about base class `Admin::ApplicationController`.

Then Wallaby will search type partials in the following precedence:

- `app/views/$MOUNTED_PATH/$RESOURCES/$ACTION_PREFIX`
- `app/views/$MOUNTED_PATH/$RESOURCES`
- `app/views/$CONTROLLER_PATH/$ACTION_PREFIX`
- `app/views/$CONTROLLER_PATH`
- `app/views/$BASE_CONTROLLER_PATH/$ACTION_PREFIX`
- `app/views/$BASE_CONTROLLER_PATH`
- `app/views/wallaby/resources/$ACTION_PREFIX`
- `app/views/wallaby/resources`

Given that:
- Wallaby is mounted under `/admin` in `config/routes.rb`
- Action prefix is `index`.
    > NOTE: action prefix can only be one of `index`, `show` and `form` (`form` is for action name `new/create/edit/update`)

Then Wallaby will search type partial `markdown` in the following orders:

- `app/views/admin/products/index/_markdown`
- `app/views/admin/products/_markdown`
- `app/views/backend/goods/index/_markdown`
- `app/views/backend/goods/_markdown`
- `app/views/admin/application/index/_markdown`
- `app/views/admin/application/_markdown`
- `app/views/wallaby/resources/index/_markdown`
- `app/views/wallaby/resources/_markdown`

Therefore, you could choose one of the above paths to create this type partial based on your need.

If markdown is only needed for this product, you can create partial like:

```erb
<% # app/views/admin/products/index/_markdown.html.erb %>
<%= markdown.render value  %>
```

If you want to share the partial among the whole app, it should be created as:

```erb
<% # app/views/admin/application/index/_markdown.html.erb %>
<%= markdown.render value  %>
```

### Local Variables

In order to build complicated type partial, you will need to know the following local variables among `index`, `show` and `form`:

- `object`: the decorator object which wraps the resource object
- `field_name`: current field name
- `value`: current value
- `metadata`: metadata for current field

For `form` action prefix, there is one more local variable:

- `form`: a form builder instance extending `ActionView::Helpers::FormBuilder` to provides additional helper methods for error class and error messages.

## Types

Here is a list of built-in database types that Wallaby could handle for index/show/form pages:

- bigint
- bigserial
- binary
- bit
- bit_varying
- blob
- boolean
- box
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- cidr
- circle
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- citext
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- date
- daterange
- datetime
- decimal
- float
- hstore
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- inet
- int4range
- int8range
- integer
- json
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- jsonb
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- line
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- longblob
- longtext
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- lseg
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- ltree
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- macaddr
- mediumblob
- mediumtext
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- money
- numrange
- path
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- point
- polygon
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- serial
- string
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- text
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- time
- tinyblob
- tinytext
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- tsrange
- tstzrange
- tsvector
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- unsigned_bigint
- unsigned_decimal
- unsigned_float
- unsigned_integer
- uuid
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
- xml

Apart from the above types, these are also supported:

- belongs_to
  - metadata options for `show` partial:
    - `:class`: the same class constant as the association option `:class_name` (not recommend to change)
    - `:is_polymorphic`: the same value as the association option `:polymorphic` (not recommend to change)
  - metadata options for `form` partial:
    - `:class`: the same class constant as the association option `:class_name` (not recommend to change)
    - `:is_polymorphic`: the same value as the association option `:polymorphic` (not recommend to change)
    - `:foreign_key`: the same value as the association option `:foreign_key` (not recommend to change)
    - `:polymorphic_type`: the polymorphic type column name
    - `:polymorphic_list`: a list of classes for this polymorphic association
    - `:remote_urls`: the ajax URLs for autocompletion for this polymorphic association
    - `:remote_url`: the ajax URL for autocompletion
- color
- dropdown (form)
  - metadata options for `form` partial:
    - `:choices`: used by [ActionView::Helpers::FormBuilder#select](http://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-select). NOTE: apart from a collection, choices can be a proc like `-> { Order.order_by params[:name] }` which will be executed in helper context.
    - `:options`: used by [ActionView::Helpers::FormBuilder#select](http://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-select)
    - `:html_options`: used by [ActionView::Helpers::FormBuilder#select](http://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-select)
- email
- file (form)
- has_and_belongs_to_many
  - metadata options for `show` partial:
    - `:class`: the same class constant as the association option `:class_name` (not recommend to change)
  - metadata options for `form` partial:
    - `:class`: the same class constant as the association option `:class_name` (not recommend to change)
    - `:foreign_key`:  the same value as the association option `:foreign_key` (not recommend to change)
    - `:remote_url`: the ajax URL for autocompletion
- has_many
  - metadata options for `show` partial:
    - `:class`: the same class constant as the association option `:class_name` (not recommend to change)
  - metadata options for `form` partial:
    - `:class`: the same class constant as the association option `:class_name` (not recommend to change)
    - `:foreign_key`:  the same value as the association option `:foreign_key` (not recommend to change)
    - `:remote_url`: the ajax URL for autocompletion
- has_one
  - metadata options for `show` partial:
    - `:class`: the same class constant as the association option `:class_name` (not recommend to change)
  - metadata options for `form` partial:
    - `:class`: the same class constant as the association option `:class_name` (not recommend to change)
- image (show)
  - metadata options for `show` partial:
    - `:options`: used by [ActionView::Helpers::AssetTagHelper#image_tag](http://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-image_tag)
- markdown (form)
- password
- raw (index/show)
- sti
  - metadata options for `index` partial:
    - `:max`: Truncates a given text after a given `max` if text is longer than `max`
  - metadata options for `form` partial:
    - `:sti_class_list`: an array of classes for STI column

> NOTE: all the `form` partials above support metadata option `hint` to customize the hint message in `form` view (available from version `5.1.5`).

To use the type partials, please have a read at [Decorator](decorator.md)
