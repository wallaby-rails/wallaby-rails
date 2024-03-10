# [Wallaby::View](https://github.com/wallaby-rails/wallaby-view)

[![Gem Version](https://badge.fury.io/rb/wallaby-view.svg)](https://badge.fury.io/rb/wallaby-view)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Travis CI](https://travis-ci.com/wallaby-rails/wallaby-view.svg?branch=master)](https://travis-ci.com/wallaby-rails/wallaby-view)
[![Maintainability](https://api.codeclimate.com/v1/badges/d3e924dd70cc12562eab/maintainability)](https://codeclimate.com/github/wallaby-rails/wallaby-view/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/d3e924dd70cc12562eab/test_coverage)](https://codeclimate.com/github/wallaby-rails/wallaby-view/test_coverage)
[![Inch CI](https://inch-ci.org/github/wallaby-rails/wallaby-view.svg?branch=master)](https://inch-ci.org/github/wallaby-rails/wallaby-view)

**Wallaby::View** extends Rails template/partial inheritance chain to be able to:

- organize partials in `#{controller_path}/#{action}` fashion on top of Rails' controller fashion by extending Rails' [\_prefixes](https://github.com/rails/rails/blob/master/actionview/lib/action_view/view_paths.rb#L90).
- configure the theme (a set of layout/templates/partials starting with the theme prefix).

## Install

Add **Wallaby::View** to `Gemfile`.

```ruby
gem 'wallaby-view'
```

And re-bundle.

```shell
bundle install
```

Include **Wallaby::View** in the controller (e.g. **ApplicationController**):

```ruby
# app/controllers/application_controller
class ApplicationController < ActionController::Base
  include Wallaby::View
end
```

## What It Does

For example, given the following controllers:

```ruby
# app/controllers/application_controller
class ApplicationController < ActionController::Base
  include Wallaby::View
end

# app/controllers/admin/application_controller
class Admin::ApplicationController < ::ApplicationController
  self.theme_name = 'secure'
end

# app/controllers/admin/users_controller
class Admin::UsersController < Admin::ApplicationController
  self.theme_name = 'account'
  self.prefix_options = { edit: 'form' }
end
```

By using **Wallaby::View**, a template/partial for the `admin/application#edit` action will be looked up in the following folder order from top to bottom:

- app/views/admin/application/edit
- app/views/admin/application
- app/views/secure/edit
- app/views/secure
- app/views/application/edit
- app/views/application

Then it depends on how a relative partial should be shared, the partial can be created in one of the above folders.
For example, if a `form` partial is designed specifically for `admin/application#edit` action, then it can be created in `admin/application/edit` folder as below:

```erb
<%# app/views/admin/application/edit/_form.html.erb %>
a form for `admin/application#edit`
```

Then in the `admin/application#edit` template, rendering the relative `form` partial will result in using the above partial.

```erb
<%# app/views/admin/application/edit.html.erb %>
<% render 'form' %>
```

For `admin/users#edit` action, since `prefix_options` option is set, `edit` will be mapped to `form`, and `form` will be added to the prefixes as well.
Therefore, the lookup folder order of `admin/users#edit` becomes:

- app/views/admin/users/edit
- app/views/admin/users/form
- app/views/admin/users
- app/views/secure/edit
- app/views/secure/form
- app/views/secure
- app/views/admin/application/edit
- app/views/admin/application/form
- app/views/admin/application
- app/views/secure/edit
- app/views/secure/form
- app/views/secure
- app/views/application/edit
- app/views/application/form
- app/views/application

## Advanced Usage

It is possible to override the `_prefixes` method to make more changes to the prefixes before suffixing them with the action name:

```ruby
class ApplicationController < ActionController::Base
  include Wallaby::View

  def _prefixes
    super do |prefixes|
      prefixes << 'last_resort'
    end
  end
end
```

Then the lookup folder order of e.g. `application#edit` becomes:

- app/views/application/edit
- app/views/application
- app/views/last_resort/edit
- app/views/last_resort

## Documentation

- [API Reference](https://www.rubydoc.info/gems/wallaby-view)
- [Change Logs](https://github.com/wallaby-rails/wallaby-view/blob/master/CHANGELOG.md)

## Want to contribute?

Raise an [issue](https://github.com/wallaby-rails/wallaby-view/issues/new), discuss and resolve!

## License

This project uses [MIT License](https://github.com/wallaby-rails/wallaby-view/blob/master/LICENSE).
