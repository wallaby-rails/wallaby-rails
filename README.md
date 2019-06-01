# Wallaby

[![Gem Version](https://badge.fury.io/rb/wallaby.svg)](https://badge.fury.io/rb/wallaby)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Travis CI](https://travis-ci.org/reinteractive/wallaby.svg?branch=master)](https://travis-ci.org/reinteractive/wallaby)
[![Maintainability](https://api.codeclimate.com/v1/badges/2abd1165bdae523dd2e1/maintainability)](https://codeclimate.com/github/reinteractive/wallaby/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2abd1165bdae523dd2e1/test_coverage)](https://codeclimate.com/github/reinteractive/wallaby/test_coverage)
[![Inch CI](https://inch-ci.org/github/reinteractive/wallaby.svg?branch=master)](https://inch-ci.org/github/reinteractive/wallaby)

Wallaby is a Rails engine for data manipulation and display. It can be easily and highly customized in a Rails way using decorators, controllers, and views.

Below is animated screenshots of Wallaby:

[![Animated Demo](https://raw.githubusercontent.com/reinteractive/wallaby/master/docs/demo-animated.gif)](https://raw.githubusercontent.com/reinteractive/wallaby/master/docs/demo-animated.gif)

- Try out [Demo](https://wallaby-demo.herokuapp.com/admin/)
- Check out [API Reference](https://www.rubydoc.info/gems/wallaby)
- See [Documentation](docs/README.md) for customization guides
- See [Wiki](/reinteractive/wallaby/wiki) for more HOW-TOs
- See [Features and Requirements](docs/features.md)
- See [Change Logs](CHANGELOG.md)
- [Get Started](#get-started) below

> NOTE: from 5.2.0, Wallaby has migrated Bootstrap from 3 to 4. Please consult [Migrating to v4](https://v4-alpha.getbootstrap.com/migration/)

Here are some sophisticated customization examples:

- To render markdown description into HTML for show page, it is required to configure custom type in the `Decorator` ([read more](docs/decorator.md)) below:

  ```ruby
  # app/decorators/product_decorators.rb
  class ProductDecorator < Admin::ApplicationDecorator
    self.show_fields[:description][:type] = 'markdown'
  end
  ```

  Then create the `Type Partial` ([read more](docs/view.md)) accordingly:

  ```erb
  <% # app/views/admin/products/show/_markdown.html.erb %>
  <% markdowner = Redcarpet::Markdown.new(Redcarpet::Render::HTML, {}) %>
  <%= raw markdowner.render(value) %>
  ```

- Register the product on e-commence after it is created at `Controller` ([read more](docs/controller.md)) level:

  ```ruby
  # app/controllers/admin/products_controller.rb
  class Admin::ProductsController < Admin::ApplicationController
    self.model_class = Product

    def create
      create! do |format|
        register_product_on_ecommence(resource) if resource.errors.blank?
      end
    end
  end
  ```

## Getting Started

1. Add wallaby gem to `Gemfile`:

  ```ruby
  # Gemfile
  gem 'wallaby'
  ```

2. Install generator:

  ```shell
  rails g wallaby:install admin
  ```

  For version below 5.2.0, mount it to the `/admin`:

  ```ruby
  # config/routes.rb
  Rails.application.routes.draw do
    # ... other routes
    mount Wallaby::Engine, at: '/admin'
    # ... other routes
  end
  ```

3. Start Rails server

  ```shell
  rails server
  ```

4. Open Wallaby on at http://localhost:3000/admin and start exploring!

## Want to contribute?

Raise an issue, discuss and resolve!

## License

This project rocks and uses MIT-LICENSE.
