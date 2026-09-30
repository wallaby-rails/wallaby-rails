---
title: Naming Conventions
layout: default
nav_order: 1

parent: API Reference
has_children: false
---

# Naming Conventions

Wallaby relies on Rails-style naming conventions to connect a model with everything else: controllers, decorators, servicers, authorizers and paginators.

For a model class e.g. `Product`:

| Purpose     | Class Name        | Location                                   |
| ----------- | ----------------- | ------------------------------------------ |
| Controller  | `ProductsController` / `Admin::ProductsController` | `app/controllers/`       |
| Decorator   | `ProductDecorator` | `app/decorators/`      |
| Servicer    | `ProductServicer`  | `app/servicers/`       |
| Authorizer  | `ProductAuthorizer`| `app/authorizers/`     |
| Paginator   | `ProductPaginator` | `app/paginators/`      |

## Decorator

> See [Decorator](decorator.md) for how to create and customize decorators.

For model `Product`, the decorator should be named `ProductDecorator`:

```ruby
# app/decorators/product_decorator.rb
class ProductDecorator < Admin::ApplicationDecorator
end
```

When a model is namespaced e.g. `Order::Item`, the decorator can be placed under the same namespace as either:

```ruby
# app/decorators/admin/order/item_decorator.rb
class Admin::Order::ItemDecorator < Admin::ApplicationDecorator
end

# or
# app/decorators/order/item_decorator.rb
class Order::ItemDecorator < Admin::ApplicationDecorator
end
```

Wallaby tries the demodulized variants (`Admin::Order::ItemDecorator`, `Order::ItemDecorator`, `ItemDecorator`) until it finds a constantized class.

If the name cannot reflect the association, [`.model_class`](decorator.md#model_class) can be set to specify the model class explicitly.

## Servicer

> See [Servicer](servicer.md) for how to create and customize servicers.

For model `Product`, the servicer should be named `ProductServicer`:

```ruby
# app/servicers/product_servicer.rb
class ProductServicer < Admin::ApplicationServicer
end
```

The same demodulized lookup applies to servicers (e.g. `Admin::Order::ItemServicer`).

## Authorizer

> See [Authorizer](authorizer.md) for how to create and customize authorizers.

For model `Product`, the authorizer should be named `ProductAuthorizer`:

```ruby
# app/authorizers/product_authorizer.rb
class ProductAuthorizer < Admin::ApplicationAuthorizer
end
```

## Paginator

> See [Paginator](paginator.md) for how to create and customize paginators.

For model `Product`, the paginator should be named `ProductPaginator`:

```ruby
# app/paginators/product_paginator.rb
class ProductPaginator < Admin::ApplicationPaginator
end
```

## Controller

> See [Controller](api-references/controller.md) for how to create and customize controllers.

For model `Product`, the controller should be created under the mounted namespace (e.g. `Admin`) as `Admin::ProductsController`:

```ruby
# app/controllers/admin/products_controller.rb
class Admin::ProductsController < Admin::ApplicationController
end
```

For a namespaced model `Order::Item`, the controller becomes `Admin::Order::ItemsController`.

If the controller name cannot reflect the association, [`.model_class`](api-references/controller.md#model_class) can be set to specify the model class explicitly.

## URL Naming

The URL name of a model is the pluralized, underscored (tableized) class name. Namespaces are separated by double colons:

- `Product` -> `products`
- `Order::Item` -> `order::items`

For example, the index page of `Order::Item` is accessed at `/admin/order::items`, and the corresponding path helpers take the URL name:

```ruby
wallaby_engine.resources_path('order::items') # => /admin/order::items
```

> See [Route - Path and URL Helpers](route.md#path-and-url-helpers) for the full list of predefined route helpers.