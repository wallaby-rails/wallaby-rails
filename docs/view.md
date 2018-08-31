# View

In Wallaby, the core of the view is to iterate the fields defined in decorator's **\*_field_names** and render the partial using type from decorator's metadata **\*_fields**. For example, for index page, the core looks like:

```erb
<%= index_field_names.each do |field_name| %>
  <%= render index_fields[field_name][:type], value: value %>
<% end %>
```

Learn about Type Partial from the following sections:

- [Creating a Type Partial](#creating-a-type-partial)
- [Locals for Type Partials](#locals-for-type-partials) - to learn the local variables available in type partials

See the index for built-in type partials:

- [Association Type Partials](#association-type-partials)
- [General Type Partials](#general-type-partials)

> See [Decorator](decorator.md) to learn more about the metadata.

## Type Partial

As described above, if a custom type is defined in decorator, e.g. `:markdown`, then a partial needs to be created accordingly, and this partial is called `Type Partial`.

### Creating a Type Partial

Wallaby utilizes and extends [Template Inheritance](https://guides.rubyonrails.org/layouts_and_rendering.html#template-inheritance) to look for type partial in controller and action inheritance chain like:

- app/views/**$MOUNTED_PATH**/**$RESOURCES**/**$ACTION_PREFIX**
- app/views/**$MOUNTED_PATH**/**$RESOURCES**
- app/views/**$CONTROLLER_PATH**/**$ACTION_PREFIX**
- app/views/**$CONTROLLER_PATH**
- app/views/**$BASE_CONTROLLER_PATH**/**$ACTION_PREFIX**
- app/views/**$BASE_CONTROLLER_PATH**
- app/views/**$THEME_NAME**/**$ACTION_PREFIX** - (since 5.2.0)
- app/views/**$THEME_NAME** - (since 5.2.0)
- app/views/wallaby/resources/**$ACTION_PREFIX**
- app/views/wallaby/resources

For example, for model `Product`, a Wallaby controller is declared as:

```ruby
# app/controllers/backend/goods_controller.rb
class Backend::GoodsController < Admin::ApplicationsController
  self.theme_name = 'foundation'
  self.model_class = Product
end
```

And given that:

- Wallaby is mounted under path `/admin` (see how Wallaby is mounted in [route](route.md)).
- action is `index`.

So the variables become:

- **$MOUNTED_PATH** is `admin` (converted from `/admin`)
- **$ACTION_PREFIX** is `index` (converted from action `index`, see below [Action Prefix Mapping](#action-prefix-mapping))
- **$RESOURCES** is `products` (converted from model `Product`)
- **$CONTROLLER_PATH** is `backend/goods` (converted from controller `Backend::GoodsController`) .0) is `admin/application` (converted from controller `Admin::ApplicationController`)
- **$THEME_NAME** (since 5.2.0) is `foundation`

Then the lookup order for type partial becomes:

- app/views/admin/products/index/_markdown
- app/views/admin/products/_markdown
- app/views/backend/goods/index/_markdown
- app/views/backend/goods/_markdown
- app/views/admin/application/index/_markdown
- app/views/admin/application/_markdown
- app/views/foundation/index/_markdown
- app/views/foundation/_markdown
- app/views/wallaby/resources/index/_markdown
- app/views/wallaby/resources/_markdown

Therefore, the type partial can be created in one of the above paths depending on how it should be shared:

- if the type partial is only needed for model `Product` when no controller is created, then it can be created as:

  ```
  app/views/admin/products/index/_markdown.html.erb
  ```

- if the type partial is only needed for controller `Backend::GoodsController`, then it can be created as:

  ```
  app/views/backend/goods/index/_markdown.html.erb
  ```

- if the type partial is supposed to be shared among the app, then it can be created as:

  ```
  app/views/admin/application/index/_markdown.html.erb
  ```

> NOTE: the file extension doesn't have to be `erb`, it's totally fine to create type partial with preferred markup language (e.g. `haml`/`slim`/etc.)

> ANOTHER NOTE: if CSV export feature is in use, then two type partials should be created for index, one is HTML, the other is CSV.

### Locals for Type Partials

To develop type partial, it's as easy as normal partial. However, it's better to get familiar with the following locals available in a type partial:

- `object`: the decorator instance which wraps the resource object.
- `field_name`: current field name.
- `value`: current value.
- `metadata`: metadata for current field.

In addition to the above locals, `form` type partial has access to the following locals:

- `form`: a form builder instance that extends `ActionView::Helpers::FormBuilder` to provide extra helper methods for error display.

Let's take a look at an example of how built-in type partial (`form`/`string`) is coded:

```erb
<%# app/views/wallaby/resources/form/_string.html.erb
%>
<div class="form-group <%= form.error_class field_name %>">
  <%= form.label field_name, metadata[:label] %>
  <div class="row">
    <div class="col-xs-12">
      <%= form.text_field field_name, class: 'form-control' %>
    </div>
  </div>
  <%= form.error_messages field_name %>
  <%= hint_of metadata %>
</div>
```

### Action Prefix Mapping

The following resourcesful actions are mapped to the action prefixes:

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

| Type Partial      | Available to Action Prefixes  | Metadata Options |
| ----------------- | ----------------------------- | ---------------- |
| bigint            | index, show, form             | |
| bigserial         | index, show, form             | |
| binary            | index, show, form             | |
| bit_varying       | index, show, form             | |
| bit               | index, show, form             | |
| blob              | index, show, form             | |
| boolean           | index, show, form             | |
| box               | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| cidr              | index, show, form             | |
| circle            | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| citext            | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| color             | index, show, form             | |
| date              | index, show, form             | |
| daterange         | index, show, form             | |
| datetime          | index, show, form             | |
| decimal           | index, show, form             | |
| dropdown          | form                          | options for **form**: <br> - `:choices` - choices for [ActionView::Helpers::FormBuilder#select](https://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-select). <br> - `:options` - options for [ActionView::Helpers::FormBuilder#select](https://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-select). <br>  - `:html_options` - html_options for [ActionView::Helpers::FormBuilder#select](https://api.rubyonrails.org/classes/ActionView/Helpers/FormBuilder.html#method-i-select). |
| email             | index, show, form             | |
| file              | form                          | |
| float             | index, show, form             | options for **form**: <br> - `:options` - options for [ActionView::Helpers::FormHelper#number_field](https://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html#method-i-number_field). |
| hstore            | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| image             | show                          | options for **show**: <br> - `:options` - options for [ActionView::Helpers::AssetTagHelper#image_tag](https://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-image_tag). |
| inet              | index, show, form             | |
| int4range         | index, show, form             | |
| int8range         | index, show, form             | |
| integer           | index, show, form             | |
| json              | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| jsonb             | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| line              | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| longblob          | index, show, form             | |
| longtext          | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| lseg              | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| ltree             | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| macaddr           | index, show, form             |
| markdown          | form                          | |
| mediumblob        | index, show, form             | |
| mediumtext        | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| money             | index, show, form             | |
| numrange          | index, show, form             | |
| password          | index, show, form             | |
| path              | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| point             | index, show, form             | |
| polygon           | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| raw               | index, show                   | |
| serial            | index, show, form             | |
| sti               | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. <br> options for **form**: <br> - `:sti_class_list` - list of STI classes for user to choose. |
| string            | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| text              | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| time              | index, show, form             | |
| tinyblob          | index, show, form             | |
| tinytext          | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| tsrange           | index, show, form             | |
| tstzrange         | index, show, form             | |
| tsvector          | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| unsigned_bigint   | index, show, form             | |
| unsigned_decimal  | index, show, form             | |
| unsigned_float    | index, show, form             | |
| unsigned_integer  | index, show, form             | |
| uuid              | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
| xml               | index, show, form             | options for **index**: <br> - `:max` - truncate text at max length. |
