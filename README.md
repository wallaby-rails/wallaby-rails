# Wallaby

[![Gem Version](https://badge.fury.io/rb/wallaby.svg)](https://badge.fury.io/rb/wallaby)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Travis CI](https://travis-ci.org/reinteractive/wallaby.svg)](https://travis-ci.org/reinteractive/wallaby)
[![Maintainability](https://api.codeclimate.com/v1/badges/2abd1165bdae523dd2e1/maintainability)](https://codeclimate.com/github/reinteractive/wallaby/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2abd1165bdae523dd2e1/test_coverage)](https://codeclimate.com/github/reinteractive/wallaby/test_coverage)
[![Inch CI](https://inch-ci.org/github/reinteractive/wallaby.svg?branch=master)](https://inch-ci.org/github/reinteractive/wallaby)

Wallaby is a Rails engine for managing data. It can be easily customized in a Rails way using controllers and views. You can play with the [demo here](https://wallaby-demo.herokuapp.com/admin/)

## Features

- Easy setup, ready for use.
- It allows you to customise things in different aspects (e.g. Decorator/Controller/Servicer/View)
- Advanced colon search, for example, `ordered_at:>2017-07-01 name_start_with:^tian`
- It allows to predefine filters.
- It supports Devise and provides configuration to use your own authentication. For authorization, it supports CanCanCan.
- It handles all kinds of ActiveRecord associations, even if they are polymorphic.
- It handles Single Table Inheritance (STI).
- It supports all 37 data types that ActiveRecord 5.0.* supports for PostgreSQL, MySql and Sqlite.
- Data can be exported to CSV.

### Support

For Rails 5, use the `master` branch. It has the following features:
- Ruby 2.2.\*, 2.3.\*
- Rails 5.\*
- ActiveRecord 5.\*
- Devise > 4.\*
- CanCanCan
- Bootstrap 3

For Rails 4, use the `rails4` branch. It has the following features:
- Ruby 2.1.\*, 2.2.\*
- Rails 4.\*
- ActiveRecord 4.\*
- Devise 3.\* to 5.\*
- CanCanCan
- Bootstrap 3

> NOTE: development for Rails 4 has been ceased.

Both branches provide support for the following:
- all Postgres data types that ActiveRecord supports, including string, text, integer, float, decimal, datetime, time, date, daterange, numrange, tsrange, tstzrange, int4range, int8range, binary, boolean, bigint, xml, tsvector, hstore, inet, cidr, macaddr, uuid, json, jsonb, ltree, citext, point, bit, bit_varying and money
- types such as password, email and color
- ActiveRecord associations, including polymorphic associations
- namespaced models, e.g. `Order::Item`

## What's new

See [Changelog](CHANGELOG.md)

## Installation

1. Add wallaby gem to `Gemfile`:

    ```ruby
    #!Gemfile
    gem 'wallaby'
    ```

2. Mount engine in `routes.rb`:

    ```ruby
    #!config/routes.rb
    Rails.application.routes.draw do
      mount Wallaby::Engine => "/the_path_you_like"
      # ... other routes
    end
    ```

3. Start the Rails server

4. Open Wallaby on your local machine at `/the_path_you_like`.

If you are using authentication rather than Devise, you might need to continue with the following section to do authentication configuration.

## Configuration

### Authentication

There are two ways to set up authentication:

1. Simply tell Wallaby which controller to inherit from. The controller should have `authenticate_user!` and `current_user` implemented:

    ```ruby
    #!config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.base_controller = MySecurityController
    end
    ```

    Once this is set up, Wallaby will automatically pick up the two authentication methods mentioned above (which are compatible with Devise), along with all functionalities including application helpers, before_action, etc.

2. You can customise authentication by configuring the `authenticate` and `current_user` options as per the example below:

    ```ruby
    #!config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.security.authenticate do
        # you could use any controller methods inside this block
        authenticate_or_request_with_http_basic do |username, password|
          username == 'too_simple' && password == 'too_naive'
        end
      end

      config.security.current_user do
        # you could use any controller methods inside this block
        Class.new do
          # email field is for gravator profile image
          def email
            'user@example.com'
          end
        end.new
      end
    end
    ```

For more configurations and How-Tos, see [Customization](docs/README.md).

## License
This project rocks and uses MIT-LICENSE.
