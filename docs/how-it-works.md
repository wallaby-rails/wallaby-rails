---
title: How It Works
layout: default
nav_order: 2
---

# How It Works
{: .no_toc }

This document outlines how things work behind the scenes of Wallaby:

## Table of Contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Resourcesful Actions

First of all, what does Wallaby do exactly? In short:

**Rails provides the framework to build resourcesful actions, Wallaby implements them for you.**

For example, model and controller for `Blog` are created using generators:

```sh
$ rails generate model Blog title:string text:text
$ rails generate controller Blogs
```

As soon as you include the module `Wallaby::ResourcesConcern` for `BlogsController` (or simply inherit from `Wallaby::ResourcesController`):

```ruby
class BlogsController < ApplicationController
  include Wallaby::ResourcesConcern
end
```

You will have all the resourcesful actions (`index`, `new`, `create`, `show`, `edit`, `update` and `destroy`) working immediately without the need of writing any boilerplate code.

In addition, Wallaby covers the other aspects including authentication, authorization and pagination.

Let's take a look at one of the resourcesful actions - `update` that Wallaby has implemented:

```ruby
def update(location: -> { { action: :show } }, **responder_options, &block)
  current_authorizer.authorize :update, resource
  current_servicer.update resource, update_params
  respond_with resource, responder_options.merge(location: location), &block
end
```

Basically, it is the same as what the following boilerplate code does:

```ruby
def update
  @resource = Blog.find params[:id]
  authorize @resource # Pundit
  @resource.update params.fetch(:blog, {}).permit(:title, :text)
  respond_with @resource # Responder
end
```

The magic is that Wallaby detects what ORM model it's dealing with,
so that it uses the corresponding ORM [servicer](servicer.md)
to handle the data access (e.g. `resource` object) and manipulation (e.g. its `update` method).
Wallaby also detects the authorization framework in use and
uses the [authorizer](authorizer.md) to carry out the authorization check for the given resource.
Similarly, Wallaby uses [paginator](paginator.md) for `index` action to paginate the collection.

Wallaby currently supports ActiveRecord together with CanCanCan and Pundit.
For any other model that is not ActiveModel-like, [Custom mode](custom.md) allows Wallaby to support them.

## Decorator & Views

In Wallaby, the core of view layer is to iterate a decorator's `*_field_names` and render the corresponding [type partial](view.md) for each field, using the type defined in the decorator's `*_fields` metadata.

The [decorator](decorator.md) holds the view metadata for the index, show and form (new/edit) pages — which fields to display, in which order, and how each field should be rendered.

## Admin Interface

When Wallaby is mounted at a path (e.g. `/admin`), it can be used as an admin interface. All URLs prefixed with `/admin` will be handled by Wallaby's resources router, which dispatches resourcesful Rails requests to the corresponding actions. See [Route](route.md) for how to declare the routes.

## How Customization is Possible

Wallaby follows Rails conventions so that most customizations are class-based and convention-driven:

- Controllers, decorators, servicers, authorizers and paginators are resolved by [naming conventions](convention.md).
- The [controller](api-references/controller.md) actions can be customized by overriding the template methods (e.g. `index!`, `create!`).
- View behaviors (fields, labels, types) are customized through the [decorator](decorator.md), and the markup through [type partials](view.md) and [frontend partials](frontend.md).
- Data access and persistence are customized through the [servicer](servicer.md), authorization through the [authorizer](authorizer.md), and pagination through the [paginator](paginator.md).
- Global defaults are configured in the [configuration](configuration.md) initializer and/or the base controller class.