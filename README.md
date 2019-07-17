# Wallaby

[![Gem Version](https://badge.fury.io/rb/wallaby.svg)](https://badge.fury.io/rb/wallaby)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Travis CI](https://travis-ci.org/reinteractive/wallaby.svg?branch=master)](https://travis-ci.org/reinteractive/wallaby)
[![Maintainability](https://api.codeclimate.com/v1/badges/2abd1165bdae523dd2e1/maintainability)](https://codeclimate.com/github/reinteractive/wallaby/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2abd1165bdae523dd2e1/test_coverage)](https://codeclimate.com/github/reinteractive/wallaby/test_coverage)
[![Inch CI](https://inch-ci.org/github/reinteractive/wallaby.svg?branch=master)](https://inch-ci.org/github/reinteractive/wallaby)

Wallaby is a Rails engine that provides a default implementation of the resourceful controller and view for a given ORM model (ActiveRecord, HER or others) for admin interface and other purposes.

It can be easily and deeply customized at MVC's different aspects by using [decorators](docs/decorator.md), [controllers](docs/controllers.md), [type partials/cells](docs/view.md), [servicers](docs/servicer.md), [authorizers](docs/authorizer.md), [paginators](docs/paginator.md) and [themes](docs/theme.md). [Try the demo here](https://wallaby-demo.herokuapp.com/admin/).

[![Animated Demo](https://raw.githubusercontent.com/reinteractive/wallaby/master/docs/demo-animated.gif)](https://raw.githubusercontent.com/reinteractive/wallaby/master/docs/demo-animated.gif)

## Install

Add Wallaby to `Gemfile` and re-bundle.

```ruby
# Gemfile
gem 'wallaby'
```

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

Instead of using Rails scaffold generator to generate all the boilerplate code, Wallaby can help to quickly get the pages up for typical resourceful actions.

For example, if a model `Blog` is generated:

```shell
rails generate model blog title:string body:text
rails db:migrate
```

Add resources route to `config/routes.rb` using `wresources`

```ruby
# config/routes.rb
wresources :blogs, controller: 'wallaby/resources'
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

This project rocks and uses MIT-LICENSE.
