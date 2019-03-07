# Wallaby

[![Gem Version](https://badge.fury.io/rb/wallaby.svg)](https://badge.fury.io/rb/wallaby)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Travis CI](https://travis-ci.org/reinteractive/wallaby.svg?branch=master)](https://travis-ci.org/reinteractive/wallaby)
[![Maintainability](https://api.codeclimate.com/v1/badges/2abd1165bdae523dd2e1/maintainability)](https://codeclimate.com/github/reinteractive/wallaby/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2abd1165bdae523dd2e1/test_coverage)](https://codeclimate.com/github/reinteractive/wallaby/test_coverage)
[![Inch CI](https://inch-ci.org/github/reinteractive/wallaby.svg?branch=master)](https://inch-ci.org/github/reinteractive/wallaby)

Wallaby is a Rails engine for managing data. It can be easily and highly customized in a Rails way using decorators, controllers and views.

Below is animated screenshots of Wallaby:

[![Animated Demo](https://raw.githubusercontent.com/reinteractive/wallaby/master/docs/demo-animated.gif)](https://raw.githubusercontent.com/reinteractive/wallaby/master/docs/demo-animated.gif)

- See [Demo](https://wallaby-demo.herokuapp.com/admin/)
- See [API Reference](https://www.rubydoc.info/gems/wallaby)
- See [Documentation](docs/README.md) for customization guides
- See [Wiki](/reinteractive/wallaby/wiki) for more HOW-TOs
- See [Features and Requirements](docs/features.md)
- See [Change Logs](CHANGELOG.md)
- See [Get Started](#get-started)

Here are examples of sophisticated customization:

- Register the product on e-commence after it is created at controller level (see [Controller](docs/controller.md) for more):

    ```ruby
    # app/controllers/admin/products_controller.rb
    class Admin::ProductsController < Admin::ApplicationController
      self.model_class = Product

      def create
        super do
          register_product_on_ecommence(resource) if resource.errors.blank?
        end
      end
    end
    ```

- Customize to render the product description in markdown format (see [Decorator](docs/decorator.md) for more):

    ```ruby
    # app/decorators/product_decorators.rb
    class ProductDecorator < Admin::ApplicationDecorator
      self.show_fields[:description][:type] = 'markdown'
    end
    ```

    Then create the type partial accordingly (see [Type Partial](docs/view.md) for more):

    ```erb
    <% # app/views/admin/products/show/_markdown.html.erb %>
    <% markdowner = Redcarpet::Markdown.new(Redcarpet::Render::HTML, {}) %>
    <%= raw markdowner.render(value) %>
    ```

## Getting Started

1. Add wallaby gem to `Gemfile`:

    ```ruby
    # Gemfile
    gem 'wallaby'
    ```

2. Mount engine in `routes.rb`:

    ```ruby
    # config/routes.rb
    Rails.application.routes.draw do
      # ... other routes
      mount Wallaby::Engine => "/desired_path"
      # ... other routes
    end
    ```

3. Start Rails server

    ```shell
    rails server
    ```

4. Open Wallaby on at http::/localhost:3000/desired_path. That's it.

If authentication rather than Devise is used, authentication configuration will be required (see [Configuration - Authentication](docs/configuration.md#authentication)).

## Want to contribute?

Raise an issue, discuss and resolve!

## License

This project rocks and uses MIT-LICENSE.
