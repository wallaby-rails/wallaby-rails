# Naming Conventions

Models are the ones that Wallaby uses to connect everything together (controller/decorator/servicer/authorizer/paginator/view). See the following sections to find out how model is associated with the following components using naming conventions.

- [URL](#url)
- [Controller](#controller)
- [Decorator](#decorator)
- [Servicer](#servicer)
- [Authorizer](#authorizer)
- [Paginator](#paginator)

## URL

### Admin Interface

When Wallaby is used as admin interface, Wallaby uses the following naming convention to find out how URL maps to model or vice versa:

| URL                 | Model       |
| ------------------- | ----------- |
| /admin/products     | Product     |
| /admin/line_items   | LineItem    |
| /admin/people       | Person      |
| /admin/order::items | Order::Item |

As the last row illustrated, Wallaby handles namespace slightly different from Rails when used as admin interface. By using `order::items` instead of `order/items`, URL becomes non-nested and can be recognized as a pattern by Wallaby routings.

See [Admin Interface Routing](route.md#for-admin-interface) for how to mount or add routes when using Wallaby as admin interface.

### For General Purpose

> since 5.2.0

Wallaby can be used for general purpose, for example:

```ruby
# config/routes
resources :orders do
  resources :items
end
```

```ruby
# app/controllers/orders_controller.rb
class OrdersController < Wallaby::ResourcesController
end

# app/controllers/order/items_controller.rb
class Order::ItemsController < Wallaby::ResourcesController
end
```

In this case, it works the same as . And URL mapping to controller and model is the same as Rails:

| URL           | Model       |
| ------------- | ----------- |
| /products     | Product     |
| /line_items   | LineItem    |
| /people       | Person      |
| /order/items  | Order::Item |

See [Declaring Routes](route.md#for-non-admin-interface) for how to customize the routes when using Wallaby for general purpose.

## Controller

> Read more from [Controller](controller.md) to understand what controller does and how controller can be customized.

Same as Rails, Wallaby also favors **pluralization** of the last word in controller's name.For example, `SiteAdminsController` is preferable over `SitesAdminsController` or `SiteAdminController`

This naming convention allows Wallaby to automatically connect the model and its controller. For example, when used as admin interface, for model `SiteAdmin`, Wallaby will look for the controller to dispatch to in the following top-down order:

- `Admin::SiteAdminsController` under `Admin` namespace
- admin base controller `Admin::ApplicationController`
- `Wallaby::ResourcesController`

If the controller name cannot reflect the correct model name, for example, between `Admin::ProductsController` and `ProductItem`, it is possible to [specify associated model class for controller](controller.md#model_class).

## Decorator

> Read more from [Decorator](decorator.md) to understand what decorator does and how decorator can be customized.

Similar to Active Record's naming convention, Wallaby favors **singularization** of the last word in decorator's name. For example, `SiteAdminDecorator` is preferable over `SitesAdminsDecorator` or `SiteAdminsDecorator`.

Following this convention will allow Wallaby to automatically connect the model and its decorator. For example, for model `SiteAdmin`, Wallaby will use `Admin::SiteAdminDecorator`  to decorate it in the view. Otherwise, Wallaby will fall back to use base controller `Admin::ApplicationDecorator` or `Wallaby::ResourceDecorator` if `Admin::ApplicationDecorator` does not exist.

When there is scenario that decorator name cannot reflect associated model name, for example, `Admin::ProductDecorator`, it's possible to manually associate `Admin::ProductDecorator` with `Product`, see [specifying model class for Decorator](decorator.md#model_class).

Also, it's recommended to place decorators under folder `app/decorators` for better file organization.

## Servicer

> Read more from [Servicer](servicer.md) to understand what servicer does and how servicer can be customized.

Similar to Active Record's naming convention, Wallaby favors **singularization** of the last word in servicer's name. For example, `SiteAdminServicer` is preferable over `SitesAdminsServicer` or `SiteAdminsServicer`.

Following this convention will allow Wallaby to automatically connect the model and its servicer. For example, for model `SiteAdmin`, Wallaby will use `SiteAdminServicer` to perform CRUD operations. Otherwise, Wallaby will fall back to use base controller `Admin::ApplicationServicer` or `Wallaby::ModelServicer` if `Admin::ApplicationServicer` does not exist.

When there is scenario that controller name cannot reflect associated model name, for example, `Admin::ProductServicer`, it's possible to manually associate `Admin::ProductServicer` with `Product`, see [specifying model class for Servicer](servicer.md#model_class).

Also, it's recommended to place servicers under folder `app/servicers` for better file organization.

## Authorizer

> Read more from [Authorizer](authorizer.md) to understand what authorizer does and how authorizer can be customized.

Similar to Active Record's naming convention, Wallaby favors **singularization** of the last word in servicer's name. For example, `SiteAdminAuthorizer` is preferable over `SitesAdminsAuthorizer` or `SiteAdminsAuthorizer`.

Following this convention will allow Wallaby to automatically connect the model and its servicer. For example, for model `SiteAdmin`, Wallaby will use `SiteAdminAuthorizer` to perform authorization checks. Otherwise, Wallaby will fall back to use base controller `Admin::ApplicationAuthorizer` or `Wallaby::ModelAuthorizer` if `Admin::ApplicationAuthorizer` does not exist.

When there is scenario that controller name cannot reflect associated model name, for example, `Admin::ProductAuthorizer`, it's possible to manually associate `Admin::ProductAuthorizer` with `Product`, see [specifying model class for Authorizer](authorizer.md#model_class).

Also, it's recommended to place authorizers under folder `app/authorizers` for better file organization.

## Paginator

> Read more from [Paginator](paginator.md) to understand what paginator does and how paginator can be customized.

Similar to Active Record's naming convention, Wallaby favors **singularization** of the last word in servicer's name. For example, `SiteAdminPaginator` is preferable over `SitesAdminsPaginator` or `SiteAdminsPaginator`.

Following this convention will allow Wallaby to automatically connect the model and its servicer. For example, for model `SiteAdmin`, Wallaby will use `SiteAdminPaginator` to get pagination information for it. Otherwise, Wallaby will fall back to use base controller `Admin::ApplicationPaginator` or `Wallaby::ModelPaginator` if `Admin::ApplicationPaginator` does not exist.

When there is scenario that controller name cannot reflect associated model name, for example, `Admin::ProductPaginator`, it's possible to manually associate `Admin::ProductPaginator` with `Product`, see [specifying model class for Paginator](paginator.md#model_class).

Also, it's recommended to place paginators under folder `app/paginators` for better file organization.
