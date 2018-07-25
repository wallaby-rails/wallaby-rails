## Theme

> Since 5.2.0

Wallaby utilizes [Rails Template Inheritance](http://guides.rubyonrails.org/layouts_and_rendering.html#template-inheritance) and makes theming possible with different look and feel, and even different frontend/backend implementation.

There are two ways to apply a theme:

- [Set the theme name](#theme-name)
- [Inherit from a theme controller](#theme-controller)

If interested, keep on reading:

- [How to develop a theme](#how-to-develop-a-theme)
- [How theme works](#how-theme-works)

### Theme Name

If the theme is just a collection of HTML/CSS/Javascript files but contains no Rails files, it can be configured as below:

```ruby
class Admin::ApplicationController < Wallaby::ResourcesController
  self.theme_name = 'bootstrap4'
end
```

### Theme Controller

If the theme is a collection of HTML/CSS/Javascript/Rails files, assume that the controller for this theme is `NewThemeApplicationController`, then what needs to be done is pretty simple:

```ruby
class Admin::ApplicationController < NewThemeApplicationController
end
```

Instead of inheriting from `Wallaby::ResourcesController`, make `Admin::ApplicationController` inherit from `NewThemeApplicationController`.

### How to develop a theme

> WIP

### How theme works

> WIP
