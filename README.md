# Wallaby

[![Gem Version](https://badge.fury.io/rb/wallaby.svg)](https://badge.fury.io/rb/wallaby)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Travis CI](https://travis-ci.org/wallaby-rails/wallaby.svg?branch=master)](https://travis-ci.org/wallaby-rails/wallaby)
[![Maintainability](https://api.codeclimate.com/v1/badges/2abd1165bdae523dd2e1/maintainability)](https://codeclimate.com/github/wallaby-rails/wallaby/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2abd1165bdae523dd2e1/test_coverage)](https://codeclimate.com/github/wallaby-rails/wallaby/test_coverage)
[![Inch CI](https://inch-ci.org/github/wallaby-rails/wallaby.svg?branch=master)](https://inch-ci.org/github/wallaby-rails/wallaby)

Wallaby is a Rails engine that autocompletes the resourceful controller and view for a given ORM model (ActiveRecord, HER) for admin interface and other purposes.

It can be extended to support any ORM model and can be easily and deeply customized at MVC's different aspects by using [decorators](docs/decorator.md), [controllers](docs/controllers.md), [type partials/cells](docs/view.md), [servicers](docs/servicer.md), [authorizers](docs/authorizer.md), [paginators](docs/paginator.md) and [themes](docs/theme.md).

[Try the demo here](https://wallaby-demo.herokuapp.com/admin/).

[![Animated Demo](https://raw.githubusercontent.com/wallaby-rails/wallaby/master/docs/demo-animated.gif)](https://raw.githubusercontent.com/wallaby-rails/wallaby/master/docs/demo-animated.gif)

## Install

Add Wallaby to `Gemfile`.

```ruby
# Gemfile
gem 'wallaby'
```

And re-bundle.

```shell
bundle install
```

## Basic Usage

### As Admin Interface

Just mount Wallaby engine to desired path, e.g. `/admin` in `config/routes.rb`.

```ruby
# config/routes.rb
mount Wallaby::Engine, at: '/admin'
```

Or run installer to generate default application classes/templates under namespace e.g. `Admin` and mount Wallaby engine to path `/admin`.

```shell
rails g wallaby:install admin
```

Restart rails server, and visit http://localhost:3000/admin to start exploring!

### For General Purposes

Instead of using Rails scaffold generator to generate all the boilerplate code, Wallaby can help to quickly get the pages up for ordinary resourceful actions.

For example, if a model `Blog` is generated:

```shell
rails generate model blog title:string body:text
rails db:migrate
```

There are two ways to spin up things, choose what fits best:

- add resources route to `config/routes.rb` using `wresources` helper without any needs of customization

  ```ruby
  # config/routes.rb
  wresources :blogs, controller: 'wallaby/resources'
  ```

- add blogs controller for later customization

  ```ruby
  # app/controllers/blogs_controller.rb
  class BlogsController < Wallaby::ResourcesController
  end
  ```

  then add corresponding resources route using origin Rails `resources` helper

  ```
  # config/routes.rb
  resources :blogs
  ```

Restart rails server, and visit http://localhost:3000/blogs to give it a taste!

## Documentation

- [Features and Requirements](docs/features.md)
- [Documentation](docs/README.md) for more usages and customization guides
- [API Reference](https://www.rubydoc.info/gems/wallaby)
- [Change Logs](CHANGELOG.md)

## Want to contribute?

Raise an issue, discuss and resolve!

## License

This project uses [MIT License](LICENSE).
