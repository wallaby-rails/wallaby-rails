# Theme

> since 5.2.0

Wallaby utilizes both controller inheritance and [Rails Template Inheritance](http://guides.rubyonrails.org/layouts_and_rendering.html#template-inheritance) and makes theming possible to apply different look and feel, and even different frontend/backend implementation.

There are two ways to apply a theme:

- [Set theme_name](#theme_name)
- [Inherit from the theme controller](#theme-controller)

If interested, keep on reading:

- [How to develop a theme](#develop-a-theme)

## theme_name

If the theme is just a collection of HTML/CSS/Javascript files but contains no Rails files, to use the theme, it goes:

```ruby
class Admin::ApplicationController < Wallaby::ResourcesController
  self.theme_name = 'bootstrap4'
end
```

## Theme Controller

If the theme is a collection of HTML/CSS/Javascript/Rails files, assume that the controller for this theme is `NewThemeApplicationController`, then it goes:

```ruby
class Admin::ApplicationController < NewThemeApplicationController
end
```

Instead of inheriting from `Wallaby::ResourcesController`, make `Admin::ApplicationController` inherit from `NewThemeApplicationController`.

## Develop a theme

WIP
