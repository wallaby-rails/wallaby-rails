# View

In Wallaby, the core of view layer is to iterate decorator's **\*_field_names** and render the cell/partial using corresponding type from decorator's **\*_fields**.

For example, for index view, the core looks like the following pseudocode:

```erb
<%= index_field_names.each do |field_name| %>
  <%= type_render index_fields[field_name][:type],
    object: object, field_name: field_name, value: value %>
<% end %>
```

It extends Rails' partial lookup order (see [Rails Template Inheritance](https://guides.rubyonrails.org/layouts_and_rendering.html#template-inheritance)) and supports [Type Partial](#type-partial).

From 5.2.0, `type_render` is used to extend `render` helper method to provide support for [Cell](#cell) to improve rendering performance.

Starting with these concepts:

- [What's Cell](#cell) (since 5.2.0)
- [What's Type Partial](#type-partial)
- [Cell and Partial Lookup Order](#cell-and-partial-lookup-order)

For Cell (since 5.2.0):

- [Declaration](#cell)
- [context](#context) - view context
- [local_assigns](#local_assigns) - local variables same as partial `local_assigns`
- [object, field_name, value, metadata and form](#object-field_name-value-metadata-and-form) - five mostly used local variables
- [at](#at) - accessing and assigning value of an instance variable in the view context

Cell helper methods (since 5.2.0):

- [concat](#concat) - to append a string to cell's output buffer.

For Type Partial:

- [object, field_name, value, metadata and form](#type-partial-locals) - local variables for type partial

Also check out:

- [Built-in Cell/Type Partials](#built-in-cell-type-partials)

## Cell

> since 5.2.0

In short, a cell is a special [type partial](#type-partial) component in `rb` file format.

For example, if a custom type `markdown` is defined for show field `description` in `ProductDecorator`:

```ruby
class ProductDecorator < Admin::ApplicationDecorator
  show_fields[:description][:type] = 'markdown'
end
```

Then a cell can be created using the type `markdown` to serve this field `description` using the following file path:

```ruby
# app/views/admin/products/show/markdown_html.rb
module Admin
  module Products
    module Show
      class MarkdownHtml < Wallaby::Cell
        def render
          Redcarpet.new(value.to_s).to_html
        end
      end
    end
  end
end
```

> NOTE: the cell is designed to improve performance. Therefore, if the view logic is complicated (e.g. containing a lot of CSS/JS), it will become hard to read and maintain.

Similar to other Rails naming convention, the cell's class name reflects the full file path that can contain the locale (e.g. `en` or `fr`) and format of the HTTP request (e.g. `html`, `csv` or `json`). For example:

```
app/views/admin/products/show/markdown_fr_csv.rb
```

A cell uses `render` method to produce HTML output. On top of that, all Rails and Wallaby helper methods (e.g. `content_tag`, `null`) can be accessed as in ordinary Rails partial template.

However, please be aware of the following important differences between a cell and a partial template:

- to access or modify the instance variable for the view, it's required to use `context.instance_variable_get` and `context.instance_variable_set` (see [context](#context)).
- `concat` helper method is overridden to maintain a standalone buffer inside a cell. But it is still possible to access the origin `concat` by calling `context.concat`.

### context

Generally, a cell is initialized with view context and delegates all Rails and Wallaby helper methods (except `concat`) to this view context. Therefore, all Rails and Wallaby helper methods can be accessed either directly or via `context`. For example:

```ruby
def render
  # direct access to helper method
  link_to local_assigns[:value], 'external url'
  # via `context`
  context.link_to local_assigns[:value], 'external url'
end
```

### local_assigns

Similar to a partial, a cell can accept [local variables](https://guides.rubyonrails.org/layouts_and_rendering.html#passing-local-variables) (a.k.a. **locals**) from [**render**](https://api.rubyonrails.org/classes/AbstractController/Rendering.html#method-i-render) method. And locals is stored as attribute reader `local_assigns` in a cell. To access it, it goes:

```ruby
def render
  link_to local_assigns[:label], 'external url'
end
```

### object, field_name, value, metadata and form

The following methods are the shortcut to read and write local variables:

- `object`: resource object wrapped in a decorator, the same as `local_assigns[:object]`
  `object=`: the same as `local_assigns[:object]=`
- `field_name`: current field name
  `field_name=`: the same as `local_assigns[:field_name]=`
- `value`: current value
  `value=`: the same as `local_assigns[:value]=`
- `metadata`: associated metadata for current field and current action (`index`/`show`/`form`).
  `metadata=`: the same as `local_assigns[:metadata]=`
- `form`: form object related to the resource object
  `form=`: the same as `local_assigns[:form]=`

```ruby
def render
  # shortcut
  link_to value, 'external url'
  # or via `local_assigns`
  link_to local_assigns[:value], 'external url'
end
```

### Cell Helper Methods

#### at

`at` is used to access and write value to a view instance variable. For example:

```ruby
def render
  at('read', true) # set @read to true in view
  label = at('resource').index_field_names.first # get @resource from the view
  form.label label
end
```

#### concat

`concat` is used to append a string to cell's output buffer. For example:

```ruby
def render
  concat form.label field_name
  form.text_field field_name, value, metadata[:options]
end
```

## Type Partial

A type partial is no different from Rails partial template. Just its name associates with the type defined in decorator's metadata.

For example, a custom type `markdown` is defined for show field `description` in `ProductDecorator`:

```ruby
class ProductDecorator < Admin::ApplicationDecorator
  show_fields[:description][:type] = 'markdown'
end
```

Then a partial can be created using the type `markdown` to serve this field `description` using the following file path:

```erb
<%# app/views/admin/products/show/_markdown.html.erb %>
<%# @param object [model] model instance %>
<%# @param field_name [String] name of the field %>
<%# @param value [Object] value of the field %>
<%# @param metadata [Hash] metadata of the field %>
<%= Redcarpet.new(value).to_html %>
```

### Type Partial Locals

Similar to [Cell Local variables](#local_assigns), the following variables are available:

- `object`: resource object wrapped in a decorator
- `field_name`: current field name
- `value`: current value
- `metadata`: associated metadata for current field and current action (`index`/`show`/`form`).
- `form`: form object associated with the `object`

## Cell and Partial Lookup Order

On top of [Rails' lookup order](https://guides.rubyonrails.org/layouts_and_rendering.html#template-inheritance), Wallaby has extended the order from high to low precedence as:

- app/views/**$MOUNTED_PATH**/**$RESOURCES**/**$ACTION_PREFIX**
- app/views/**$MOUNTED_PATH**/**$RESOURCES**
- app/views/**$CONTROLLER_PATH**/**$ACTION_PREFIX**
- app/views/**$CONTROLLER_PATH**
- app/views/**$PARENT_CONTROLLER_PATH**/**$ACTION_PREFIX** (it will keep going if there are more ancestor controllers)
- app/views/**$PARENT_CONTROLLER_PATH**
- app/views/**$THEME_NAME**/**$ACTION_PREFIX** - (since 5.2.0)
- app/views/**$THEME_NAME** - (since 5.2.0)
- app/views/wallaby/resources/**$ACTION_PREFIX** - (will not be applicable when **$THEME_NAME** is set)
- app/views/wallaby/resources - (will not be applicable when **$THEME_NAME** is set)

For example, for model `Product`, a Wallaby controller is declared as:

```ruby
# app/controllers/backend/goods_controller.rb
class Backend::GoodsController < Admin::ApplicationsController
  self.theme_name = 'foundation'
  self.model_class = Product
end
```

And given that:

- Wallaby is mounted under path `/manage` (see how Wallaby is mounted in [route](route.md)).
- action is `index`.

In this case, variables become:

- **$MOUNTED_PATH** is `manage` (from mount path `/manage`)
- **$ACTION_PREFIX** is `index` (converted from [action_name](https://api.rubyonrails.org/classes/AbstractController/Base.html#method-i-action_name), see below [Action Prefix Mapping](#action-prefix-mapping))
- **$RESOURCES** is `products` (plural model name of `Product`, see [URL naming convention](convention.md#url))
- **$CONTROLLER_PATH** is `backend/goods` ([controller_name](https://api.rubyonrails.org/classes/ActionController/Metal.html#method-c-controller_name) of `Backend::GoodsController`)
- **$PARENT_CONTROLLER_PATH** is `admin/application` ([controller_name](https://api.rubyonrails.org/classes/ActionController/Metal.html#method-c-controller_name) of `Admin::ApplicationController`)
- **$THEME_NAME** (since 5.2.0) is `foundation`

Then the cell and partial lookup order becomes:

- app/views/manage/products/index/markdown_html.rb _(cell)_
- app/views/manage/products/index/\_markdown.html.erb _(type partial)_
- app/views/manage/products/markdown_html.rb _(cell)_
- app/views/manage/products/\_markdown.html.erb _(type partial)_
- app/views/backend/goods/index/markdown_html.rb _(cell)_
- app/views/backend/goods/index/\_markdown.html.erb _(type partial)_
- app/views/backend/goods/markdown_html.rb _(cell)_
- app/views/backend/goods/\_markdown.html.erb _(type partial)_
- app/views/admin/application/index/markdown_html.rb _(cell)_
- app/views/admin/application/index/\_markdown.html.erb _(type partial)_
- app/views/admin/application/markdown_html.rb _(cell)_
- app/views/admin/application/\_markdown.html.erb _(type partial)_
- app/views/foundation/index/markdown_html.rb _(cell)_
- app/views/foundation/index/\_markdown.html.erb _(type partial)_
- app/views/foundation/markdown_html.rb _(cell)_
- app/views/foundation/\_markdown.html.erb _(type partial)_

> NOTE: as it can be seen above, the cell has higher precedence than the type partial.

Therefore, the cell/type partial can be created in one of the above paths depending on how it's shared:

- if the cell is only needed for model `Product` when no controller is created, then it can be created as:

  ```
  app/views/admin/products/index/markdown_html.rb (since 5.2.0)
  ```

  otherwise, for type partial:

  ```
  app/views/admin/products/index/_markdown.html.erb
  ```

- if the cell is only needed for controller `Backend::GoodsController`, then it can be created as:

  ```
  app/views/backend/goods/index/markdown_html.rb (since 5.2.0)
  ```

  otherwise, for type partial:

  ```
  app/views/backend/goods/index/_markdown.html.erb
  ```

- if the cell is supposed to be shared among the app, then it can be created as:

  ```
  app/views/admin/application/index/markdown_html.erb (since 5.2.0)
  ```

  otherwise, for type partial:

  ```
  app/views/admin/application/index/_markdown.html.erb
  ```

> NOTE: both locale and format can be included in file name. For example, to include locale `en` and format `json` for a cell, it goes as `app/views/admin/products/index/markdown_en_json.rb`; for type partial, it goes as `app/views/admin/products/index/_markdown.en.json.rb`.

> NOTE: for type partial, the file extension doesn't have to be `erb`, it's totally fine to create it with preferable markup language (e.g. `haml`/`slim`/etc.)

> NOTE: if CSV export feature is in use, two cell/type partials should be created for index, one for HTML and one for CSV.

### Action Prefix Mapping

The following resourceful actions are mapped to the action prefixes:

| Action  | Action Prefix |
| ------- | ------------- |
| index   | index         |
| new     | form          |
| create  | form          |
| show    | show          |
| edit    | form          |
| update  | form          |
| destroy | <N/A>         |

## Built-in Type Partials

### Association Type Partials

| Type Partial            | Available to Action Prefixes  | Metadata Options  |
| ----------------------- | ----------------------------- | ----------------- |
| belongs_to              | index, show, form             | options for **form**: <br> - `:polymorphic_list` - the list of polymorphic classes for this association. |
| has_one                 | index, show, form             | |
| has_many                | index, show, form             | |
| has_and_belongs_to_many | index, show, form             | |

### General Type Partials

> NOTE:

| Type Partial                  | Available to Action Prefixes  | Metadata Options |
| ----------------------------- | ----------------------------- | ---------------- |
| active_storage (since 5.2.0)  | index, show                   | |
| bigint                        | index, show, form             | |
| bigserial                     | index, show, form             | |
| binary                        | index, show, form             | |
| bit_varying                   | index, show, form             | |
| bit                           | index, show, form             | |
| blob                          | index, show, form             | |
| boolean                       | index, show, form             | |
| box                           | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| cidr                          | index, show, form             | |
| circle                        | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| citext                        | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| color                         | index, show, form             | |
| date                          | index, show, form             | |
| daterange                     | index, show, form             | |
| datetime                      | index, show, form             | |
| decimal                       | index, show, form             | |
| dropdown                      | form                          | options for **form**: <br> - `:choices` - choices for [ActionView::Helpers::FormBuilder#select](https://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-select). <br> - `:options` - options for [ActionView::Helpers::FormBuilder#select](https://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-select). <br>  - `:html_options` - html_options for [ActionView::Helpers::FormBuilder#select](https://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-select). |
| email                         | index, show, form             | |
| file                          | form                          | |
| float                         | index, show, form             | options for **form**: <br> - `:options` - options for [ActionView::Helpers::FormHelper#number_field](https://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html#method-i-number_field). |
| hstore                        | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| image                         | show                          | options for **show**: <br> - `:options` - options for [ActionView::Helpers::AssetTagHelper#image_tag](https://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-image_tag). |
| inet                          | index, show, form             | |
| int4range                     | index, show, form             | |
| int8range                     | index, show, form             | |
| integer                       | index, show, form             | |
| json                          | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| jsonb                         | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| line                          | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| link (since 5.1.9)            | index, show                   | options for **index**, **show**: <br> - `:title` - title of the link. <br> - `:html_options` - options for [ActionView::Helpers::UrlHelper.html#link_to](https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to)|
| longblob                      | index, show, form             | |
| longtext                      | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| lseg                          | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| ltree                         | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| macaddr                       | index, show, form             |
| markdown                      | form                          | |
| mediumblob                    | index, show, form             | |
| mediumtext                    | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| money                         | index, show, form             | |
| numrange                      | index, show, form             | |
| password                      | index, show, form             | |
| path                          | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| point                         | index, show, form             | |
| polygon                       | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| raw                           | index, show                   | |
| serial                        | index, show, form             | |
| sti                           | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. <br> options for **form**: <br> - `:sti_class_list` - list of STI classes for user to choose. |
| string                        | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| text                          | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| time                          | index, show, form             | |
| tinyblob                      | index, show, form             | |
| tinytext                      | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| tsrange                       | index, show, form             | |
| tstzrange                     | index, show, form             | |
| tsvector                      | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| unsigned_bigint               | index, show, form             | |
| unsigned_decimal              | index, show, form             | |
| unsigned_float                | index, show, form             | |
| unsigned_integer              | index, show, form             | |
| uuid                          | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| xml                           | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
