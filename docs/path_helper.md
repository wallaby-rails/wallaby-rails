# Path and URL Helpers

Similar to [Rails Resourceful Path and URL helpers ](http://guides.rubyonrails.org/routing.html#path-and-url-helpers), Wallaby provides the following path and URL helpers:

| HTTP Verb |	Path	                    | Mounted Path  | Engine Name     | Resources Name  | Controller#Action	      | Named Helper                                        |
| --------- | ------------------------- | ------------- | --------------- | --------------- | ----------------------- | --------------------------------------------------- |
| GET       |	/admin/products	          | /admin        | wallaby_engine  | products        | admin/products#index	  | wallaby_engine.resources_path('products')           |
| GET       |	/admin/products/new	      | /admin        | wallaby_engine  | products        | admin/products#new	    | wallaby_engine.new_resource_path('products')        |
| POST      |	/admin/products	          | /admin        | wallaby_engine  | products        | admin/products#create	  | wallaby_engine.resources_path('products')           |
| GET       |	/admin/products/:id	      | /admin        | wallaby_engine  | products        | admin/products#show	    | wallaby_engine.resource_path('products', :id)       |
| GET       |	/admin/products/:id/edit  | /admin        | wallaby_engine  | products        |	admin/products#edit	    | wallaby_engine.edit_resource_path('products', :id)  |
| PATCH/PUT |	/admin/products/:id	      | /admin        | wallaby_engine  | products        | admin/products#update	  | wallaby_engine.edit_resource_path('products', :id)  |
| DELETE    |	/admin/products/:id	      | /admin        | wallaby_engine  | products        | admin/products#destroy  |	wallaby_engine.resource_path('products', :id)       |

Regarding engine, if Wallaby is mounted in the following way with a change of engine name using `:as` option:

```ruby
Rails.application.routes.draw do
  # ...
  mount Wallaby::Engine, at: '/admin', as: :manager_engine
  # ...
end
```

Then change to use `manager_engine` instead, e.g. `manager_engine.resources_path('products')`.

Regarding controller, if `Admin::ProductsController` is not declared, Wallaby will dispatch request to `Admin::ApplicationController` then `Wallaby::ResourcesController`.
