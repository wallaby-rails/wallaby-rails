## Frontend

### Partials

Wallaby take full advantages of [Template Inheritance](http://guides.rubyonrails.org/layouts_and_rendering.html#template-inheritance), please have a read before continue reading.

If you have base class `Admin::ApplicationController` whose `controller_path` is `admin/application`, then elements on the page can be customized in the following ways:

- To customize page title, `app/views/#{controller_path}/_title.html.erb` needs to be created.
- To customize logo, `app/views/#{controller_path}/_logo.html.erb` needs to be created.
- To customize header, `app/views/#{controller_path}/_header.html.erb` needs to be created.
- To customize footer, `app/views/#{controller_path}/_footer.html.erb` needs to be created.
- To modify links for logged-in user, `app/views/#{controller_path}/_user_menu.html.erb` needs to be created.
- To modify links/items for the top navigation bar, `app/views/#{controller_path}/_navs.html.erb` needs to be created.
- To modify links/items for the dropdown button on index page, `app/views/#{controller_path}/_index_actions.html.erb` needs to be created.
- To modify show/edit/delete links on index page, `app/views/#{controller_path}/_resource_actions.html.erb` needs to be created.
- To modify show/edit/delete links for show/new/create page, `app/views/#{controller_path}/_resource_navs.html.erb` needs to be created.

> `#{controller_path}` should be replaced with the base class's `controller_path`, which is `admin/application` in this case.

Otherwise, it is possible to replace the wallaby origin files:

- To customize page title, [`app/views/wallaby/resources/_title.html.erb`](../app/views/wallaby/resources/_title.html.erb) needs to be replaced.
- To customize logo, [`app/views/wallaby/resources/_logo.html.erb`](../app/views/wallaby/resources/_logo.html.erb) needs to be replaced.
- To customize header, [`app/views/wallaby/resources/_header.html.erb`](../app/views/wallaby/resources/_header.html.erb) needs to be replaced.
- To customize footer, [`app/views/wallaby/resources/_footer.html.erb`](../app/views/wallaby/resources/_footer.html.erb) needs to be replaced.
- To modify links for logged-in user, [`app/views/wallaby/resources/_user_menu.html.erb`](../app/views/wallaby/resources/_user_menu.html.erb) needs to be replaced.
- To modify links/items for the top navigation bar, [`app/views/wallaby/resources/_navs.html.erb`](../app/views/wallaby/resources/_navs.html.erb) needs to be replaced.
- To modify links/items for the dropdown button on index page, [`app/views/wallaby/resources/_index_actions.html.erb`](../app/views/wallaby/resources/_index_actions.html.erb) needs to be replaced.
- To modify show/edit/delete links on index page, [`app/views/wallaby/resources/_resource_actions.html.erb`](../app/views/wallaby/resources/_resource_actions.html.erb) needs to be replaced.
- To modify show/edit/delete links for show/new/create page, [`app/views/wallaby/resources/_resource_navs.html.erb`](../app/views/wallaby/resources/_resource_navs.html.erb) needs to be replaced.

### CSS Styling

To extend and override Wallaby CSS, the file `app/assets/stylesheets/wallaby/application.scss` is required to be replaced with:

```scss
// NOTE: need to keep this line
@import 'wallaby/base';

// NOTE: override the CSS after the above line, for example
header {
  font-size: 14px;
}
```

If you want to add some CSS libraries, it can be written as below in order to place it to the `head` section of html:

```erb
<% content_for :custom_stylesheet do %>
  <%= stylesheet_link_tag 'theme/new_year' %>
<% end %>
```

> HINT: it is possible to use `custom_stylesheet` to add JS libraries into `head` section.

### Javascripts

Similar, to extend Wallaby JS, this file `app/assets/javascripts/wallaby/application.js` is required to be replaced with:

```javascript
// NOTE: need to keep this line
//= require wallaby/base

// NOTE: add more js lib or code after the above line, for example
//= require turbolinks
alert('Turbolinks is loaded');
```

If you want to add some one-time JS code that shouldn't go into the above global JS file, it can be written in order to place it to the bottom of html:

```erb
<% content_for :custom_javascript do
  javascript_tag do %>
  alert('I am from some.html.erb');
<% end
end %>
```
