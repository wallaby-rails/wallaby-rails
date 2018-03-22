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

In order to do authentication, Wallaby follows the common practice to execute `authenticate_user!` in before action callbacks and use `current_user` to return the user object. Therefore, there are two ways to set up authentication:

1. Simply tell Wallaby which controller to inherit from. The controller should have `authenticate_user!` and `current_user` implemented:

    ```ruby
    #!config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.base_controller = MySecurityController
    end
    ```

    Once this is set up, Wallaby will automatically pick up these two authentication methods mentioned above (which are compatible with Devise), along with all functionalities including application helpers, before_action, etc.

2. Authentication can be customized by configuring the `authenticate` and `current_user` (optional: `email_method`) options as per the example below:

    ```ruby
    #!config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.security.authenticate do
        # controller methods can be used inside this block
        authenticate_or_request_with_http_basic do |username, password|
          username == 'too_simple' && password == 'too_naive'
        end
      end

      config.security.current_user do
        # controller methods can be used inside this block
        Class.new do
          # email field is for gravator profile image
          def email
            'user@example.com'
          end
        end.new
      end

      # This will be used to retrieve the email from current_user above to show a gravatar image.
      # NOTE: this configuration is available from 5.1.4
      config.security.email_method = :email
    end
    ```

### Logging Out

> since 5.1.4

Wallaby doesn't do logout function. Instead, it sends user to logout route, by default, devise's `session#destroy` route.
Therefore, it provides two options if you are not using devise:

- `logout_path`: the name of the logout url helper. (available from 5.1.4)
- `logout_method`: the HTTP request verb for this logout url. (available from 5.1.4)

Given the following route:

```ruby
#!config/routes.rb
Rails.application.routes.draw do
  delete 'logout', to: 'sessions#destroy', as: :logging_out
end
```

Then configuration should go:

```ruby
#!config/initializers/wallaby.rb
Wallaby.config do |c|
  c.security.logout_path = 'logging_out_path'
  # or
  c.security.logout_path = 'logging_out_url'
  c.security.logout_method = 'delete'
end
```

### Authorization

Wallaby supports Cancancan, please see its [documentation](https://github.com/CanCanCommunity/cancancan/wiki) to find out how to set up authorization to restrict end-users from accessing/editing/deleting a model.

### Models

What models Wallaby should be handling with can be configured in the following two ways:

1. Blacklist the models that Wallaby shouldn't even display:

    ```ruby
    #!config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.models.exclude User, Organization
      # or
      # config.models.exclude 'User', 'Organization'
      # or
      # config.models.exclude [User, Organization]
      # or
      # config.models.exclude ['User', 'Organization']
    end
    ```

2. Whitelist the models that Wallaby should take care of:

    > NOTE: once the white list is defined, Wallaby will ignore the black list above.

    ```ruby
    #!config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.models = [User, Organization]
      # or
      # config.models = 'User', 'Organization'
      # or
      # config.models = [User, Organization]
      # or
      # config.models = ['User', 'Organization']
    end
    ```
### Mapping

> since 5.1.6

If global changes are needed for controllers/decorators/paginators/servicers, it can be done as below:

#### For controller

A global controller needs to be created inheriting from `Wallaby::ResourcesController`:

```
class GlobalController < Wallaby::ResourcesController
  # You don't need to define the `self.model_class`
end
```

And a configuration to tell Wallaby to use this controller needs to go in `config/initializers/wallaby.rb`:

```
Wallaby.config do |config|
  config.mapping.resources_controller = GlobalController
end
```

#### For decorator

A global decorator needs to be created inheriting from `Wallaby::ResourceDecorator`:

```
class GlobalDecorator < Wallaby::ResourceDecorator
  # You don't need to define the `self.model_class`
end
```

And a configuration to tell Wallaby to use this decorator needs to go in `config/initializers/wallaby.rb`:

```
Wallaby.config do |config|
  config.mapping.resources_controller = GlobalDecorator
end
```

#### For paginator

A global paginator needs to be created inheriting from `Wallaby::ResourcePaginator`:

```
class GlobalPaginator < Wallaby::ResourcePaginator
  # You don't need to define the `self.model_class`
end
```

And a configuration to tell Wallaby to use this paginator needs to go in `config/initializers/wallaby.rb`:

```
Wallaby.config do |config|
  config.mapping.resources_controller = GlobalPaginator
end
```

#### For servicer

A global servicer needs to be created inheriting from `Wallaby::ModelServicer`:

```
class GlobalServicer < Wallaby::ModelServicer
  # You don't need to define the `self.model_class`
end
```

And a configuration to tell Wallaby to use this servicer needs to go in `config/initializers/wallaby.rb`:

```
Wallaby.config do |config|
  config.mapping.resources_controller = GlobalServicer
end
```

### Metadata

Be able to configure global metadata that Wallaby should use as default value when decorator-defined metadata is absent. For now, it has only one option:

- To configure the max length that Wallaby should truncate to when given text is longer than defined:

    ```ruby
    #!config/initializers/wallaby.rb
    Wallaby.config do |config|
      # if not set, default is 20
      config.metadata.max = 300
    end
    ```

### Pagination

It has only one option so far:

- To configure the default page size that Wallaby should use as default:

    ```ruby
    #!config/initializers/wallaby.rb
    Wallaby.config do |config|
      # if not set, default is 20
      config.pagination.page_size = 100
    end
    ```

### Features

It has only one option so far:

- Wallaby supports turbolinks, to enable it, it needs to be configured:

    ```ruby
    #!config/initializers/wallaby.rb
    Wallaby.config do |config|
      # if not set, default is false
      config.features.turbolinks_enabled = true
    end
    ```

    And make sure that `turbolinks` gem is added in `Gemfile`
