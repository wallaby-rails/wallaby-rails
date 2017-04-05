## View

It is easy to customize how a field should be rendered since we use partials.

### Index / show partials

In the following example, we will change product description to be rendered using markdown on index page:

First of all, change its type in its decorator:

```ruby
#!app/decorators/product_decorator.rb
class ProductDecorator < Wallaby::ResourceDecorator
  self.index_fields[:description][:type] = 'markdown'
end
```

Then we need to add a partial for it. Depends on how we want it to be shared, the partial can be created in one of the following paths:

1. If the partial is only for this specific controller and action, create it as:
    ```
    app/views/admin/products/index/_markdown.html.erb
    ```

2. If it can be shared between `index`, `show` and `form`, it can be created as:
    ```
    app/views/admin/products/_markdown.html.erb
    ```

3. If it can be shared across all controllers, but only for index, it should be placed as:
    ```
    app/views/wallaby/resources/index/_markdown.html.erb
    ```

4. If it is globally shared across all controllers and actions, it should go as:
    ```
    app/views/wallaby/resources/_markdown.html.erb
    ```

Then we create the partial with following content:

```erb
<%= markdown.render value  %>
```

Note that for index and show partial, we will have access to the following variables:

- `object`: the decorator object which wraps the resource object
- `field_name`: current field name
- `value`: current value
- `metadata`: metadata for current field

### Form partials for new / create / edit / update

Similar to the above example of `index`, we will change product description to be rendered using markdown for form editing:

First of all, change its type in its decorator:

```ruby
#!app/decorators/product_decorator.rb
class ProductDecorator < Wallaby::ResourceDecorator
  self.form_fields[:description][:type] = 'markdown'
end
```

Then we could create the partial in one of the following paths:

```
app/views/admin/products/form/_markdown.html.erb
app/views/admin/products/_markdown.html.erb
app/views/wallaby/resources/form/_markdown.html.erb
app/views/wallaby/resources/_markdown.html.erb
```

Then we create the partial with following content:

```erb
<div class="form-group <%= form.error_class field_name %>">
  <%= form.label field_name, metadata[:label] %>
  <%= form.text_field field_name, class: 'form-control markdown-editing' %>
  <%= form.error_messages field_name %>
</div>
```

Note that for form partial, we will have access to the following variables:

- `form`: the instance of `Wallaby::FormBuilder` which provides additional helper methods for error class and error messages
- `object`: the decorator object which wraps the resource object
- `field_name`: current field name
- `value`: current value
- `metadata`: metadata for current field
