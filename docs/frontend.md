# Frontend

Learn more about the customization for frontend:

- [Partials](#partials) - customizing the components on the page, e.g. title, logo, header.
- [Stylesheet](#stylesheet) - extending and customizing the look and feel by CSS stylesheet.
- [Javascript](#Javascript) - extending and customizing user interaction by JS.

> NOTE: If a third party theme is used, its frontend implementation might be different from Wallaby, please check out its document to find out how to do customization for its frontend.

## Partials

Same as [Type Partial](view.md#type-partial), Wallaby utilizes and extends [Template Inheritance](https://guides.rubyonrails.org/layouts_and_rendering.html#template-inheritance) to look for partial in controller and action inheritance chain.

The following partials can be customized using template inheritance:

- `title` - customizing page title.
- `logo` - customizing logo.
- `header` - customizing header section.
- `footer` - customizing footer section.
- `frontend` (since 5.2.0) - customizing CSS and JS libraries in `<head>` tag.
- `user_menu` - customizing links for logged-in user.
- `navs` - customizing links/items for top navigation bar.
- `index_action` - customizing links/items for dropdown button next to search form, only used by `index` page.
- `resource_action` - customizing links for a resource in the data table, only used by `index` page.
- `resource_navs` - customizing links for resource navigation under the resource's title, only used by `show`/`new`/`create`/`edit`/`update` page.

For example, given that Wallaby is mounted under path `/admin` (see how Wallaby is mounted in [route](route.md)), to customize `title` for model `Product`, it goes:

- if the partial is only needed for model `Product` when no controller is created for `Product`, then it can be created as:

  ```
  app/views/admin/products/_title.html.erb
  ```

- if the partial is only needed for the controller created for `Product`, then it can be created as:

  ```ruby
  # app/controllers/backend/goods_controller.rb
  class Backend::GoodsController < Admin::ApplicationsController
    self.theme_name = 'foundation'
    self.model_class = Product
  end
  ```

  ```
  app/views/backend/goods/_title.html.erb
  ```

- if the partial is supposed to be shared among the app when base controller (e.g. `Admin::ApplicationController`) is created, then it can be created as:

  ```
  app/views/admin/application/_title.html.erb
  ```

## Stylesheet

There are a couple of ways to customize stylesheet:

- (since 5.2.0) Create `frontend` partial mentioned [above](#partials). For example:

  ```erb
  <%# app/views/admin/application/_frontend.html.erb %>
  <%= stylesheet_link_tag 'admin/application', media: 'all' %>
  <%= javascript_include_tag 'turbolinks' if features.turbolinks_enabled %>
  <%= javascript_include_tag 'admin/application' %>
  ```

  Then create custom stylesheet asset file (e.g. `admin/application`), import Wallaby's base stylesheet and develop custom stylesheet:

  ```scss
  // app/assets/stylesheets/admin/application.scss
  @import 'wallaby/base';

  // Start customization from here
  header {
    font-size: 14px;
  }
  ```

- To inject more CSS libraries to the `<head>` section, it can be written in anywhere as needed as below:

  ```erb
  <% content_for :custom_stylesheet do %>
    <%= stylesheet_link_tag 'theme/new_year' %>
  <% end %>
  ```

  > NOTE: it is possible to use `custom_stylesheet` to add JS libraries as well.

- LAST RESORT: To extend and override Wallaby CSS, the file `app/assets/stylesheets/wallaby/application.scss` can be created with overridden content. For example:

  ```scss
  // app/assets/stylesheets/wallaby/application.scss
  @import 'wallaby/base';

  // Start customization from here
  header {
    font-size: 14px;
  }
  ```

## Javascript

There are a couple of ways to customize javascript:

- (since 5.2.0) Create `frontend` partial mentioned [above](#partials). For example:

  ```erb
  <%# app/views/admin/application/_frontend.html.erb %>
  <%= stylesheet_link_tag 'admin/application', media: 'all' %>
  <%= javascript_include_tag 'turbolinks' if features.turbolinks_enabled %>
  <%= javascript_include_tag 'admin/application' %>
  ```

  Then create custom javascript asset file (e.g. `admin/application`), import Wallaby's base javascript and develop custom javascript:

  ```javascript
  // app/assets/javascripts/admin/application.js
  //= require wallaby/base

  // Start customization from here
  //= require turbolinks
  alert('Turbolinks is loaded');
  ```

- To inject more JS libraries to the `<head>` section, it can be written in anywhere as needed as below:

  ```erb
  <% content_for :custom_stylesheet do %>
    <%= javascript_include_tag 'angular' %>
  <% end %>
  ```

- LAST RESORT: To extend and override Wallaby javascript, the file `app/assets/javascripts/wallaby/application.js` can be created with overridden content. For example:

  ```javascript
  // app/assets/javascripts/wallaby/application.scss
  //= require wallaby/base

  // Start customization from here
  //= require turbolinks
  alert('Turbolinks is loaded');
  ```
