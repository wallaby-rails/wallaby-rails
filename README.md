# Wallaby

[![Gem Version](https://badge.fury.io/rb/wallaby.svg)](https://badge.fury.io/rb/wallaby)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Travis CI](https://travis-ci.org/reinteractive/wallaby.svg)](https://travis-ci.org/reinteractive/wallaby)
[![Maintainability](https://api.codeclimate.com/v1/badges/2abd1165bdae523dd2e1/maintainability)](https://codeclimate.com/github/reinteractive/wallaby/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/2abd1165bdae523dd2e1/test_coverage)](https://codeclimate.com/github/reinteractive/wallaby/test_coverage)
[![Inch CI](https://inch-ci.org/github/reinteractive/wallaby.svg?branch=master)](https://inch-ci.org/github/reinteractive/wallaby)

Wallaby is a Rails engine for managing data. It can be easily customized in a Rails way using decorators, controllers and views.

[![Animated Demo](https://raw.githubusercontent.com/reinteractive/wallaby/master/docs/demo-animated.gif)](https://raw.githubusercontent.com/reinteractive/wallaby/master/docs/demo-animated.gif)

- [Demo](https://wallaby-demo.herokuapp.com/admin/)
- [Documentation](docs/README.md)
- [Search Manual](docs/search_manual.md)
- [Features and Requirements](docs/features.md)
- [Change Logs](CHANGELOG.md)

## Getting Started

1. Add wallaby gem to `Gemfile`:

    ```ruby
    #!./Gemfile
    gem 'wallaby'
    ```

2. Mount engine in `routes.rb`:

    ```ruby
    #!./config/routes.rb
    Rails.application.routes.draw do
      # ... other routes
      mount Wallaby::Engine => "/the_path_you_like"
      # ... other routes
    end
    ```

3. Start Rails server

4. Open Wallaby on your local machine at `/the_path_you_like`.

If you are using authentication rather than Devise, you will need to configure authentication as [Configuration - Authentication](docs/configuration.md#authentication) describes.

## License
This project rocks and uses MIT-LICENSE.
