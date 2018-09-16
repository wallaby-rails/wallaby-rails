# Authorizer

> since 5.2.0

Authorizer is designed using adaptor pattern to allow Wallaby to apply the authorization that authorization framework has defined, e.g. CanCanCan ability or Pundit policy.

Therefore, if you are using CanCanCan or Pundit or no authorization, you shouldn't need to do anything about authorizer since Wallaby can pick up the authorization framework.

What you might want to do mostly is to improve the performance by specifying the provider name and save the detection time for Wallaby.

For example, it goes:

```ruby
# app/authorizers/admin/application_authorizer.rb
class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
  self.provider_name = :cancancan # if CanCanCan is used
  self.provider_name = :pundit # if Pundit is used
  self.provider_name = :default # if none is used
end
```

Otherwise, you shouldn't need to customize authorizer. Especially, DO NOT put authorization logics into authorizer. Instead, they should go into ability file if CanCanCan or policies if Pundit.

You are more than welcome to use the authorization framework as usual in custom controller/servicer/type partials.

If you are looking for how to build the adaptor for your favourate authorization framework as a gem, see [Implementing authorization adaptor](authorization_adaptor.md).

Continue reading if you want to learn how Wallaby do authorization or if you need to support other authorization framework that Wallaby doesn't support in your project.

# Continue

First of all, it's always recommended to create a base authorizer class `Admin::ApplicationAuthorizer` as below, so that devs can have better control of developing global changes/functions:

```ruby
# app/authorizers/admin/application_authorizer.rb
class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
end
```

> See [Mapping - Authorizer](configuration.md#authorizer) for the configuration if `Admin::ApplicationAuthorizer` is taken for other purpose.

Starting with:

- [Declaration](#declaration)

Configuration can be set for:

- [abstract!](#abstract) - flagging as abstract base class.
- [model_class](#model_class) - specifying the model class.
- [provider_name](#provider_name) - specifying the authorization provider's name.

Accessing helper methods:

- [controller](#controller) - accessing controller context.
- [user](#user) - accessing current user object.

Customizing authorization operations:

- [authorize](#authorize) - checking permission and raising error if any. It's mostly used in controller.
- [authorized?](#authorized) - checking if user has access to given subject.
- [unauthorized?](#unauthorized) - checking if user has no access to given subject.
- [accessible_for](#accessible_for) - applying the scope that user has access to.
- [attributes_for](#attributes_for) - applying the attribute values that user can create/update.
- [permit_params](#permit_params) - whitelisting params for mass assignment.

How Wallaby applies authorization for framework:

- [CanCanCan](#cancancan)
- [Pundit](#pundit)

## Declaration

> Read more at [Authorizer Naming Convention](convention.md#authorizer)

Let's see how a authorizer can be created so that Wallaby knows its existence.

Similar to the way in Rails, create a custom authorizer for model `Product` inheriting from `Admin::ApplicationAuthorizer` (the base authorizer mentioned [above](#authorizer)) as below:

```ruby
# app/authorizers/product_authorizer.rb
class ProductAuthorizer < Admin::ApplicationAuthorizer
end
```

If `ProductAuthorizer` is taken, it is still possible to use another name (e.g. `Admin::ProductAuthorizer`). However, the attribute `model_class` must be specified. See [`model_class`](#model_class) for examples.

## abstract!

All authorizers will be preloaded and processed by Wallaby in order to build up the mapping between authorizers and models. If the authorizer is considered not to be proceesed, it can be flagged by using `abstract!`:

```ruby
# app/authorizers/admin/special_authorizer.rb
class Admin::SpecialAuthorizer < Admin::ApplicationAuthorizer
  abstract!
end
```

## model_class

According to Wallaby's [Authorizer Naming Convention](convention.md#authorizer), if a custom authorizer can not reflect the assication to the correct model, for example, as `Admin::ProductAuthorizer` to `Product`, it is required to specify the model class in the authorizer as below:

```ruby
# app/authorizers/admin/product_authorizer.rb
class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
  self.model_class = Product
end
```

## provider_name

Wallaby has implemented the following authorization adaptors for ActiveRecord and HER:

- `:cancancan` if CanCanCan is used. Learn more about [how Wallaby uses CanCanCan](#cancancan).
- `:pundit` if Pundit is used. Learn more about [how Wallaby uses Pundit](#pundit).
- `:default` if no authorization is in use.

And Wallaby can detect which authorization that might be in use. However, there is still a chance that Wallaby can't get it right.

In this case, for example, if Pundit is used, it can be configured as:

```ruby
# app/authorizers/admin/application_authorizer.rb
class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
  self.provider_name = :pundit
end
```

> NOTE: It's also recommended to specify the provider name even if Wallaby has successfully detected the right one to use.
> Since it will improve the performance as Wallaby won't do the detection on every request once `provider_name` is set.

# Helper Methods

## user

It's the reference of `current_user` from controller. To access `user`, it goes:

```ruby
# app/authorizers/admin/application_authorizer.rb
class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
  private
  def rescue_permission_exception(action, error)
    Notifier.notify user, action, error
  end
end
```

## controller

It's the reference of controller itself. To access `controller`, it goes:

```ruby
# app/authorizers/admin/application_authorizer.rb
class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
  private
  def rescue_permission_exception(action, error)
    controller.flash[:alert] = translate_message_for action, error
  end
end
```

## user

It's the reference of current user object. To access `user`, it goes:

```ruby
# app/authorizers/admin/application_authorizer.rb
class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
  private
  def audit_log(action)
    AuditLog.log action, user
  end
end
```

# Authorization

## authorize

This is the template method to check permission for given subject and raise `Wallaby::Forbidden` exception if user has no access. It's used by controller mostly.

To customize how to check permission for given subject, it goes:

```ruby
# app/authorizers/admin/application_authorizer.rb
class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
  def authorize(action, subject)
    controller.authorize! action, subject
    controller.authorize subject, "#{action}?"
  end
end
```

## authorized?

This is the template method that checks if user has access to given subject and returns true if so.

To customize how to check permission for given subject, it goes:

```ruby
# app/authorizers/admin/application_authorizer.rb
class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
  def authorized?(action, subject)
    controller.can?(action, subject) && controller.policy(subject).public_send("#{action}?")
  end
end
```

## unauthorized?

This is the template method that checks if user has no access to given subject and returns true if so. It's simply the opposite version of [authorized?](#authorized).

To customize how to check permission for given subject, it goes:

```ruby
# app/authorizers/admin/application_authorizer.rb
class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
  def unauthorized?(action, subject)
    !(controller.can?(action, subject) && controller.policy(subject).public_send("#{action}?"))
  end
end
```

## accessible_for

This is the template method to ensure user can only query the data that they are allowed to access.

To customize how to restrict the query, it goes:

```ruby
# app/authorizers/admin/application_authorizer.rb
class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
  def accessible_for(action, scope)
    query = scope.accessible_by controller.current_ability, action
    controller.policy_scope query
  end
end
```

## attributes_for

This is the template method to ensure user can only update the data with the value that they are allowed to assign.

To customize how to restrict the assignment, it goes:

```ruby
# app/authorizers/admin/application_authorizer.rb
class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
  def attributes_for(action, subject)
    controller.current_ability.attributes_for action, subject
    controller.policy(subject).public_send :attributes_for
  end
end
```

## permit_params

This is the template method to permit parameters for mass assignment.

To customize how to permit parameters, it goes:

```ruby
# app/authorizers/admin/application_authorizer.rb
class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
  def permit_params(action, subject)
    controller.policy(subject).public_send "permitted_attributes_for_#{action}"
  end
end
```

# How Wallaby Applies Authorization

## CanCanCan

### For `authorize`, `authorized?` and `unauthorized?`

Wallaby has implemented the support for general Rails resourcesful actions (`index`/`new`/`create`/`show`/`edit`/`update`/`destroy`), and they are also the actions that Wallaby will check against.

And because CanCanCan comes with default alias actions:

```ruby
# lib/cancan/ability/actions.rb
def default_alias_actions
  {
    read: %i[index show],
    create: [:new],
    update: [:edit]
  }
end
```

Therefore, when Wallaby checks permission against resourcesful actions, they will be mapped to CanCanCan's actions as below:

```ruby
authorizer.authorized? :index, Product # => Same as `can? :read, Product`
authorizer.authorized? :new, product # => Same as `can? :create, product`
authorizer.authorized? :create, product # => Same as `can? :create, product`
authorizer.authorized? :show, product # => Same as `can? :read, product`
authorizer.authorized? :edit, product # => Same as `can? :update, product`
authorizer.authorized? :update, product # => Same as `can? :update, product`
authorizer.authorized? :destroy, product # => Same as `can? :destroy, product`
```

### For `permit_params`

Since CanCanCan does not support this feature, therefore, Wallaby won't do anything either for `permit_params`.

## Pundit

### For `authorize`, `authorized?` and `unauthorized?`

As mentioned [above](#cancancan), when Wallaby checks permission against, they will work as how Pundit works:

```ruby
authorizer.authorized? :index, Product # => Same as `policy(Product).index?`
authorizer.authorized? :new, product # => Same as `policy(product).new?`
authorizer.authorized? :create, product # => Same as `policy(product).create?`
authorizer.authorized? :show, product # => Same as `policy(product).show?`
authorizer.authorized? :edit, product # => Same as `policy(product).edit?`
authorizer.authorized? :update, product # => Same as `policy(product).update?`
authorizer.authorized? :destroy, product # => Same as `policy(product).destroy?`
```

### For `attributes_for`

If the policy has implemented `attributes_for` and `attributes_for_#{action}`:

```ruby
# app/policies/product_policy.rb
class ProductPolicy
  def attributes_for_create
    product.published = false
  end

  def attributes_for
    product.published = !!product.published_at
  end
end
```

Then when Wallaby applies `attributes_for` restriction for `create` action, `published` will be set to `false`.
However, when Wallaby applies `attributes_for` for `udpate` action, `published` will be true if `published_at` is set.

### For `permit_params`

Similar to `attributes_for` above, if the policy has implemented `permit_params` and `permit_params_for_#{action}`:

```ruby
# app/policies/product_policy.rb
class ProductPolicy
  def permit_params_for_create
    [:name, :sku]
  end

  def permit_params
    [:name]
  end
end
```

Then when Wallaby applies `permit_params` restriction for `create` action, user will be able to set `name` and `sku`.
However, when Wallaby applies `permit_params` for `udpate` action, user will be able to update `name` only.
