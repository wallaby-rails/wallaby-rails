# Configuration

All the global configuration goes into file `config/initializers/wallaby.rb`.

- [Authentication](#authentication)
  - [authenticate](#authenticate) - authenticate a user (by default, it does nothing).
  - [current_user](#current_user) - returns the signed in user instance (default to return `nil`).
  - [email_method](#email_method) (since 5.1.4) - specifies the method name which returns the user's email address for avatar display (default to `:email`).
  - [logout_path](#logout_path) (since 5.1.4) - specifies the url helper name for signing out a user (default to Devise's `"destroy_#{user_scope}_session_path"`).
  - [logout_method](#logout_method) (since 5.1.4) - specifies the http method for signing out a user (default to Devise's `mapping.sign_out_via`).
- [Controller](#controller)
  - [base_controller](#base_controller) - specifies the base class that [Wallaby::ResourcesController](https://www.rubydoc.info/gems/wallaby/Wallaby/ResourcesController) **inherits from**.
- [Model](#model)
  - [exclude](#exclude) - excludes models.
  - [models=](#models) - whitelists models.
- [Mapping](#mapping) (since 5.1.6)
  - [resources_controller](#resources_controller) - specifies base controller class that **inherits from** [Wallaby::ResourcesController](https://www.rubydoc.info/gems/wallaby/Wallaby/ResourcesController).
  - [resource_decorator](#resource_decorator) - specifies base decorator class that **inherits from** .
  - [model_servicer](#model_servicer) - how to declare and set base servicer class.
  - [model_authorizer](#model_authorizer) (since 5.2.0) - how to declare and set base authorizer class.
  - [model_paginator](#model_paginator) - how to declare and set base paginator class.
- [Metadata](#metadata)
  - [max](#max) - setting the max length for text truncation.
- [Pagination](#pagination)
  - [page_size](#page_size) - setting the default page size for pagination.
- [Features](#features)
  - [turbolinks_enabled](#turbolinks-enabled) - enable/disable `turbolinks`.
- [Sorting](#sorting)
  - [strategy](#strategy) (since 5.2.0) - multiple/single column sorting.

## Authentication

> NOTE: Wallaby DOES NOT handle signing in or out. It only checks if user is signed in or not.

### authenticate

This is the configuration to check if user has signed in or to authenticate a user. For example, to use HTTP BASIC authentication, it goes:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  config.security.authenticate do
    authenticate_or_request_with_http_basic do |username, password|
      username == 'too_simple' && password == 'too_naive'
    end
  end
end
```

If it's not configured, it does not to authenticate a user.

### current_user

This is the configuration to return the signed-in user instance. For example:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  config.security.current_user do
    # user example
    Class.new do
      def email
        'user@example.com'
      end
    end.new
  end
end
```

> NOTE: Wallaby uses default method `email` to display user avatar image from https://en.gravatar.com at top-right corner on every page.
> see below if `email` is not the target method.

### email_method

> Since 5.1.4

This is the configuration to specify the method to return an email address for user avatar display. For example:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  config.security.email_method = :user_email
end
```

check if user has signed in. For example, to use HTTP BASIC authentication, it goes:

Authentication can be customized by configuring the `authenticate` and `current_user` (optional: `email_method`) options as per the example below:

- `authenticate`: a block that will be executed by controller to do authenticate. (all controller methods can be accessed inside the block)
- `current_user`: a block that retrieve current user instance. (all controller methods can be accessed inside the block)
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

See section [base_controller](#base_controller) for the third option.

### logout_path and logout_method

> since 5.1.4

Wallaby doesn't do logout function. Instead, it sends user to logout route (by default, it is Devise's `session#destroy` route).
If Devise is not used, two options can be configured:

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

## Controller

### base_controller

By default, `Wallaby::ResourcesController` inherits from `::ApplicationController`. Therefore, all subclasses of `Wallaby::ResourcesController` will have access to all `::ApplicationController`'s controller and helper methods.

However, it's possible to change the base controller class that `Wallaby::ResourcesController` inherits from.

For example, if a controller has implemented the `authenticate_user!` and `current_user` method, to make Wallaby to pick up the authentication, it can be configured as:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  # if base_controller's not set, it defaults to `::ApplicationController`
  config.base_controller = MySecurityController
end
```

Once this is set up, Wallaby will automatically pick up these two authentication methods mentioned above (which are compatible with Devise) from `MySecurityController`.

## Models

What models Wallaby should be handling can be configured in the following two ways:

### exclude

> NOTE: when models are whitelisted, models exclusion will NOT be applied.

Blacklist the models that Wallaby shouldn't handle:

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

Since 5.2.0, by default, `ActiveRecord::SchemaMigration` is excluded. If it is required, it can be brought back by configuring:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  config.models.exclude []
end
```

### models=

> NOTE: when models are whitelisted, models exclusion will NOT be applied.

Whitelist the models that Wallaby should handle:

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

## Mapping

> since 5.1.6

It's always recommended to use global base classes so that monkey patching to wallaby gem can be avoided. This can be done for the following classes:

- [resources_controller](#resources_controller)
- [resource_decorator](#resource_decorator)
- [model_servicer](#model_servicer)
- [model_authorizer](#model_authorizer) (since 5.2.0)
- [model_paginator](#model_paginator)

### resources_controller

> Read more from [Controller](controller.md) to understand what controller does and how controller can be customized.

A global controller `Admin::ApplicationController` is recommended to be created inheriting from `Wallaby::ResourcesController`:

```ruby
# app/controllers/admin/application_controller.rb
class Admin::ApplicationController < Wallaby::ResourcesController
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

### resource_decorator

> Read more from [Decorator](decorator.md) to understand what decorator does and how decorator can be customized.

A global decorator `Admin::ApplicationDecorator` needs to be created inheriting from `Wallaby::ResourceDecorator`:

```ruby
# app/decorators/admin/application_decorator.rb
class Admin::ApplicationDecorator < Wallaby::ResourceDecorator
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

### model_servicer

> Read more from [Servicer](servicer.md) to understand what servicer does and how servicer can be customized.

A global servicer `Admin::ApplicationServicer` needs to be created inheriting from `Wallaby::ModelServicer`:

```ruby
# app/servicers/admin/application_servicer.rb
class Admin::ApplicationServicer < Wallaby::ModelServicer
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

### model_authorizer

> since 5.2.0

> Read more from [Authorizer](authorizer.md) to understand what authorizer does and how authorizer can be customized.

A global authorizer `Admin::ApplicationAuthorizer` needs to be created inheriting from `Wallaby::ModelAuthorizer`:

```ruby
# app/authorizers/admin/application_authorizer.rb
class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
end
```

If other class name is preferred, for example, `GlobalAuthorizer`:

```ruby
# app/authorizers/global_authorizer.rb
class GlobalAuthorizer < Wallaby::ModelAuthorizer
end
```

Then configuration is required so that Wallaby can pick it up:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  config.mapping.model_authorizer = GlobalAuthorizer
end
```

### model_paginator

> Read more from [Paginator](paginator.md) to understand what paginator does and how paginator can be customized.

A global paginator `Admin::ApplicationPaginator` needs to be created inheriting from `Wallaby::ModelPaginator`:

```ruby
# app/paginators/admin/application_paginator.rb
class Admin::ApplicationPaginator < Wallaby::ModelPaginator
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

## Metadata

Be able to configure global metadata that Wallaby should use as default value when decorator-defined metadata is absent. For now, it has only one option:

### max

To configure the max length that Wallaby should truncate to when given text is longer than defined:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  # if not set, default is 20
  config.metadata.max = 300
end
```

## Pagination

It has only one option so far:

### page_size

To configure the default page size that Wallaby should use as default:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  # if not set, default is 20
  config.pagination.page_size = 100
end
```

## Features

It has only one option so far:

### turbolinks_enabled

Wallaby supports turbolinks, to enable it, it needs to be configured:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  # if not set, default is false
  config.features.turbolinks_enabled = true
end
```

And make sure that `turbolinks` gem is added in `Gemfile`

## Sorting

It has only one configuration so far:

### strategy

> since 5.2.0

Wallaby supports `:multiple`/`:single` column sorting, and the default option is `:multiple`. To change to single column sorting, it goes:

```ruby
# config/initializers/wallaby.rb
Wallaby.config do |config|
  config.sorting.strategy = :single
end
```
