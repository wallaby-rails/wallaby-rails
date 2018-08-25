# Controller - Advanced Customization

See following sections for comprehensive controller customization:

- [theme_name](#theme_name) (since 5.2.0) - specifying the theme
- [engine_name](#engine_name) (since 5.2.0) - specifying the name of engine helper
- [application_decorator](#application_decorator) (since 5.2.0) - specifying the base resource decorator class
- [resource_decorator](#resource_decorator) (since 5.2.0) - specifying the resource decorator class
- [application_servicer](#application_servicer) (since 5.2.0) - specifying the base model servicer class
- [model_servicer](#model_servicer) (since 5.2.0) - specifying the model servicer class
- [application_authorizer](#application_authorizer) (since 5.2.0) - specifying the base model authorizer class
- [model_authorizer](#model_authorizer) (since 5.2.0) - specifying the model authorizer class
- [application_paginator](#application_paginator) (since 5.2.0) - specifying the base model paginator class
- [model_paginator](#model_paginator) (since 5.2.0) - specifying the model paginator class

## theme_name

> since 5.2.0

To apply a theme, there are two ways:

- Specify the `theme_name` in controller declaration:

  ```ruby
  # app/controllers/admin/application_controller.rb
  class Admin::ApplicationController < Wallaby::ResourcesController
    self.theme_name = 'bootstrap4'
  end
  ```

- If the theme comes with a base controller, e.g. `Bootstrap4Controller`, then it is as simple as:

  ```ruby
  # app/controllers/admin/application_controller.rb
  class Admin::ApplicationController < Bootstrap4Controller
  end
  ```

> NOTE: behind the scene, Wallaby utilizes Rails [Layout Inheritance](https://guides.rubyonrails.org/layouts_and_rendering.html#layout-inheritance) and [Template Inheritance](https://guides.rubyonrails.org/layouts_and_rendering.html#template-inheritance).
> All subclasses of `Admin::ApplicationController` will therefore inherit the same theme unless being configured.

> Read more at [Theme Documentation](theme.md) for creating a theme and etc.

## application_decorator

> since 5.2.0

It is possible to have two different sets of Wallaby customization using different base resource decorators. For example:

```ruby
# app/controllers/super_admin/application_controller.rb
class SuperAdmin::ApplicationController < Wallaby::ResourcesController
  self.application_decorator = SuperAdminDecorator
end

# app/decorators/super_admin_decorator.rb
class SuperAdminDecorator < Wallaby::ResourceDecorator
  def owner
    super
  end
end

# config/routes.rb
mount Wallab::Engine,
  at: '/super_admin', as: :super_admin,
  defaults: { resources_controller: SuperAdmin::ApplicationController }
```

```ruby
# app/controllers/advisor_only/application_controller.rb
class AdvisorOnly::ApplicationController < Wallaby::ResourcesController
  self.application_decorator = AdvisorOnlyDecorator
end

# app/decorators/advisor_only_decorator.rb
class AdvisorOnlyDecorator < Wallaby::ResourceDecorator
  def owner
    '<n/a>'
  end
end

# config/routes.rb
mount Wallab::Engine,
  at: '/advisor', as: :advisor,
  defaults: { resources_controller: AdvisorOnly::ApplicationController }
```

In the above example, two sets of controllers use two sets of base decorators, one allows super admin to view the value of owner, and the one for advisor shows only `'<n/a>'`.

Once the `application_decorator` is set in the controller, all subclasses of the controller will inherit the same base decorator. Take the above example, all subclasses of `SuperAdmin::ApplicationController` will use `SuperAdminDecorator` as base decorator, and all subclasses of `AdvisorOnly::ApplicationController` will use `AdvisorOnlyDecorator` as the base decorator.

## resource_decorator

> since 5.2.0

In most of the cases, Wallaby should be able to pick the correct resource decorator to use for a model. However, there is still a chance that Wallaby doesn't meet the expection. In this case, it can be configured as:

```ruby
# app/controllers/admin/products_controller.rb
class Admin::ProductsController < Admin::ApplicationController
  self.model_class = Product
  self.resource_decorator = CorrectProductDecorator
end

# app/decorators/correct_product_decorator.rb
class CorrectProductDecorator < Admin::ApplicationDecorator
  self.model_class = Product
end
```

> NOTE: different from `application_decorator`, all subclasses of `Admin::ProductsController` will NOT inherit the same `resource_decorator`, `CorrectProductDecorator` is only applicable to `Admin::ProductsController`.

## application_servicer

> since 5.2.0

Similar to `application_decorator`, when there are two different sets of Wallaby customization using different base model servicers. For example:

```ruby
# app/controllers/super_admin/application_controller.rb
class SuperAdmin::ApplicationController < Wallaby::ResourcesController
  self.application_servicer = SuperAdminServicer
end

# app/servicers/super_admin_servicer.rb
class SuperAdminServicer < Wallaby::ModelServicer
  def create(resource, params)
    super resource, params.merge(admin: true)
  end
end
```

```ruby
# app/controllers/advisor_only/application_controller.rb
class AdvisorOnly::ApplicationController < Wallaby::ResourcesController
  self.application_servicer = AdvisorOnlyServicer
end

# app/servicers/advisor_only_servicer.rb
class AdvisorOnlyServicer < Wallaby::ModelServicer
  def create(resource, params)
    super resource, params.merge(admin: false)
  end
end
```

In the above example, two sets of controllers use two sets of base servicers, one allows super admin to create the record marked as admin, and the one for advisor creates the record marked as non-admin.

Once the `application_servicer` is set in the controller, all subclasses of the controller will inherit the same base servicer. Take the above example, all subclasses of `SuperAdmin::ApplicationController` will use `SuperAdminServicer` as base servicer, and all subclasses of `AdvisorOnly::ApplicationController` will use `AdvisorOnlyServicer` as the base servicer.

## model_servicer

> since 5.2.0

In most of the cases, Wallaby should be able to pick the correct model servicer to use for a model. However, there is still a chance that Wallaby doesn't meet the expection. In this case, it can be configured as:

```ruby
# app/controllers/admin/products_controller.rb
class Admin::ProductsController < Admin::ApplicationController
  self.model_class = Product
  self.model_servicer = CorrectProductServicer
end

# app/servicers/correct_product_servicer.rb
class CorrectProductServicer < Admin::ApplicationServicer
  self.model_class = Product
end
```

> NOTE: different from `application_servicer`, all subclasses of `Admin::ProductsController` will NOT inherit the same `model_servicer`, `CorrectProductServicer` is only applicable to `Admin::ProductsController`.

## application_authorizer

> since 5.2.0

Similar to `application_decorator`, when there are two different sets of Wallaby customization using different base model authorizers. For example:

```ruby
# app/controllers/super_admin/application_controller.rb
class SuperAdmin::ApplicationController < Wallaby::ResourcesController
  self.application_authorizer = SuperAdminAuthorizer
end

# app/authorizers/super_admin_authorizer.rb
class SuperAdminAuthorizer < Wallaby::ModelAuthorizer
  def authorized?(action, subject)
    true
  end
end
```

```ruby
# app/controllers/advisor_only/application_controller.rb
class AdvisorOnly::ApplicationController < Wallaby::ResourcesController
  self.application_authorizer = AdvisorOnlyAuthorizer
end

# app/authorizers/advisor_only_authorizer.rb
class AdvisorOnlyAuthorizer < Wallaby::ModelAuthorizer
  def authorized?(action, subject)
    false
  end
end
```

In the above example, two sets of controllers use two sets of base authorizers, one allows super admin to create the record marked as admin, and the one for advisor creates the record marked as non-admin.

Once the `application_authorizer` is set in the controller, all subclasses of the controller will inherit the same base authorizer. Take the above example, all subclasses of `SuperAdmin::ApplicationController` will use `SuperAdminAuthorizer` as base authorizer, and all subclasses of `AdvisorOnly::ApplicationController` will use `AdvisorOnlyAuthorizer` as the base authorizer.

## model_authorizer

> since 5.2.0

In most of the cases, Wallaby should be able to pick the correct model authorizer to use for a model. However, there is still a chance that Wallaby doesn't meet the expection. In this case, it can be configured as:

```ruby
# app/controllers/admin/products_controller.rb
class Admin::ProductsController < Admin::ApplicationController
  self.model_class = Product
  self.model_authorizer = CorrectProductAuthorizer
end

# app/authorizers/correct_product_authorizer.rb
class CorrectProductAuthorizer < Admin::ApplicationAuthorizer
  self.model_class = Product
end
```

> NOTE: different from `application_authorizer`, all subclasses of `Admin::ProductsController` will NOT inherit the same `model_authorizer`, `CorrectProductAuthorizer` is only applicable to `Admin::ProductsController`.

## application_paginator

> since 5.2.0

Similar to `application_decorator`, when there are two different sets of Wallaby customization using different base model paginators. For example:

```ruby
# app/controllers/super_admin/application_controller.rb
class SuperAdmin::ApplicationController < Wallaby::ResourcesController
  self.application_paginator = SuperAdminPaginator
end

# app/paginators/super_admin_paginator.rb
class SuperAdminPaginator < Wallaby::ModelPaginator
  def paginatable?
    true
  end
end
```

```ruby
# app/controllers/advisor_only/application_controller.rb
class AdvisorOnly::ApplicationController < Wallaby::ResourcesController
  self.application_paginator = AdvisorOnlyPaginator
end

# app/paginators/advisor_only_paginator.rb
class AdvisorOnlyPaginator < Wallaby::ModelPaginator
  def paginatable?
    false
  end
end
```

In the above example, two sets of controllers use two sets of base paginators, one allows super admin to be able to view pagination metadata for the records, and the one for advisor can't view it.

Once the `application_paginator` is set in the controller, all subclasses of the controller will inherit the same base paginator. Take the above example, all subclasses of `SuperAdmin::ApplicationController` will use `SuperAdminPaginator` as base paginator, and all subclasses of `AdvisorOnly::ApplicationController` will use `AdvisorOnlyPaginator` as the base paginator.

## model_paginator

> since 5.2.0

In most of the cases, Wallaby should be able to pick the correct model paginator to use for a model. However, there is still a chance that Wallaby doesn't meet the expection. In this case, it can be configured as:

```ruby
# app/controllers/admin/products_controller.rb
class Admin::ProductsController < Admin::ApplicationController
  self.model_class = Product
  self.model_paginator = CorrectProductPaginator
end

# app/paginators/correct_product_paginator.rb
class CorrectProductPaginator < Admin::ApplicationPaginator
  self.model_class = Product
end
```

> NOTE: different from `application_paginator`, all subclasses of `Admin::ProductsController` will NOT inherit the same `model_paginator`, `CorrectProductPaginator` is only applicable to `Admin::ProductsController`.
