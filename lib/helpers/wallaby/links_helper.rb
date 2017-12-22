module Wallaby
  # Links helper
  module LinksHelper
    # Permit the params used by Wallaby
    def index_params
      params.permit(:q, :page, :per, :sort, :filter)
    end

    # Return link to index page by a given model class
    # If user's not authorized, nil will be returned
    # @param model_class [Class] model class
    # @param url_params [ActionController::Parameters, Hash]
    # @param html_options [Hash] (see ActionView::Helpers::UrlHelper#link_to)
    # @return [String, nil] anchor element
    def index_link(model_class, url_params: {}, html_options: {}, &block)
      return if cannot? :index, model_class
      block ||= -> { to_model_label model_class }
      path = index_path model_class, url_params: url_params
      link_to path, html_options, &block
    end

    # Return link to create page by a given model class
    # If user's not authorized, nil will be returned
    # @param model_class [Class] model class
    # @param options [Hash]
    # @param html_options [Hash] (see ActionView::Helpers::UrlHelper#link_to)
    # @return [String, nil] anchor element
    def new_link(model_class, html_options: {}, &block)
      return if cannot? :new, model_class
      block ||= -> { t 'links.new', model: to_model_label(model_class) }
      html_options[:class] = 'resource__create' unless html_options.key? :class

      link_to new_path(model_class), html_options, &block
    end

    # Return link to show page by a given model class
    # If user's not authorized, resource label will be returned
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param options [Hash]
    # @param html_options [Hash] (see ActionView::Helpers::UrlHelper#link_to)
    # @return [String] anchor element / text
    def show_link(resource, options: {}, html_options: {}, &block)
      # NOTE: to_s is a must
      # if a block is returning integer (e.g. `{ 1 }`)
      # `link_to` will render blank text note inside hyper link
      block ||= -> { decorate(resource).to_label.to_s }

      default = options[:readonly] && block.call || nil
      return default if cannot? :show, extract(resource)
      link_to show_path(resource), html_options, &block
    end

    # Return link to edit page by a given model class
    # If user's not authorized, resource label will be returned
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param options [Hash]
    # @param html_options [Hash] (see ActionView::Helpers::UrlHelper#link_to)
    # @return [String] anchor element / text
    def edit_link(resource, options: {}, html_options: {}, &block)
      block ||= -> { "#{t 'links.edit'} #{decorate(resource).to_label}" }
      default = options[:readonly] && decorate(resource).to_label || nil
      return default if cannot? :edit, extract(resource)

      html_options[:class] ||= 'resource__update'

      link_to edit_path(resource), html_options, &block
    end

    # Return link to delete action by a given model class
    # If user's not authorized, nil will be returned
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param options [Hash]
    # @param html_options [Hash] (see ActionView::Helpers::UrlHelper#link_to)
    # @return [String, nil] anchor element
    def delete_link(resource, html_options: {}, &block)
      return if cannot? :destroy, extract(resource)

      block ||= -> { t 'links.delete' }
      html_options[:class] ||= 'resource__destroy'
      html_options[:method] ||= :delete
      html_options[:data] ||= {}
      html_options[:data][:confirm] ||= t 'links.confirm.delete'

      link_to show_path(resource), html_options, &block
    end

    # Return link to cancel an action
    # @param html_options [Hash] (see ActionView::Helpers::UrlHelper#link_to)
    # @return [String] HTML anchor element
    def cancel_link(html_options = {}, &block)
      block ||= -> { t 'links.cancel' }
      link_to :back, html_options, &block
    end

    # Url for index page
    # @param model_class [Class]
    # @param url_params [ActionController::Parameters, Hash]
    # @return [String]
    def index_path(model_class, url_params: {})
      if url_params.is_a?(::ActionController::Parameters) \
        && !url_params.permitted?
        url_params = {}
      end
      wallaby_engine.resources_path \
        to_resources_name(model_class), url_params.to_h
    end

    # Url for new resource form page
    # @param model_class [Class]
    # @return [String]
    def new_path(model_class)
      wallaby_engine.new_resource_path to_resources_name(model_class)
    end

    # Url for show page of given resource
    # @param resource [Object]
    # @return [String]
    def show_path(resource)
      decorated = decorate resource
      return unless decorated.primary_key_value
      wallaby_engine.resource_path \
        decorated.resources_name, decorated.primary_key_value
    end

    # Url for edit form page of given resource
    # @param resource [Object]
    # @return [String]
    def edit_path(resource)
      decorated = decorate resource
      return unless decorated.primary_key_value
      wallaby_engine.edit_resource_path \
        decorated.resources_name, decorated.primary_key_value
    end
  end
end
