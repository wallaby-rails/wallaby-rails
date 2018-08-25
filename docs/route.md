# Declaring Routes

Wallaby has predefined the same resourcesful routes (index/new/create/show/edit/update/destroy) as Rails. Apart from that, routes can be declared in the following scenarios:

- [For Admin Interface](#for-admin-interface)
  - [`:resources` match option](#resources-match-option) - to specify the resources name for a given controller
  - [`:resources_controller` mount option](#resources_controller-mount-option) (since 5.2.0) - to specify the base controller for a given mount path
- [For Non Admin Interface](#for-non-admin-interface) (since 5.2.0)

Read more:

- [Path and URL Helpers](#path-and-url-helpers) for the full list of predefined routes and helpers.

## For Admin Interface

When Wallaby is used as an admin interface, generally, it is mounted like:

```ruby
# config/routes.rb
mount Wallaby::Engine, at: '/admin'
```

In this case, all URLs prefixed with `/admin` will be handled by Wallaby [Resources Router](https://www.rubydoc.info/gems/wallaby/Wallaby/ResourcesRouter).

### `:resources` match option

Therefore, if there is a custom controller and a custom (non-resourcesful) action, for example:

```ruby
# app/controllers/admin/products_controller.rb
class Admin::Order::ItemsController < Admin::ApplicationController
  self.model_class = Order::Items

  def report
    @report = Report.for resource
  end
end
```

Then the route to `Admin::Order::ItemsController` and its action `report` has to be declared before Wallaby's mounting:

```ruby
# config/routes.rb
match '/admin/order::items/:id/report',
  to: 'admin/orders/items#report',
  via: :get,
  # `:resources` is required.
  defaults: { resources: 'order::items' }
mount Wallaby::Engine, at: '/admin'
```

> NOTE: `:resources` default param must be provided.

### `:resources_controller` mount option

> since 5.2.0

When mounting Wallaby at different path, it's possible to specify different base controller class for different mount path using `:resources_controller` default param. For example:

```ruby
# app/controllers/super_admin/application_controller.rb
class SuperAdmin::ApplicationController < Wallaby::ResourcesController
end

# config/routes.rb
mount Wallab::Engine,
  at: '/super_admin', as: :super_admin,
  defaults: { resources_controller: SuperAdmin::ApplicationController }
```

```ruby
# app/controllers/advisor_only/application_controller.rb
class AdvisorOnly::ApplicationController < Wallaby::ResourcesController
end

# config/routes.rb
mount Wallab::Engine,
  at: '/advisor', as: :advisor,
  defaults: { resources_controller: AdvisorOnly::ApplicationController }
```

## For Non Admin Interface

> since 5.2.0

Wallaby can be used beyond being admin interface, for example:

```ruby
# app/controllers/products_controller.rb
class ProductsController < Wallaby::ResourcesController
  def orders
    @orders = Order.for resource
  end
end
```

And the route is:

```
# config/routes.rb
resources :products
```

In this case, the route to `ProductsController` and action `orders` can be declared as usual Rails resourcesful route:

```ruby
# config/routes.rb
resources :products do
  get :orders, on: :member
end
```

## Path and URL Helpers

Similar to and apart from [Rails Resourceful Path and URL helpers ](http://guides.rubyonrails.org/routing.html#path-and-url-helpers), Wallaby provides a set of resourcesful path and URL helpers, for example:

| HTTP Verb |	Path	                        | Named Helper                                            | Controller#Action         | Mounted Path  | Engine Name     | Resources Name  |
| --------- | ----------------------------- | ------------------------------------------------------- | ------------------------- | ------------- | --------------- | --------------- |
| GET       |	/admin/order::items	          | _wallaby_engine.resources_path('order::items')_         | admin/order/items#index	  | /admin        | wallaby_engine  | order::items    |
| GET       |	/admin/order::items/new	      | _wallaby_engine.new_resource_path('order::items')_      | admin/order/items#new	    | /admin        | wallaby_engine  | order::items    |
| POST      |	/admin/order::items	          | _wallaby_engine.resources_path('order::items')_         | admin/order/items#create	| /admin        | wallaby_engine  | order::items    |
| GET       |	/admin/order::items/:id	      | _wallaby_engine.resource_path('order::items',:id)_      | admin/order/items#show	  | /admin        | wallaby_engine  | order::items    |
| GET       |	/admin/order::items/:id/edit  | _wallaby_engine.edit_resource_path('order::items',:id)_ | admin/order/items#edit	  | /admin        | wallaby_engine  | order::items    |
| PATCH/PUT |	/admin/order::items/:id	      | _wallaby_engine.edit_resource_path('order::items',:id)_ | admin/order/items#update	| /admin        | wallaby_engine  | order::items    |
| DELETE    |	/admin/order::items/:id	      | _wallaby_engine.resource_path('order::items',:id)_      | admin/order/items#destroy | /admin        | wallaby_engine  | order::items    |

> **Mounted Path** is also known as [Script Name](http://api.rubyonrails.org/classes/ActionDispatch/Routing/Redirection.html)

### Engine Helper

If Wallaby is mounted without `:as` option, by default, Rails will generate an engine helper called `wallaby_engine`, so that resourcesful path helper methods can be accessed via this engine helper:

```ruby
wallaby_engine.resources_path('order::items') # => /admin/order::items
```

When an alias engine name is specified by `:as` option as follows (see [#mount](http://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Base.html#method-i-mount)):

```ruby
# config/routes.rb
mount Wallaby::Engine, at: '/admin', as: :manager_engine
```

Rails will generate the engine helper as `manager_engine` instead. Then resourcesful path helper methods can be accessed:

```ruby
manager_engine.resources_path('order::items')
```

Most of the time, Wallaby should be able to determine what engine name to use. But if Wallaby can't detect the engine name, it can be configured in controller (also see [Controller - Advanced Customization -> engine_name](advanced_controller.md#engine_name)):

```ruby
# app/controllers/admin/application_controller.rb
class Admin::ApplicationController < Wallaby::ResourcesController
  self.engine_name = :manager_engine
end
```

> NOTE: All sub classes of `Admin::ApplicationController` will inherit the same engine name when it is set.

> See more options at [Customizating Controller](controller.md).
