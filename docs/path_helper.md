# Path and URL Helpers

Similar to [Rails Resourceful Path and URL helpers ](http://guides.rubyonrails.org/routing.html#path-and-url-helpers), Wallaby provides the following path and URL helpers:

| HTTP Verb |	Path	                    | Named Helper                                          | Controller#Action       | Mounted Path  | Engine Name     | Resources Name  |
| --------- | ------------------------- | ----------------------------------------------------- | ----------------------- | ------------- | --------------- | --------------- |
| GET       |	/admin/products	          | _wallaby_engine.resources_path('products')_           | admin/products#index	  | /admin        | wallaby_engine  | products        |
| GET       |	/admin/products/new	      | _wallaby_engine.new_resource_path('products')_        | admin/products#new	    | /admin        | wallaby_engine  | products        |
| POST      |	/admin/products	          | _wallaby_engine.resources_path('products')_           | admin/products#create	  | /admin        | wallaby_engine  | products        |
| GET       |	/admin/products/:id	      | _wallaby_engine.resource_path('products',:id)_        | admin/products#show	    | /admin        | wallaby_engine  | products        |
| GET       |	/admin/products/:id/edit  | _wallaby_engine.edit_resource_path('products',:id)_   | admin/products#edit	    | /admin        | wallaby_engine  | products        |
| PATCH/PUT |	/admin/products/:id	      | _wallaby_engine.edit_resource_path('products',:id)_   | admin/products#update	  | /admin        | wallaby_engine  | products        |
| DELETE    |	/admin/products/:id	      | _wallaby_engine.resource_path('products',:id)_        | admin/products#destroy  | /admin        | wallaby_engine  | products        |

> **Mounted Path** is also known as [Script Name](http://api.rubyonrails.org/classes/ActionDispatch/Routing/Redirection.html)

## Controller

In the above example, it assumes that `Admin::ProductsController` is defined similar to below:

```ruby
class Admin::ProductsController < Admin::ApplicationController
  self.model_class = Product
end
```

Otherwise, if `Admin::ProductsController` is not defined, Wallaby will dispatch the request to `Admin::ApplicationController`, or last resart `Wallaby::ResourcesController`.

## Engine Name

If Wallaby is mounted without `:as` option, by default, Rails will generate an engine helper called `wallaby_engine`.

However, it is possible to mount Wallaby with `:as` option as follows (see [#mount](http://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Base.html#method-i-mount)):

```ruby
Rails.application.routes.draw do
  # ...
  mount Wallaby::Engine, at: '/admin', as: :manager_engine
  # ...
end
```

In this case, please use `manager_engine` instead, e.g. `manager_engine.resources_path('products')`.

