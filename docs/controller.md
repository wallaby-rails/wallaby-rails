## Controller

In order to customize an action, we need to inherit the controller from `Wallaby::ResourcesController`. Then we could override the general resourceful actions (index/show/new/create/edit/update/destroy) or add an action:

```ruby
#!app/controllers/products_controller.rb
class ProductsController < Wallaby::ResourcesController
  # def index; super; end
  # def show; super; end
  # def new; super; end

  # @example override create action
  def create
    flash[:notice] = 'Create product is in progress'
    super
  end

  # def edit; super; end
  # def update; super; end
  # def destroy; super; end

  # @example new action
  def history
    fetch_data_audit_log
  end
end
```

In fact, `Wallaby::ResourcesController` inherits `ApplicationController`. Hence, all helper methods from `ApplicationController` will be available for any custom actions.

If `ProductsController` is already occupied for other purpose, we could use another name and specify the model class so that Wallaby could identify it:

```ruby
#!app/controllers/admin/products_controller.rb
class Admin::ProductsController < Wallaby::ResourcesController
  def self.model_class
    Product
  end
end
```
