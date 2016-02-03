# Wallaby

![Travis CI](https://travis-ci.org/reinteractive-open/wallaby.svg)

Wallaby is a Rails engine to manage your data. You could have a play with the [demo here](https://wallaby-demo.herokuapp.com/admin/)

## What's new

### v0.0.5

1. Resolved Autoload
2. Reduced view path set and speeded up page render
3. Broke down resources_helper into styling_helper/links_helper/form_helper
4. Added partial for type inet

For more, see [Changlog](CHANGELOG.md)

## Yet another Rails admin engine? Why?

Because this engine is built in Rails way! You could do further development like what you normally do for a Rails app (see [Customization](CUSTOMIZATION.md)).

## Support

Rails 4.*, ActiveRecord, Devise

## Installation

1. Add the following lines to `Gemfile`:

    ```ruby
    gem 'bootstrap-sass'
    gem 'jquery-rails'
    gem 'kaminari'
    gem 'wallaby'
    ```

2. Add engine routes to `routes.rb`:

    ```ruby
    Rails.application.routes.draw do
      mount Wallaby::Engine => "/the_path_you_like"
      # ... other routes
    end
    ```

Then you are all set to visit wallaby on your local machine at `/the_path_you_like`, unless you need to do the following configuration.

## Configuration

### Authentication

You could set up authentication via:

1. Easily tell wallaby which controller to inherit from:

    ```ruby
    # config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.base_controller = OurSecurityController
    end
    ```

    Once this is set, wallaby will immediately be able to use `authenticate_user!` and `current_user` methods to do authentication (which is compatible with Devise), not to mention all functionalities including helper, before_action and etc (which will be benefitial for further development upon wallaby, see [Customization](CUSTOMIZATION.md)).

2. You could still use custom authentication by configuring the `authenticate` and `current_user` options as below:

    ```ruby
    # config/initializers/wallaby.rb
    Wallaby.config do |config|
      config.security.authenticate do
        # you could use any controller methods here
        authenticate_or_request_with_http_basic do |username, password|
          username == 'too_simple' && password == 'too_naive'
        end
      end

      config.security.current_user do
        # you could use any controller methods here
        Class.new do
          # email here is for gravator profile image
          def email
            'user@example.com'
          end
        end.new
      end
    end
    ```

For more configurations and how to do further development upon wallaby, see [Customization](CUSTOMIZATION.md).

## License
This project rocks and uses MIT-LICENSE.
