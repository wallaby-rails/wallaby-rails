module Wallaby::LinksHelper
  def index_link(options = {}, title = nil, resources = nil)
    resources ||= resources_name
    title     ||= ct(resources)
    link_to title, wallaby_engine.resources_path, options
  end

  def new_link(options = {}, title = nil, resources = nil)
    resources ||= resources_name
    title     ||= ct('link.new')
    link_to title, wallaby_engine.new_resource_path, options
  end

  def show_link(resource, options = {}, title = nil, resources = nil)
    resources ||= resources_name
    title     ||= ct('link.show')
    is_button = options.delete(:button)
    options[:title] = title and title = '' if is_button
    link_to title, wallaby_engine.resource_path(resources, resource), options
  end

  def edit_link(resource, options = {}, title = nil, resources = nil)
    resources ||= resources_name
    title     ||= ct('link.edit')
    is_button = options.delete(:button)
    options[:title] = title and title = '' if is_button
    link_to title, wallaby_engine.edit_resource_path(resources, resource), options
  end

  def delete_link(resource, html_options = {}, title = nil, confirm = nil, resources = nil)
    resources ||= resources_name
    title     ||= ct('link.delete')
    confirm   ||= ct('link.confirm.delete')
    is_button = html_options.delete(:button)
    html_options[:title] = title and title = '' if is_button
    options = {
      url: wallaby_engine.resource_path(resources, resource),
      method: :delete,
      confirm: confirm
    }
    link_to title, wallaby_engine.resource_path(resources, resource), html_options.merge(options)
  end

  def cancel_link(title = nil, options = {})
    title ||= ct('cancel')
    is_button = options.delete(:button)
    options[:title] = title and title = '' if is_button
    link_to title, :back, options
  end

  def link_to_resource(resource = nil, klass = nil)
    if resource
      decorated = decorate resource
      link_to decorated.to_label, wallaby_engine.resource_path(decorated.resources_name, decorated)
    else
      this_model_decorator = model_decorator(klass)
      link_to wallaby_engine.new_resource_path(this_model_decorator.resources_name), class: 'text-success' do
        "Create #{ this_model_decorator.model_label }"
      end
    end
  end

  def resource_links
    decorated = decorate resource
    links = [ index_link({}, 'List') ]
    if decorated.send decorated.primary_key
      links << show_link(decorated) if params[:action] == 'edit'
      links << edit_link(decorated, class: 'text-success') if params[:action] == 'show'
      links << delete_link(decorated, class: 'text-danger')
    end
    links
  end

  def link_to_model(model)
    decorator = model_decorator model
    name      = Wallaby::Utils.to_resources_name model
    link_to decorator.model_label, wallaby_engine.resources_path(name)
  end
end
