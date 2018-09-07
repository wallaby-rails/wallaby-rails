# Authorizer

> since 5.2.0

Authorizer takes care of authorization as the name implies.

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

- [user](#user) - accessing user object.
- [context](#context) - accessing controller context.

Customizing authorization operations:

- [authorize](#authorize) - checking permission and raising error if any. It's mostly used in controller.
- [authorized?](#authorized) - checking if user has access to given subject.
- [unauthorized?](#unauthorized) - checking if user has no access to given subject.
- [accessible_for](#accessible_for) - applying the scope that user has access to.
- [attributes_for](#attributes_for) - applying the attribute values that user can create/update.
- [permit_params](#permit_params) - whitelisting params for mass assignment.

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

For version below 5.2.0, it is:

```ruby
# app/authorizers/admin/product_authorizer.rb
class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
  def self.model_class
    Product
  end
end
```

## provider_name

Wallaby has implemented support for authorization CanCanCan and Pundit for ActiveRecord and HER, and it can detect which authorization that might be in use.

However, there is still a chance that Wallaby can't get it right. In this case, it goes:

```ruby
# app/authorizers/admin/special_authorizer.rb
class Admin::SpecialAuthorizer < Admin::ApplicationAuthorizer
  self.provider_name = :cancancan
  self.provider_name = :pundit
end
```

# Helper Methods

## user

It's the reference of `current_user` from controller. To access `user`, it goes:

```ruby
# app/authorizers/admin/product_authorizer.rb
class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
  self.model_class = Product

  def rescue_permission_exception(action, error)
    Notifier.notify user, action, error
  end
end
```

## context

It's the reference of controller itself. To access `context`, it goes:

```ruby
# app/authorizers/admin/product_authorizer.rb
class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
  self.model_class = Product

  def check_creation_using_cancan_along_with_pundit(resource)
    context.can?(:create, resource) && context.policy(resource).created?
  end
end
```

# Authorization

There are two sets of implementation of [CanCanCan]() and [Pundit]() each for ActiveRecord and HER. Please refer to [API Document]() for details.

## authorize

This is the template method to check permission for given subject and raise `Wallaby::Unauthorized` exception if user has no access. It's used by controller mostly.

To customize how to check permission for given subject, it goes:

- if utilizing what Wallaby has implemented:

  ```ruby
  # app/authorizers/admin/product_authorizer.rb
  class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
    self.model_class = Product

    def authorize(action, subject)
      super
      raise Wallaby::Unauthorized if user.is_customer?
    end
  end
  ```

- or simply replacing this template method:

  ```ruby
  # app/authorizers/admin/product_authorizer.rb
  class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
    self.model_class = Product

    def authorize(action, subject)
      context.current_ability.authorize! action, subject
    end
  end
  ```

## authorized?

This is the template method that checks if user has access to given subject and returns true if so.

To customize how to check permission for given subject, it goes:

- if utilizing what Wallaby has implemented:

  ```ruby
  # app/authorizers/admin/product_authorizer.rb
  class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
    self.model_class = Product

    def authorized?(action, subject)
      super && !user.is_customer?
    end
  end
  ```

- or simply replacing this template method:

  ```ruby
  # app/authorizers/admin/product_authorizer.rb
  class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
    self.model_class = Product

    def authorized?(action, subject)
      context.current_ability.can? action, subject
    end
  end
  ```

## unauthorized?

This is the template method that checks if user has no access to given subject and returns true if so. It's simply the opposite version of [authorized?](#authorized).

To customize how to check permission for given subject, it goes:

- if utilizing what Wallaby has implemented:

  ```ruby
  # app/authorizers/admin/product_authorizer.rb
  class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
    self.model_class = Product

    def unauthorized?(action, subject)
      super || user.is_customer?
    end
  end
  ```

- or simply replacing this template method:

  ```ruby
  # app/authorizers/admin/product_authorizer.rb
  class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
    self.model_class = Product

    def unauthorized?(action, subject)
      context.current_ability.cannot? action, subject
    end
  end
  ```

## accessible_for

This is the template method to ensure user can only query the data that they are allowed to access.

To customize how to restrict the query, it goes:

- if utilizing what Wallaby has implemented:

  ```ruby
  # app/authorizers/admin/product_authorizer.rb
  class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
    self.model_class = Product

    def accessible_for(action, scope)
      query = super
      if user.is_customer?
        query.where(active: true)
      else
        query
      end
    end
  end
  ```

- or simply replacing this template method:

  ```ruby
  # app/authorizers/admin/product_authorizer.rb
  class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
    self.model_class = Product

    def accessible_for(action, scope)
      context.current_ability.accessible_by action, scope
    end
  end
  ```

## attributes_for

This is the template method to ensure user can only update the data with the value that they are allowed to assign.

To customize how to restrict the assignment, it goes:

- if utilizing what Wallaby has implemented:

  ```ruby
  # app/authorizers/admin/product_authorizer.rb
  class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
    self.model_class = Product

    def attributes_for(action, subject)
      super
      if user.is_customer?
        subject.published = false
      end
    end
  end
  ```

- or simply replacing this template method:

  ```ruby
  # app/authorizers/admin/product_authorizer.rb
  class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
    self.model_class = Product

    def attributes_for(action, subject)
      context.current_ability.attributes_for action, subject
    end
  end
  ```

## attributes_for

This is the template method to ensure user can only update the data with the value that they are allowed to assign.

To customize how to restrict the assignment, it goes:

- if utilizing what Wallaby has implemented:

  ```ruby
  # app/authorizers/admin/product_authorizer.rb
  class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
    self.model_class = Product

    def attributes_for(action, subject)
      super
      if user.is_customer?
        subject.published = false
      end
    end
  end
  ```

- or simply replacing this template method:

  ```ruby
  # app/authorizers/admin/product_authorizer.rb
  class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
    self.model_class = Product

    def attributes_for(action, subject)
      context.current_ability.attributes_for action, subject
    end
  end
  ```

