# Paginator

> since 5.2.0

Paginator contains a collection of CRUD operations that can be overridden and tailered to the needs.

First of all, it's always recommended to create a base paginator class `Admin::ApplicationPaginator` as below, so that devs can have better control of developing global changes/functions:

```ruby
# app/paginators/admin/application_paginator.rb
class Admin::ApplicationPaginator < Wallaby::ModelPaginator
end
```

> See [Mapping - Paginator](configuration.md#paginator) for the configuration if `Admin::ApplicationPaginator` is taken for other purpose.

Starting with:

- [Declaration](#declaration)

Configuration can be set for:

- [base_class!](#base_class) - flagging as base class.
- [model_class](#model_class) - specifying the model class.

Accessing helper methods:

- [collection](#collection) - accessing collection object.
- [params](#params) - accessing parameters object.

Customizing pagination operations:

- [paginatable?](#paginatable) - telling Wallaby whether the collection contains pagination information (e.g. total count, page size and number).
- [total](#total) - returning the total number of collection.
- [page_size](#page_size) - returning page size of the collection.
- [page_number](#page_number) - returning page number of the collection.

## Declaration

> Read more at [Paginator Naming Convention](convention.md#paginator)

Let's see how a paginator can be created so that Wallaby knows its existence.

Similar to the way in Rails, create a custom paginator for model `Product` inheriting from `Admin::ApplicationPaginator` (the base paginator mentioned [above](#paginator)) as below:

```ruby
# app/paginators/product_paginator.rb
class ProductPaginator < Admin::ApplicationPaginator
end
```

If `ProductPaginator` is taken, it is still possible to use another name (e.g. `Admin::ProductPaginator`). However, the attribute `model_class` must be specified. See [`model_class`](#model_class) for examples.

## base_class!

All paginators will be preloaded and processed by Wallaby in order to build up the mapping between paginators and models. If the paginator is considered not to be proceesed, it can be flagged by using `base_class!`:

```ruby
# app/paginators/admin/special_paginator.rb
class Admin::SpecialPaginator < Admin::ApplicationPaginator
  base_class!
end
```

## model_class

According to Wallaby's [Paginator Naming Convention](convention.md#paginator), if a custom paginator can not reflect the assication to the correct model, for example, as `Admin::ProductPaginator` to `Product`, it is required to specify the model class in the paginator as below:

```ruby
# app/paginators/admin/product_paginator.rb
class Admin::ProductPaginator < Admin::ApplicationPaginator
  self.model_class = Product
end
```

# Helper Methods

## collection

It's the reference of collection. To access `collection`, it goes:

```ruby
# app/paginators/admin/application_paginator.rb
class Admin::ApplicationPaginator < Wallaby::ModelPaginator
  def paginatable?
    collection.respond_to? :total_count
  end
end
```

## params

It's the reference of params. To access `params`, it goes:

```ruby
# app/paginators/admin/application_paginator.rb
class Admin::ApplicationPaginator < Wallaby::ModelPaginator
  def paginatable?
    params.has_key? :total_count
  end
end
```

# Pagination

## paginatable?

This is the template method to tell Wallaby whether the collection contains pagination information.

Since most of the models should behave similar, to customize this template, it mostly happen in base paginator as below:

```ruby
# app/paginators/admin/application_paginator.rb
class Admin::ApplicationPaginator < Wallaby::ModelPaginator
  def paginatable?
    params.has_key? :total_count
  end
end
```

## total

This is the template method to return the total number of collection.

Since most of the models should behave similar, to customize this template, it mostly happen in base paginator as below:

```ruby
# app/paginators/admin/application_paginator.rb
class Admin::ApplicationPaginator < Wallaby::ModelPaginator
  def total
    collection.size
  end
end
```

## page_size

This is the template method to return the page size of collection.

Since most of the models should behave similar, to customize this template, it mostly happen in base paginator as below:

```ruby
# app/paginators/admin/application_paginator.rb
class Admin::ApplicationPaginator < Wallaby::ModelPaginator
  def page_size
    params[:page_size] || params[:per]
  end
end
```

## page_number

This is the template method to the page number of collection.

Since most of the models should behave similar, to customize this template, it mostly happen in base paginator as below:

```ruby
# app/paginators/admin/application_paginator.rb
class Admin::ApplicationPaginator < Wallaby::ModelPaginator
  def page_number
    params[:page] || 1
  end
end
```
