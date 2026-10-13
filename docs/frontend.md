# Frontend

Learn more about the customization for frontend:

- [Partials](#partials) - customizing the components on the page, e.g. title, logo, header.

  - [frontend](#frontend) - customizing CSS and JS libraries in `<head>` tag.
  - [title](#title) - customizing page title.
  - [header](#header) - customizing header section.
  - [footer](#footer) - customizing footer section.
  - [logo](#logo) - customizing logo.
  - [user_menu](#user_menu) - customizing links for logged-in user.
  - [navs](#navs) - customizing links/items for top navigation bar.
  - [index_actions](#index_actions) - customizing links/items for dropdown button next to search form, it's only used by `index` page.
  - [resource_actions](#resource_actions) - customizing action links for a resource row in data table, it's only used by `index` page.
  - [resource_navs](#resource_navs) - customizing action links for resource navigation under the resource's title, it's used by `show`/`new`/`create`/`edit`/`update` page.

- [Stylesheet](#stylesheet) - extending and customizing the look and feel by CSS stylesheet.
- [Javascript](#Javascript) - extending and customizing user interaction by JS.

> NOTE: If a third party theme is used, its frontend implementation might be different from Wallaby, please check out its document to find out how to do customization for its frontend.

# Partials

Same as [Type Partial](view.md#type-partial), Wallaby utilizes and extends [Template Inheritance](https://guides.rubyonrails.org/layouts_and_rendering.html#template-inheritance) to look for partial in controller and action inheritance chain.

For example, given that Wallaby is mounted under path `/admin` (see how Wallaby is mounted in [route](route.md)), to customize `title` for model `Product`, it goes:

- if the partial is only needed for model `Product` when no controller is created for `Product`, then it can be created as:

  ```
  app/views/admin/products/_title.html.erb
  ```

- if the partial is only needed for the controller created for `Product`, then it can be created as:

  ```ruby
  # app/controllers/backend/goods_controller.rb
  class Backend::GoodsController < Admin::ApplicationsController
    self.model_class = Product
  end
  ```

  ```
  app/views/backend/goods/_title.html.erb
  ```

- if the partial is only needed for the controller created for `Product` and action `index`, then it can be created as:

  ```
  app/views/backend/goods/index/_title.html.erb
  ```

- if the partial is supposed to be shared among the app with base controller (e.g. `Admin::ApplicationController`), then it can be created as:

  ```
  app/views/admin/application/_title.html.erb
  ```

> See [Wallaby lookup order](view.md#partial-lookup-order) for more details.

## frontend

Following example will create partial at admin application controller level under `admin/application` controller path.

> See [Partials](#partials) and [Wallaby lookup order](view.md#partial-lookup-order) for where the partial should be created.

To customize CSS and JS libraries in the HTML `<head>` section, it goes:

```erb
<%# app/views/admin/application/_frontend.html.erb %>
<%= stylesheet_link_tag 'admin/application', media: 'all' %>
<%= javascript_include_tag 'admin/application' %>
```

## title

Following example will create partial at admin application controller level under `admin/application` controller path.

> See [Partials](#partials) and [Wallaby lookup order](view.md#partial-lookup-order) for where the partial should be created.

To customize page title, it goes:

```erb
<%# app/views/admin/application/_title.html.erb %>
Page Title
```

## header

Following example will create partial at admin application controller level under `admin/application` controller path.

> See [Partials](#partials) and [Wallaby lookup order](view.md#partial-lookup-order) for where the partial should be created.

To customize `<header>` section, it goes:

```erb
<%# app/views/admin/application/_header.html.erb %>
<%= render 'logo' %>
<%= render 'navs' %>
<%= render 'user_menu' %>
```

> NOTE: origin header section includes `logo`, `navs` and `user_menu` partials.

## footer

Following example will create partial at admin application controller level under `admin/application` controller path.

> See [Partials](#partials) and [Wallaby lookup order](view.md#partial-lookup-order) for where the partial should be created.

To customize `<footer>` section, it goes:

```erb
<%# app/views/admin/application/_footer.html.erb %>
<footer>© 2018 Company</footer>
```

## logo

Following example will create partial at admin application controller level under `admin/application` controller path.

> See [Partials](#partials) and [Wallaby lookup order](view.md#partial-lookup-order) for where the partial should be created.

To customize logo/slogan, it goes:

```erb
<%# app/views/admin/application/_logo.html.erb %>
<a class="navbar-brand" href="<%= current_engine.root_path %>">Slogan</a>
```

## user_menu

Following example will create partial at admin application controller level under `admin/application` controller path.

> See [Partials](#partials) and [Wallaby lookup order](view.md#partial-lookup-order) for where the partial should be created.

To customize popup menu when clicking at user icon, it goes:

```erb
<%# app/views/admin/application/_user_menu.html.erb %>
<ul class="dropdown-menu">
  <% if logout_path.present? %>
    <li><%= link_to 'Sign out', logout_path, method: logout_method %></li>
  <% end %>
</ul>
```

## navs

Following example will create partial at admin application controller level under `admin/application` controller path.

> See [Partials](#partials) and [Wallaby lookup order](view.md#partial-lookup-order) for where the partial should be created.

To customize popup menu when clicking at user icon, it goes:

```erb
<%# app/views/admin/application/_navs.html.erb %>
<ul class="nav navbar-nav">
  <li class="dropdown">
    <a id="model_tree" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" class="dropdown-toggle">
      Data <span class="caret"></span>
    </a>
    <%= model_tree model_classes, 'model_tree' %>
  </li>
</ul>
```

## index_actions

Following example will create partial at admin application controller level under `admin/application` controller path.

> See [Partials](#partials) and [Wallaby lookup order](view.md#partial-lookup-order) for where the partial should be created.

To customize links/items for dropdown button next to search form, it goes:

```erb
<%# app/views/admin/application/_index_actions.html.erb %>
<ul aria-labelledby="actions_list">
  <li><%= export_link current_model_class %></li>
</ul>
```

> NOTE: it's used by index page only.

## resource_actions

Following example will create partial at admin application controller level under `admin/application` controller path.

> See [Partials](#partials) and [Wallaby lookup order](view.md#partial-lookup-order) for where the partial should be created.

To customize action links for a resource row in data table, it goes:

```erb
<%# app/views/admin/application/_resource_actions.html.erb %>
<%= show_link(decorated) {} %>
<%= edit_link(decorated) {} %>
<%= delete_link(decorated) {} %>
```

> NOTE: it's used by index page only.

## resource_navs

Following example will create partial at admin application controller level under `admin/application` controller path.

> See [Partials](#partials) and [Wallaby lookup order](view.md#partial-lookup-order) for where the partial should be created.

To customize action links for resource navigation, it goes:

```erb
<%# app/views/admin/application/_resource_navs.html.erb %>
<nav>
  <ul>
    <%# list %>
    <li role="presentation">
      <%= index_link(current_model_class, html_options: { class: 'resources__index' }) {} %>
    </li>
  </ul>
</nav>
```

> NOTE: it's used by `show`/`new`/`create`/`edit`/`update` page.

# Stylesheet

There are a couple of ways to customize stylesheet:

- To extend and override Wallaby CSS, the file `app/assets/stylesheets/wallaby/application.scss` can be created with overridden content. For example:

  ```scss
  // app/assets/stylesheets/wallaby/application.scss
  @import 'wallaby/base';

  // Start customization from here
  header {
    font-size: 14px;
  }
  ```

- To inject more CSS libraries to the `<head>` section, it can be written in anywhere in the template/partials as needed as below:

  ```erb
  <% content_for :custom_stylesheet do %>
    <%= stylesheet_link_tag 'theme/new_year' %>
  <% end %>
  ```

  > NOTE: it is possible to use `custom_stylesheet` to add JS libraries as well.

# Javascript

There are a couple of ways to customize javascript:

- To extend and override Wallaby javascript, the file `app/assets/javascripts/wallaby/application.js` can be created with overridden content. For example:

  ```javascript
  // app/assets/javascripts/wallaby/application.js
  //= require wallaby/base

  // Start customization from here
  alert('All is good');
  ```

- To inject more JS libraries to the `<head>` section, it can be written in anywhere in the template/partials as needed as below:

  ```erb
  <% content_for :custom_stylesheet do %>
    <%= javascript_include_tag 'angular' %>
  <% end %>
  ```

- To inject more JS libraries to the bottom of `<body>` section, it can be written in anywhere in the template/partials as needed as below:

  ```erb
  <% content_for :custom_javascript do %>
    <%= javascript_tag "alert('All is good')" %>
  <% end %>
  ```

## CodeMirror

The `json` / `jsonb` / `hstore` / `xml` / `markdown` form fields are rendered
with a CodeMirror 6 editor through the `window.WallabyCodeMirror` global. The
default editor configuration is exposed as `window.WallabyCodeMirror.config`
and can be customised from your own Javascript (which must run before the
editors are created, i.e. at page load):

```javascript
// e.g. app/assets/javascripts/admin/wallaby_custom.js, included from your
// custom `_frontend` partial after the Wallaby bundle
(function (CodeMirror) {
  var config = CodeMirror.config;

  // apply an extension to every editor, e.g. wrap long lines
  config.base.push(CodeMirror.EditorView.lineWrapping);

  // apply an extension to a specific data-mode, e.g. a light theme for markdown
  config.extensions.markdown = [
    CodeMirror.EditorView.theme({ '&': { backgroundColor: '#f6f6f6' } })
  ];

  // register or replace the language for a data-mode
  config.languages.yaml = function () {
    return CodeMirror.StreamLanguage.define(/* your legacy mode parser */);
  };
})(window.WallabyCodeMirror);
```

`config.base` is a list of extensions applied to every editor (starts with
`basicSetup`), `config.extensions` is a map of `data-mode` to extra
extensions, and `config.languages` is a map of `data-mode` to language
factories (or ready `LanguageSupport`s, e.g. from `StreamLanguage.define`).

Build custom extensions with the re-exported primitives on
`window.WallabyCodeMirror` (`EditorView`, `EditorState`, `basicSetup`,
`StreamLanguage`, `javascript`, `markdown`, `xml`, `ruby`) so they share the
bundle's single CodeMirror 6 instance — mixing in a separately installed copy
of `@codemirror/*` can cause duplicated-instance errors.

Per-field options can also be passed through
`WallabyCodeMirror.fromTextArea(element, { mode, extensions })` when a form
partial is overridden.

# Turbolinks

Wallaby detects Turbolinks automatically if the `turbolinks` gem is present in the host app's `Gemfile` — no configuration is required. To disable it, either remove the `turbolinks` gem from the `Gemfile`, or override the `frontend` partial to take the Turbolinks javascript tags out.
