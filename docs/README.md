# What is Wallaby?

Wallaby is a data admin app that allows the user to customise the parts of a Rails app following the MVC approach.

# Customization

Customization can be done in the following sections:

- [Controller](controller.md)
- [Decorator](decorator.md)
- [Servicer](servicer.md)
- [View](view.md)

# How Wallaby Works

Like most Rails apps, the journey begins with routing. We will use `GET /admin/order::items/1` as an example (assuming `/admin` is the path that Wallaby is mounted to).

## Routing

`Wallaby::ResourcesRouter` is responsible for routing. It uses the following rules to decide which controller to dispatch to:

1. Look for a controller inheriting from `Wallaby::ResourcesController` that has the `model_class` as `Order::Item` (converted from resources name `order::items`). For example, the controller below will be matched:

    ```ruby
    class Management::OrderItemController < Wallaby::ResourcesController
      def self.model_class; Order::Item; end
    end
    ```

2. Otherwise, use the generic `Wallaby::ResourcesController`

`Wallaby::ResourcesRouter` looks up the action from the following places:
- route option `defaults`
- request parameter `action`

In this example, the action name is `show`, which has been defined in the route option `defaults`.

Since we have defined a controller `Management::OrderItemController`, the request will then be dispatched to `Management::OrderItemController#show`.

## Controller

Once the controller receives the request, it checks both authentication and authorization to ensure that the user has access to the resource. If they do, it will execute the action using the service object.

> NOTE: supported resourceful actions are `index`,`new`, `create`,`show`,`edit`,`update` and `destroy`.

Once the action is executed, it will then pass the variable `collection` to `index` or `resource` for `new`, `show` and `edit` respectively.

One additional thing that controller does is set up the prefixes for `ViewPaths`. This allows Rails to look up partials, which it does using the following rules:

1. check `/admin/order/items/index` first (pattern `:wallaby_mount_path/:resource_name/:action_name`)
2. check `/admin/order/items` (pattern `:wallaby_mount_path/:resource_name`)
3. if controller name is different, then it will check `/management/orderitems/index` (pattern `:controller/:action_name`)
4. if controller name is different, then it will also check `/management/orderitems` (pattern `:controller`)
5. fall back to check `/wallaby/resource/index`
6. fall back to check `/wallaby/resource`

For example, if you have the following view partials in your app folder:

- `app/views/admin/order/items/index/_integer.html.erb`
- `app/views/admin/order/items/_integer.html.erb`
- `app/views/management/orderitems/index/_integer.html.erb`
- `app/views/management/orderitems/_integer.html.erb`

It will pick up the first partial. If none of the above partials exists, it will fall back to build-in partials in Wallaby engine:

- `app/views/wallaby/resources/index/_integer.html.erb`
- `app/views/wallaby/resources/_integer.html.erb`

> NOTE: for actions `new`, `create`, `edit` and `update`, `:action_name` is `form`.

## View

At this stage, the `collection` or `resource` passed from controller will be wrapped as decorator(s), so that we could loop through all the fields (DB columns and custom attributes) and render their values accordingly using view partials described above.

Then Wallaby will render the complete HTML and send it back to client. Here ends the life cycle of a request throughout Wallaby in a typical Rails way.
