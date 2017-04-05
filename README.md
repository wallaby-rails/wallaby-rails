# Wallaby

![Travis CI](https://travis-ci.org/reinteractive/wallaby.svg) ![Code Climate](https://codeclimate.com/github/reinteractive/wallaby/badges/gpa.svg)

Wallaby is a Rails engine to manage data. It can be easily customized in a Rails way using controllers and views. You could have a play with the [demo here](https://wallaby-demo.herokuapp.com/admin/)

## Features

- It supports Devise and provides configuration to use your own authentication. For authorization, it supports CanCanCan.
- Easy setup, ready for use, neat looking. And you won't miss any of these features (search/pagination/sorting/form validation/flash messages).
- No DSL, pure Rails and minimum learning curve required. It's easy to customize things just by extending controllers and partials as you do for a normal Rails app, and it applies best practices such as Decorator and Service Object. (see [Customization](docs/CUSTOMIZATION.md))
- Possible to extend Wallaby to support not only ActiveRecord, but also other ORMs

### Support

`master` branch is for Rails 5:
- Use Bootstrap
- Ruby 2.2.\*, 2.3.\*
- Rails 5.\*
- ActiveRecord 5.\*
- Devise > 4.\*
- CanCanCan
- Postgres data types that ActiveRecord supports, including string, text, integer, float, decimal, datetime, time, date, daterange, numrange, tsrange, tstzrange, int4range, int8range, binary, boolean, bigint, xml, tsvector, hstore, inet, cidr, macaddr, uuid, json, jsonb, ltree, citext, point, bit, bit_varying and money
- Additional support for types including password, email and color
- Handle all kinds of ActiveRecord associations, including polymorphic associations
- Handle namespaced models, e.g. `Order::Item`

`rails4` branch is for Rails 4:
- Ruby 2.1.\*, 2.2.\*
- Use Bootstrap
- Rails 4.\*
- ActiveRecord 4.\*
- Devise 3.\* to 5.\*
- CanCanCan
- All Postgres data types that ActiveRecord supports, including string, text, integer, float, decimal, datetime, time, date, daterange, numrange, tsrange, tstzrange, int4range, int8range, binary, boolean, bigint, xml, tsvector, hstore, inet, cidr, macaddr, uuid, json, jsonb, ltree, citext, point, bit, bit_varying and money
- Additional support for types including password, email and color
- Handle all kinds of ActiveRecord associations, including polymorphic associations
- Handle namespaced models, e.g. `Order::Item`

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

Then you are all set to open Wallaby on your local machine at `/the_path_you_like` once you have the Rails server up.

If you are using authentication rather than Devise, you might need to continue with the following section to do authentication configuration.

## Configuration

### Authentication

There are two ways to set up authentication:

1. Easily tell Wallaby which controller to inherit from. The controller should have `authenticate_user!` and `current_user` implemented:

    ```ruby
    #!config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.base_controller = MySecurityController
    end
    ```

    Once this is set, Wallaby will automatically pick up the above mentioned authentication methods (which is compatible with Devise), not to mention all functionalities including application helpers, before_action and etc.

2. You are able to custom authentication by configuring the `authenticate` and `current_user` options as below example:

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

For more configurations and How-Toes, see [Customization](docs/CUSTOMIZATION.md).

## License
This project rocks and uses MIT-LICENSE.
