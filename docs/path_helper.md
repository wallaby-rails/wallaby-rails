# Path and URL Helpers

Similar to [Rails Resourceful Path and URL helpers ](http://guides.rubyonrails.org/routing.html#path-and-url-helpers), Wallaby provides the following path and URL helpers:

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

In the above example, resource name `order::items` will be converted into model `Order::Item`, and `Order::Item` will be used to as the key to look up which controller it should dispatch to.

If controller `Admin::Order::ItemsController` is defined similar to below:

```ruby
class Admin::Order::ItemsController < Admin::ApplicationController
  # NOTE: `Order::Item` is required to be configured
  # only when controller name is not `Order::ItemsController`.
  self.model_class = Order::Item
end
```

If `Admin::Order::ItemsController` is not defined and, Wallaby will dispatch request to `Admin::ApplicationController`, or last resart `Wallaby::ResourcesController`.

## Engine Name

If Wallaby is mounted without `:as` option, by default, Rails will generate an engine helper called `wallaby_engine` so that url helper methods can be accessed like:

```ruby
wallaby_engine.resources_path('order::items')
```

However, it is possible to mount Wallaby and use an alias name using `:as` option as follows (see [#mount](http://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Base.html#method-i-mount)):

```ruby
Rails.application.routes.draw do
  # ...
  mount Wallaby::Engine, at: '/admin', as: :manager_engine
  # ...
end
```

In this case, Rails will generate the engine helper as `manager_engine` instead. Then url helper methods for Wallaby can be accessed like

```ruby
manager_engine.resources_path('order::items')
```

Because of this, if Wallaby doesn't recognize the engine name, it'd better to configure and tell what engine name that Wallaby should be use for a controller as below:

```ruby
class Admin::ApplicationController < Wallaby::ResourcesController
  # NOTE: All sub classes of Admin::ApplicationController will inherit the same engine name as well
  self.engine_name = :manager_engine
end
```
