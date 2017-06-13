module Wallaby
  # Links helper
  module LinksHelper
    def index_params
      params.permit(:q, :page, :per, :sort)
    end

    def index_path(model_class = nil, extra_params = nil)
      model_class ||= current_model_class
      extra_params ||= {}
      wallaby_engine.resources_path \
        to_resources_name(model_class), extra_params.to_h
    end

    def new_path(model_class = nil)
      model_class ||= current_model_class
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

    def index_link(model_class = nil, html_options = {}, &block)
      model_class ||= current_model_class
      return if cannot? :index, model_class
      block ||= -> { to_model_label model_class }
      path = index_path model_class, html_options.delete(:extra_params)
      link_to path, html_options, &block
    end

    def new_link(model_class = nil, html_options = {}, &block)
      model_class ||= current_model_class
      return if cannot? :new, model_class

      block ||= -> { "#{ct 'link.new'} #{to_model_label model_class}" }
      html_options[:class] = 'text-success' unless html_options.key? :class

      prepend_if(html_options) \
        + link_to(new_path(model_class), html_options, &block)
    end

    def show_link(resource, html_options = {}, &block)
      return if cannot? :show, extract(resource)

      # NOTE: to_s is a must
      # if a block is returning integer (e.g. `{ 1 }`)
      # `link_to` will render blank text note inside hyper link
      block ||= -> { decorate(resource).to_label.to_s }

      link_to show_path(resource), html_options, &block
    end

    def edit_link(resource, html_options = {}, &block)
      return if cannot? :edit, extract(resource)

      block ||= -> { "#{ct 'link.edit'} #{decorate(resource).to_label}" }
      html_options[:class] = 'text-warning' unless html_options.key? :class

      link_to edit_path(resource), html_options, &block
    end

    def delete_link(resource, html_options = {}, &block)
      return if cannot? :destroy, extract(resource)

      block ||= -> { ct 'link.delete' }
      html_options[:class] = 'text-danger' unless html_options.key? :class
      html_options[:method] ||= :delete
      html_options[:data] ||= {}
      html_options[:data][:confirm] ||= ct('link.confirm.delete')

      link_to show_path(resource), html_options, &block
    end

    def cancel_link(html_options = {}, &block)
      block ||= -> { ct 'link.cancel' }
      link_to :back, html_options, &block
    end

    def prepend_if(html_options = {})
      prepend = html_options.delete :prepend
      prepend.present? ? "#{prepend} " : EMPTY_STRING
    end
  end
end
