module Wallaby::LinksHelper
  def index_path(model_class = nil)
    model_class ||= current_model_class
    wallaby_engine.resources_path to_resources_name model_class
  end

  def new_path(model_class = nil)
    model_class ||= current_model_class
    wallaby_engine.new_resource_path to_resources_name model_class
  end

  def show_path(resource)
    decorated = decorate resource
    wallaby_engine.resource_path decorated.resources_name, decorated.primary_key_value
  end

  def edit_path(resource)
    decorated = decorate resource
    wallaby_engine.edit_resource_path decorated.resources_name, decorated.primary_key_value
  end

  def index_link(model_class = nil, html_options = {}, &block)
    model_class ||= current_model_class
    block ||= -> { to_model_label model_class }

    link_to index_path(model_class), html_options, &block
  end

  def new_link(model_class = nil, html_options = {}, &block)
    block ||= -> { ct 'link.new', model: to_model_label(model_class) }
    html_options[:class] = 'text-success' unless html_options.has_key? :class

    link_to new_path(model_class), html_options, &block
  end

  def show_link(resource, html_options = {}, &block)
    # NOTE: to_s is a must
    # if a block is returning integer (e.g. `{ 1 }`)
    # `link_to` will render blank text note inside hyper link
    block ||= -> { decorate(resource).to_label.to_s }

    link_to show_path(resource), html_options, &block
  end

  def edit_link(resource, html_options = {}, &block)
    link_to edit_path(resource), html_options, &block
  end

  def delete_link(resource, html_options = {}, &block)
    html_options[:method] ||= :delete
    html_options[:data]   ||= {}
    html_options[:data][:confirm] ||= ct('link.confirm.delete')

    link_to show_path(resource), html_options, &block
  end

  def cancel_link(html_options = {})
    label = html_options.delete(:label) || ct('link.cancel')
    link_to label, :back, html_options
  end
end
