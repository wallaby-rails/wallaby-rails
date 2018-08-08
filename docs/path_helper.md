<!-- TOC -->

- [Path and URL Helpers](#path-and-url-helpers)
  - [Controller](#controller)
  - [Engine Name](#engine-name)

<!-- /TOC -->

# Path and URL Helpers

Similar to [Rails Resourceful Path and URL helpers ](http://guides.rubyonrails.org/routing.html#path-and-url-helpers), Wallaby provides a set of resourcesful path and URL helpers, for example:

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

## Controller

In the above example, resources name `order::items` will be converted into model class `Order::Item`, and `Order::Item` will be used to as the key to look up which controller it should dispatch to.

When controller `Admin::Order::ItemsController` is defined as below:

```ruby
class Admin::Order::ItemsController < Admin::ApplicationController
  self.model_class = Order::Item
end
```

> See more at [Controller Customization](controller.md)

Request will then be dispatched to `Admin::Order::ItemsController`.

But if `Admin::Order::ItemsController` is absent, request will be dispatched to `Admin::ApplicationController`, otherwise last resort `Wallaby::ResourcesController`.

## Engine Name

If Wallaby is mounted without `:as` option, by default, Rails will generate an engine helper called `wallaby_engine` so that resourceful path helper methods can be accessed via it:

```ruby
wallaby_engine.resources_path('order::items') # => /admin/order::items
```

However, it is possible to use an alias engine name with `:as` option as follows (see [#mount](http://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Base.html#method-i-mount)):

```ruby
Rails.application.routes.draw do
  # ...
  mount Wallaby::Engine, at: '/admin', as: :manager_engine
  # ...
end
```

In this case, Rails will generate the engine helper as `manager_engine` instead. Then resourceful path helper methods can be accessed as below:

```ruby
manager_engine.resources_path('order::items')
```

Most of the time, Wallaby should be able to determine what engine name to use. But if Wallaby can't detect the engine name, it can be configured in controller (also see [Controller -> Engine Name](controller.md#engine-name)):

```ruby
class Admin::ApplicationController < Wallaby::ResourcesController
  self.engine_name = :manager_engine
end
```

> NOTE: All sub classes of Admin::ApplicationController will inherit the same engine name.
