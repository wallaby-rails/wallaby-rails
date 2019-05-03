module Wallaby
  # Links helper
  module LinksHelper
    # @return [ActionController::Parameters] whitelisted params used by Wallaby
    def index_params(parameters = params)
      permit_list = :filter, :page, :per, :q, :sort
      HashUtils.slice!(parameters, *permit_list)
    end

    # Return link to index page by a given model class
    #
    # If user's not authorized, nil will be returned
    # @param model_class [Class]
    # @param url_params [ActionController::Parameters, Hash]
    # @param html_options [Hash] (@see ActionView::Helpers::UrlHelper#link_to)
    # @return [String, nil] anchor element
    def index_link(model_class, url_params: {}, html_options: {}, &block)
      return if unauthorized? :index, model_class
      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block,
        block: -> { to_model_label model_class }
      )

      path = index_path model_class, url_params: url_params
      link_to path, html_options, &block
    end

    # Return link to create page by a given model class
    #
    # If user's not authorized, nil will be returned
    # @param model_class [Class]
    # @param html_options [Hash] (@see ActionView::Helpers::UrlHelper#link_to)
    # @return [String, nil] anchor element
    def new_link(model_class, html_options: {}, &block)
      return if unauthorized? :new, model_class
      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block,
        class: 'resource__create',
        block: -> { t 'links.new', model: to_model_label(model_class) }
      )

      link_to new_path(model_class), html_options, &block
    end

    # Return link to show page by a given model class
    # If user's not authorized, resource label will be returned
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param options [Hash]
    # @param html_options [Hash] (@see ActionView::Helpers::UrlHelper#link_to)
    # @return [String] anchor element / text
    def show_link(resource, options: {}, html_options: {}, &block)
      # NOTE: to_s is a must
      # if a block is returning integer (e.g. `{ 1 }`)
      # `link_to` will render blank text note inside hyper link
      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block,
        block: -> { decorate(resource).to_label.to_s }
      )

      default = options[:readonly] && block.call || nil
      return default if unauthorized? :show, extract(resource)
      link_to show_path(resource, HashUtils.slice!(options, :is_resource, :url_params)), html_options, &block
    end

    # Return link to edit page by a given model class
    # If user's not authorized, resource label will be returned
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param options [Hash]
    # @param html_options [Hash] (@see ActionView::Helpers::UrlHelper#link_to)
    # @return [String] anchor element / text
    def edit_link(resource, options: {}, html_options: {}, &block)
      default = options[:readonly] && decorate(resource).to_label || nil
      return default if unauthorized? :edit, extract(resource)

      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block,
        class: 'resource__update',
        block: -> { "#{t 'links.edit'} #{decorate(resource).to_label}" }
      )

      link_to edit_path(resource, HashUtils.slice!(options, :is_resource, :url_params)), html_options, &block
    end

    # Return link to delete action by a given model class
    #
    # If user's not authorized, nil will be returned
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param html_options [Hash] (@see ActionView::Helpers::UrlHelper#link_to)
    # @return [String, nil] anchor element
    def delete_link(resource, options: {}, html_options: {}, &block)
      return if unauthorized? :destroy, extract(resource)

      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block,
        class: 'resource__destroy',
        block: -> { t 'links.delete' }
      )

      html_options[:method] ||= :delete
      html_options[:data] ||= {}
      html_options[:data][:confirm] ||= t 'links.confirm.delete'

      link_to show_path(resource, HashUtils.slice!(options, :is_resource, :url_params)), html_options, &block
    end

    # Return link to cancel an action
    # @param html_options [Hash] (@see ActionView::Helpers::UrlHelper#link_to)
    # @return [String] HTML anchor element
    def cancel_link(html_options = {}, &block)
      block ||= -> { t 'links.cancel' }
      link_to 'javascript:history.back()', html_options, &block
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

      url_for url_params.to_h.reverse_merge(
        resources: to_resources_name(model_class),
        action: :index
      )
    end

    # Url for new resource form page
    # @param model_class [Class]
    # @return [String]
    def new_path(model_class, url_params: {})
      url_for url_params.to_h.reverse_merge(
        resources: to_resources_name(model_class),
        action: :new
      )
    end

    # Url for show page of given resource
    # @param resource [Object]
    # @param is_resource [Boolean]
    # @return [String]
    def show_path(resource, is_resource: false, url_params: {})
      decorated = decorate resource
      return unless is_resource || decorated.primary_key_value

      url_for(
        url_params.to_h.reverse_merge(
          resources: decorated.resources_name,
          action: :show,
          id: decorated.primary_key_value
        ).delete_if { |_, v| v.blank? }
      )
    end

    # Url for edit form page of given resource
    # @param resource [Object]
    # @param is_resource [Boolean]
    # @return [String]
    def edit_path(resource, is_resource: false, url_params: {})
      decorated = decorate resource

      return unless is_resource || decorated.primary_key_value

      url_for(
        url_params.to_h.reverse_merge(
          resources: decorated.resources_name,
          action: :edit,
          id: decorated.primary_key_value
        ).delete_if { |_, v| v.blank? }
      )
    end
  end
end
