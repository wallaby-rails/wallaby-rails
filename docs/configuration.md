## Configuration

All configuration should go into `config/initializers/wallaby.rb`. See the following sections for the configuration that you are looking for.

- [Authentication](#authentication)
- [Logging Out](#logging-out) (since 5.1.4)
- [Authorization](#authorization)
- [Models](#models)
- [Mapping](#mapping) (since 5.1.6)
- [Metadata](#metadata)
- [Pagination](#pagination)
- [Features](#features)

### Authentication

Wallaby follows the common authentication practice to execute `authenticate_user!` in `before_action` callbacks and use `current_user` to return the user object. Therefore, there are three ways to set up authentication:

1. (since 5.1.6) Declare an [`Admin::ApplicationController`](#mapping), and define methods `authenticate_user!` and `current_user`:

    ```ruby
    # app/controllers/admin/application_controller.rb
    class Admin::ApplicationController < Wallaby::ResourcesController
      def authenticate_user!
        # http basic authentication
        authenticate_or_request_with_http_basic do |username, password|
          username == 'too_simple' && password == 'too_naive'
        end
      end

      def current_user
        # user example
        Class.new do
          def email
            'user@example.com'
          end
        end.new
      end
    end

    ```

2. Authentication can be customized by configuring the `authenticate` and `current_user` (optional: `email_method`) options as per the example below:

    - `authenticate`: a block that will be executed by controller to do authenticate. (inside this block, you have access to all controller methods.)
    - `current_user`: a block that retrieve current user instance. (inside this block, you have access to all controller methods.)
    - `email_method`: (since 5.1.4) method name (string or symbol) that returns email from `current_user`. and this email information will be used to load gravatar profile image. Default is `:email`

    ```ruby
    # config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.security.authenticate do
        # http basic authentication
        authenticate_or_request_with_http_basic do |username, password|
          username == 'too_simple' && password == 'too_naive'
        end
      end

      config.security.current_user do
        # user example
        Class.new do
          def email
            'user@example.com'
          end
        end.new
      end

      # NOTE: this configuration is available from 5.1.4
      config.security.email_method = :email
    end
    ```

3. Simply tell Wallaby which controller to inherit from. The controller should have `authenticate_user!` and `current_user` implemented:

    ```ruby
    # config/initializers/wallaby.rb
    Wallaby.config do |config|
      # if base_controller's not set, it defaults to `::ApplicationController`
      config.base_controller = MySecurityController
    end
    ```

    Once this is set up, Wallaby will automatically pick up these two authentication methods mentioned above (which are compatible with Devise), along with all functionalities including application helpers, before_action, etc.

### Logging Out

> since 5.1.4

Wallaby doesn't do logout function. Instead, it sends user to logout route (by default, it is devise's `session#destroy` route).
If you are not using devise, you will have the following two options:

- `logout_path`: name of the logout path/url helper. (available from 5.1.4)
- `logout_method`: the HTTP request verb for this logout route. (available from 5.1.4)

Given the following route:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  post 'logout', to: 'users#sign_out', as: :sign_out_now
end
```

Then configuration should go:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |c|
  # `logout_path` can be set to the url helper name for the name route above
  # e.g. `logging_out_path` or `logging_out_url`
  c.security.logout_path = 'sign_out_now_path'
  c.security.logout_method = 'post'
end
```

### Authorization

Wallaby supports Cancancan, please see its [documentation](https://github.com/CanCanCommunity/cancancan/wiki) to find out how to set up authorization to restrict end-users from accessing/editing/deleting a model.

### Models

What models Wallaby should be handling can be configured in the following two ways:

1. Blacklist the models that Wallaby shouldn't handle:

    ```ruby
    # config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.models.exclude User, Organization
      # or it accepts strings
      config.models.exclude 'User', 'Organization'
      # or it accepts an array of classes
      config.models.exclude [User, Organization]
      # or it accepts an array of strings
      config.models.exclude ['User', 'Organization']
    end
    ```

2. Whitelist the models that Wallaby should handle:

    > NOTE: once the whitelist is defined, Wallaby will ignore the blacklist above.

    ```ruby
    # config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.models = [User, Organization]
      # or it accepts strings
      config.models = 'User', 'Organization'
      # or it accepts an array of classes
      config.models = [User, Organization]
      # or it accepts an array of strings
      config.models = ['User', 'Organization']
    end
    ```

### Mapping

> since 5.1.6

It's always recommended to use a global class so that monkey patching to wallaby gem can be avoided. This can be done for the following things:

- [Controller](#controller)
- [Decorator](#decorator)
- [Paginator](#paginator)
- [Servicer](#servicer)

#### Controllers

> see [Customization in Controller](controller.md) if you want to know how controllers can be customized.

A global controller `Admin::ApplicationController` needs to be created inheriting from `Wallaby::ResourcesController`:

```ruby
# app/controllers/admin/application_controller.rb
class Admin::ApplicationController < Wallaby::ResourcesController
  # Do something globally, for example
  before_action do
    session[:time_zone] ||= params[:time_zone]
  end
end
```

Then the other controllers can inherit from it:

```ruby
# app/controllers/admin/products_controller.rb
class Admin::ProductsController < Admin::ApplicationController
  def self.model_class; Product; end
end
```

If `Admin::ApplicationController` is taken or other name is preferred, for example, `GlobalController`:

```ruby
# app/controllers/global_controller.rb
class GlobalController < Wallaby::ResourcesController
end
```

Then configuration is required so that Wallaby can pick it up:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  config.mapping.resources_controller = GlobalController
end
```

#### Decorator

> see [Customization in Decorator](decorator.md) if you want to know how decorators can be customized.

A global decorator `Admin::ApplicationDecorator` needs to be created inheriting from `Wallaby::ResourceDecorator`:

```ruby
# app/decorators/admin/application_decorator.rb
class Admin::ApplicationDecorator < Wallaby::ResourceDecorator
end
```

Then the other decorators can inherit from it:

```ruby
# app/decorators/admin/product_decorator.rb
class Admin::ProductDecorator < Admin::ApplicationDecorator
  def self.model_class; Product; end
end
```

If `Admin::ApplicationDecorator` is taken or other name is preferred, for example, `GlobalDecorator`:

```ruby
# app/decorators/global_decorator.rb
class GlobalDecorator < Wallaby::ResourceDecorator
end
```

Then configuration is required so that Wallaby can pick it up:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  config.mapping.resource_decorator = GlobalDecorator
end
```

#### Paginator

> see [Customization in Paginator](paginator.md) if you want to know how paginators can be customized.

A global paginator `Admin::ApplicationPaginator` needs to be created inheriting from `Wallaby::ModelPaginator`:

```ruby
# app/paginators/admin/application_paginator.rb
class Admin::ApplicationPaginator < Wallaby::ModelPaginator
end
```

Then the other paginators can inherit from it:

```ruby
# app/paginators/admin/product_paginator.rb
class Admin::ProductPaginator < Admin::ApplicationPaginator
  def self.model_class; Product; end
end
```

If other class name is preferred, for example, `GlobalPaginator`:

```ruby
# app/paginators/global_paginator.rb
class GlobalPaginator < Wallaby::ModelPaginator
end
```

Then configuration is required so that Wallaby can pick it up:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  config.mapping.model_paginator = GlobalPaginator
end
```

#### Servicer

> see [Customization in Servicer](servicer.md) if you want to know how servicers can be customized.

A global servicer `Admin::ApplicationServicer` needs to be created inheriting from `Wallaby::ModelServicer`:

```ruby
# app/servicers/admin/application_servicer.rb
class Admin::ApplicationServicer < Wallaby::ModelServicer
end
```

Then the other servicers can inherit from it:

```ruby
# app/servicers/admin/product_servicer.rb
class Admin::ProductServicer < Admin::ApplicationServicer
  def self.model_class; Product; end
end
```

If other class name is preferred, for example, `GlobalServicer`:

```ruby
# app/servicers/global_servicer.rb
class GlobalServicer < Wallaby::ModelServicer
end
```

Then configuration is required so that Wallaby can pick it up:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  config.mapping.model_servicer = GlobalServicer
end
```

### Metadata

Be able to configure global metadata that Wallaby should use as default value when decorator-defined metadata is absent. For now, it has only one option:

- To configure the max length that Wallaby should truncate to when given text is longer than defined:

    ```ruby
    # config/initializers/wallaby.rb
    Wallaby.config do |config|
      # if not set, default is 20
      config.metadata.max = 300
    end
    ```

### Pagination

It has only one option so far:

- To configure the default page size that Wallaby should use as default:

    ```ruby
    # config/initializers/wallaby.rb
    Wallaby.config do |config|
      # if not set, default is 20
      config.pagination.page_size = 100
    end
    ```

### Features

It has only one option so far:

- Wallaby supports turbolinks, to enable it, it needs to be configured:

    ```ruby
    # config/initializers/wallaby.rb
    Wallaby.config do |config|
      # if not set, default is false
      config.features.turbolinks_enabled = true
    end
    ```

    And make sure that `turbolinks` gem is added in `Gemfile`
