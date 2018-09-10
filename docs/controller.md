# Controller

> NOTE: this is a documentation for 5.2.0 and above, if Wallaby version is under 5.2.0, please see this [document for 5.1 and below](controller.5.1.md).

Wallaby places controller logics in a custom controller same as what Rails does. Therefore, apart from adding functions to support Wallaby, Wallaby controllers are Rails controllers.

First of all, it's always recommended to create a base controller class `Admin::ApplicationController` as below, so that devs can have better control of developing global changes/functions:

```ruby
# app/controllers/admin/application_controller.rb
class Admin::ApplicationController < Wallaby::ResourcesController
end
```

> See [Mapping - Controller](configuration.md#controller) for the configuration if `Admin::ApplicationController` is taken for other purpose.

Starting with:

- [Declaration](#declaration)

Configuration can be set for:

- [abstract!](#abstract) - flagging as abstract base class.
- [model_class](#model_class) - specifying the model class.

The following resourcesful actions can be customized:

- [index](#index) - collection listing page.
- [new](#new) - resource form for creation.
- [create](#create) - handling resource creation.
- [show](#show) - single resource display page.
- [edit](#edit) - resource form for editing.
- [update](#update) - handling resource update.
- [destroy](#destroy) - handling resource deletion.

Also it is possible to:

- [resource_params](#resource_params) - to customize the white-listed parameters for mass assignment.

Customize non-resourcesful actions:

- [home](#home) (5.1.0) - to customize landing page.

More advanced configuration:

- [theme_name](advanced_controller.md#theme_name) (since 5.2.0) - specifying the theme.
- [engine_name](advanced_controller.md#engine_name) (since 5.2.0) - specifying the name of engine helper.
- [application_decorator](advanced_controller.md#application_decorator) (since 5.2.0) - specifying the base resource decorator class.
- [resource_decorator](advanced_controller.md#resource_decorator) (since 5.2.0) - specifying the resource decorator class.
- [application_servicer](advanced_controller.md#application_servicer) (since 5.2.0) - specifying the base model servicer class.
- [model_servicer](advanced_controller.md#model_servicer) (since 5.2.0) - specifying the model servicer class.
- [application_authorizer](advanced_controller.md#application_authorizer) (since 5.2.0) - specifying the base model authorizer class.
- [model_authorizer](advanced_controller.md#model_authorizer) (since 5.2.0) - specifying the model authorizer class.
- [application_paginator](advanced_controller.md#application_paginator) (since 5.2.0) - specifying the base model paginator class.
- [model_paginator](advanced_controller.md#model_paginator) (since 5.2.0) - specifying the model paginator class.

Other customization:

- [View Helpers](#view-helpers)

## Declaration

> Read more at [Controller Naming Convention](convention.md#controller)

Let's see how a controller can be created so that Wallaby knows its existence.

Similar to the way in Rails, create a custom controller for model `Product` inheriting from `Admin::ApplicationController` (the base controller mentioned [above](#controller)) as below:

```ruby
# app/controllers/products_controller.rb
class ProductsController < Admin::ApplicationController
end
```

> NOTE: although it inherits from `Admin::ApplicationController`, it is possible to access to all methods in `::ApplicationController`. Because `Admin::ApplicationController` inherits from `ApplicationController` unless this is changed in Wallaby [authentication configuration](configuration.md#authentication).

If `ProductsController` is taken, it is still possible to use another name (e.g. `Admin::ProductsController`). However, the attribute `model_class` must be specified. See [`model_class`](#model_class) for examples.

## abstract!

All controllers will be preloaded and processed by Wallaby in order to build up the mapping between controllers and models. If the controller is considered not to be proceesed, it can be flagged by using `abstract!`:

```ruby
# app/controllers/admin/special_controller.rb
class Admin::SpecialController < Admin::ApplicationController
  abstract!
end
```

## model_class

According to Wallaby's [Controller Naming Convention](convention.md#controller), if a custom controller can not reflect the assication to the correct model, for example, as `Admin::ProductsController` to `Product`, it is required to specify the model class in the controller as below:

```ruby
# app/controllers/admin/products_controller.rb
class Admin::ProductsController < Admin::ApplicationController
  self.model_class = Product
end
```

For version below 5.2.0, it is:

```ruby
# app/controllers/admin/products_controller.rb
class Admin::ProductsController < Admin::ApplicationController
  def self.model_class
    Product
  end
end
```

# Basic Customization

## index

- To add functionality before the action, it is fine to either use `before_action` or be overridden as:

  ```ruby
  def index
    # do something here
    # to access the records, use `collection`
    collection
    # to re-assign the collection, assign to `@collection`
    @collection = @collection.where created_at: Date.today
    super
  end
  ```

- To add functionality after the action but before rendering, it goes:

  ```ruby
  def index
    super do
      # do something here before rendering
    end
  end
  ```

Basically, the action is as simple as:

```ruby
def index
  current_authorizer.authorize :index, current_model_class
  yield if block_given? # after_index
  respond_with collection
end
```

It can be completely replaced like:

```ruby
def index
  @collection = Product.all
end
```

> NOTE: `@collection` MUST be assigned, because it's the only instance variable used in the view.

## new

- To add functionality before the action, it is fine to either use `before_action` or be overridden as:

  ```ruby
  def new
    # do something here
    # to access the record, use `resource`
    resource
    # to re-assign the resource, assign to `@resource`
    @resource = Product.new new_arrival: true
    super
  end
  ```

- To add functionality after the action but before rendering, it goes:

  ```ruby
  def new
    super do
      # do something here before rendering
    end
  end
  ```

Basically, the action is as simple as:

```ruby
def new
  current_authorizer.authorize :new, resource
  yield if block_given? # after_new
  respond_with resource
end
```

It can be completely replaced like:

```ruby
def new
  @resource = Product.new new_arrival: true
end
```

> NOTE: `@resource` MUST be assigned, because it's the only instance variable used in the view.

## create

> NOTE: `create` action works differently since 5.2.0. See below and the [Controller for 5.1 and below](controller.5.1.md).

- To add functionality before the action, it is fine to either use `before_action` or be overridden as:

  ```ruby
  def create
    # do something here before saving the record
    # to access the record, use `resource`
    resource
    # to re-assign the resource, assign to `@resource`
    @resource = Product.new new_arrival: true
    super
  end
  ```

- To add functionality after the action but before rendering, it goes:

  ```ruby
  def create
    super do
      # do something here before rendering
    end
  end
  ```

Basically, the action is as simple as:

```ruby
def create
  current_authorizer.authorize :create, resource
  # NOTE: Instead of using `params`, `resource_params` is used since 5.2.0.
  # It means the mass assignment happens in servicer's `create` method rather than servicer's `new` method.
  current_servicer.create resource, resource_params
  yield if block_given? # after_create
  respond_with resource, location: helpers.show_path(resource)
end
```

It can be completely replaced like:

```ruby
def create
  @resource = Product.create(resource_params.merge new_arrival: true)
end
```

> NOTE: `@resource` MUST be assigned, because it's the only instance variable used in the view.

## show

- To add functionality before the action, it is fine to either use `before_action` or be overridden as:

  ```ruby
  def show
    # do something here
    # to access the record, use `resource`
    resource
    # to re-assign the resource, assign to `@resource`
    @resource = Product.first
    super
  end
  ```

- To add functionality after the action but before rendering, it goes:

  ```ruby
  def show
    super do
      # do something here before rendering
    end
  end
  ```

Basically, the action is as simple as:

```ruby
def show
  current_authorizer.authorize :show, resource
  yield if block_given? # after_show
  respond_with resource
end
```

It can be completely replaced like:

```ruby
def show
  @resource = Product.friendly.find params[:id]
end
```

> NOTE: `@resource` MUST be assigned, because it's the only instance variable used in the view.

## edit

- To add functionality before the action, it is fine to either use `before_action` or be overridden as:

  ```ruby
  def edit
    # do something here
    # to access the record, use `resource`
    resource
    # to re-assign the resource, assign to `@resource`
    @resource = Product.find_by(id: param[:id], owner_id: current_user.id)
    super
  end
  ```

- To add functionality after the action but before rendering, it goes:

  ```ruby
  def edit
    super do
      # do something here before rendering
    end
  end
  ```

Basically, the action is as simple as:

```ruby
def edit
  current_authorizer.authorize :edit, resource
  yield if block_given? # after_edit
  respond_with resource
end
```

It can be completely replaced like:

```ruby
def edit
  @resource = Product.friendly.find params[:id]
end
```

> NOTE: `@resource` MUST be assigned, because it's the only instance variable used in the view.

## update

> NOTE: `update` action works differently since 5.2.0. See below and the [Controller for 5.1 and below](controller.5.1.md).

- To add functionality before the action, it is fine to either use `before_action` or be overridden as:

  ```ruby
  def update
    # do something here before saving the record
    # to access the record, use `resource`
    resource
    # to re-assign the resource, assign to `@resource`
    @resource = Product.friendly.find params[:id]
    @resource.assign_attributes resource_params
    super
  end
  ```

- To add functionality after the action but before rendering, it goes:

  ```ruby
  def update
    super do
      # do something here before rendering
    end
  end
  ```

Basically, the action is as simple as:

```ruby
def update
  current_authorizer.authorize :update, resource
  # NOTE: Instead of using `params`, `resource_params` is used since 5.2.0.
  # It means the mass assignment happens in servicer's `update` method rather than servicer's `find` method.
  current_servicer.update resource, resource_params
  yield if block_given? # after_update
  respond_with resource, location: helpers.show_path(resource)
end
```

It can be completely replaced like:

```ruby
def update
  @resource = Product.friendly.find params[:id]
  @resource.update resource_params
end
```

> NOTE: `@resource` MUST be assigned, because it's the only instance variable used in the view.

## destroy

- To add functionality before the action, it is fine to either use `before_action` or be overridden as:

  ```ruby
  def destroy
    # do something here before saving the record
    # to access the record, use `resource`
    resource
    # to re-assign the resource, assign to `@resource`
    @resource = Product.friendly.find params[:id]
    super
  end
  ```

- To add functionality after the action but before rendering, it goes:

  ```ruby
  def destroy
    super do
      # do something here before rendering
    end
  end
  ```

Basically, the action is as simple as:

```ruby
def destroy
  current_authorizer.authorize :destroy, resource
  current_servicer.destroy resource, params
  yield if block_given? # after_destroy
  respond_with resource, location: helpers.index_path(current_model_class)
end
```

It can be completely replaced like:

```ruby
def destroy
  @resource = Product.friendly.find params[:id]
  @resource.destroy
end
```

> NOTE: `@resource` MUST be assigned, because it's the only instance variable used in the view.

## resource_params

Basically, the action is as simple as:

```ruby
def resource_params
  @resource_params ||= current_servicer.permit params, action_name
end
```

To customize the parameters to be whitelisted for create and update, it can be overridden:

```ruby
def resource_params
  params.require(:product).permit(:name, :sku)
end
```

## home

> since 5.1.0

`home` action is basically a blank action which renders the `home` template as the landing page of Wallaby (the root_path of where Wallaby engine is mounted) (available since 5.1.0):

```ruby
def home
  # do nothing
end
```

It can be completely replaced like:

```ruby
def home
  @reports = build_reports
end
```

# Others

## View Helpers

Developing view helpers is the same as developing Rails view helpers:

```ruby
# app/helpers/admin/products_helper.rb
class Admin::ProductsHelper
  def custom_method
    # imagine it's doing something
  end
end

# app/controllers/admin/products_controller.rb
class Admin::ProductsController < Admin::ApplicationController
  self.model_class = Product
end
```
