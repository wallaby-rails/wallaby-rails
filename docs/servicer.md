## Servicer

The purpose of using a servicer is to allow us to modify the persistence logics which shouldn't be taken care by the controllers. Customization can be done in the following methods:

- [`permit`](#permit)
- [`collection`](#collection)
- [`paginate`](#paginate)
- [`new`](#new)
- [`find`](#find)
- [`create`](#create)
- [`update`](#update)
- [`destroy`](#destroy)

Before digging into the above methods, let's see how to create a servicer so that Wallaby can pick it up:

### Declaration

```ruby
# app/servicers/product_servicer.rb

# NOTE: Product in ProductServicer is recommended to be singular
class ProductServicer < Wallaby::ModelServicer
end
```

If the name `ProductServicer` is taken, it is possible to use another name, however the method `self.model_class` must be defined to specify the model as example below:

```ruby
# app/servicers/admin/product_servicer.rb
class Admin::ProductServicer < Wallaby::ModelServicer
  def self.model_class
    Product
  end
end
```

### `permit`

This is the method that Wallaby autocompletes the whitelist parameters for mass assignment based on the existing fields. It can be overriden similar to [`resource_params`](controller.md#resource_params):

```ruby
class ProductServicer < Wallaby::ModelServicer
  def permit(params)
    params.require(:product).permit(:name, :sku)
  end
end
```

### `collection`

This is the method that returns a collection to be used for the frontend after all the query and sorting. It can be replaced as below:

```ruby
class ProductServicer < Wallaby::ModelServicer
  def collection(params)
    query = Product.where(nil)
    query = query.where('name ILIKE ?', params[:q]) if params[:q]
    query
  end
end
```

> NOTE: customizing the collection will impact both index page and autocomplete result.

### `paginate`

This method takes the collection and fulfils the pagination function if it's support. It can be overriden like:


```ruby
class ProductServicer < Wallaby::ModelServicer
  def paginate(query, params)
    query = query.at_page(params[:page]) if params[:page]
    query = query.per_page(params[:per]) if params[:per]
    query
  end
end
```

### `new`

This method takes the params and initiates an instance for the resource which will be used by the form. It can be overriden like:

```ruby
class ProductServicer < Wallaby::ModelServicer
  def new(params)
    Product.new(new_arrival: true)
  end
end
```

### `find`

This method finds the record and takes `id` and `params` for arguments. It can be overriden like:

```ruby
class SchemaServicer < Wallaby::ModelServicer
  def find(id, params)
    schema = Schema.where(version: id).first
    schema.location = params[:location]
    schema
  end
end
```

### `create`

This method will perform the save for given resource. It can be overriden like:

```ruby
class ProductServicer < Wallaby::ModelServicer
  def create(resource, params)
    resource.set_default_description_from params
    super
  end
end
```

### `update`

Similar to [`create`](#create), this method will perform the save for given resource. It can be overriden like:

```ruby
class ProductServicer < Wallaby::ModelServicer
  def update(resource, params)
    resource.set_default_description_from params
    super
  end
end
```

### `destroy`

This method will perform the deletion for given resource. It can be overriden like:

```ruby
class ProductServicer < Wallaby::ModelServicer
  def destroy(resource, params)
    super
    AuditLog.save_event params[:event], resource.attributes
  end
end
```
