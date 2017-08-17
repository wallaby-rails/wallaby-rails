module Wallaby
  # Links helper
  module LinksHelper
    def index_params
      params.permit(:q, :page, :per, :sort, :filter)
    end

    def index_link(model_class, url_params: {}, html_options: {}, &block)
      return if cannot? :index, model_class
      block ||= -> { to_model_label model_class }
      path = index_path model_class: model_class, url_params: url_params
      link_to path, html_options, &block
    end

    def new_link(model_class, options: {}, html_options: {}, &block)
      return if cannot? :new, model_class
      block ||= -> { ct 'links.new', model: to_model_label(model_class) }
      html_options[:class] = 'resource__create' unless html_options.key? :class

      prepend = options[:prepend] || EMPTY_STRING
      prepend.html_safe + link_to(new_path(model_class), html_options, &block)
    end

    def show_link(resource, html_options: {}, &block)
      return if cannot? :show, extract(resource)

      # NOTE: to_s is a must
      # if a block is returning integer (e.g. `{ 1 }`)
      # `link_to` will render blank text note inside hyper link
      block ||= -> { decorate(resource).to_label.to_s }
      link_to show_path(resource), html_options, &block
    end

    def edit_link(resource, html_options: {}, &block)
      return if cannot? :edit, extract(resource)

      block ||= -> { "#{ct 'links.edit'} #{decorate(resource).to_label}" }
      html_options[:class] = 'resource__update' unless html_options.key? :class

      link_to edit_path(resource), html_options, &block
    end

    def delete_link(resource, html_options: {}, &block)
      return if cannot? :destroy, extract(resource)

      block ||= -> { ct 'links.delete' }
      html_options[:class] = 'resource__destroy' unless html_options.key? :class
      html_options[:method] ||= :delete
      html_options[:data] ||= {}
      html_options[:data][:confirm] ||= ct('links.confirm.delete')

      link_to show_path(resource), html_options, &block
    end

    def cancel_link(html_options = {}, &block)
      block ||= -> { ct 'links.cancel' }
      link_to :back, html_options, &block
    end

    def index_path(model_class: current_model_class, url_params: {})
      wallaby_engine.resources_path \
        to_resources_name(model_class), url_params.to_h
    end

    def new_path(model_class = current_model_class)
      wallaby_engine.new_resource_path to_resources_name(model_class)
    end

    def show_path(resource)
      decorated = decorate resource
      wallaby_engine.resource_path \
        decorated.resources_name, decorated.primary_key_value
    end

    def edit_path(resource)
      decorated = decorate resource
      wallaby_engine.edit_resource_path \
        decorated.resources_name, decorated.primary_key_value
    end
  end
end
