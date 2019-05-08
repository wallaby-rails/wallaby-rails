module Wallaby
  # Links helper
  module LinksHelper
    # @return [ActionController::Parameters] whitelisted params used by Wallaby
    def index_params(parameters = params)
      permit_list = :filter, :page, :per, :q, :sort
      HashUtils.slice!(parameters, *permit_list)
    end

    # Return link to index page for a given model class
    # @param model_class [Class]
    # @param path [String, nil]
    # @param url_params [ActionController::Parameters, Hash]
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String] anchor link to index page for a given model class
    # @return [nil] if user's not authorized
    def index_link(model_class, path: nil, url_params: {}, html_options: {}, &block)
      return if unauthorized? :index, model_class
      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block,
        block: -> { to_model_label model_class }
      )

      path ||= index_path model_class, url_params: url_params
      link_to path, html_options, &block
    end

    # Return link to create page for a given model class
    # @param model_class [Class]
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String, nil] anchor element
    # @return [nil] if user's not authorized
    def new_link(model_class, html_options: {}, &block)
      return if unauthorized? :new, model_class
      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block,
        class: 'resource__create',
        block: -> { t 'links.new', model: to_model_label(model_class) }
      )

      link_to new_path(model_class), html_options, &block
    end

    # Return link to show page for a given model class.
    #
    # If user's not authorized, default resource label will be returned.
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param options [Hash]
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
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

    # Return link to edit page for a given model class.
    #
    # If user's not authorized, resource label will be returned
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param options [Hash]
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String] anchor element / text
    # @return [nil] if user's not authorized
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

    # Return link to delete action for a given model class.
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String, nil] anchor element
    # @return [nil] if user's not authorized
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

    # Return link to cancel action
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String] anchor link of cancel action
    def cancel_link(html_options: {}, &block)
      block ||= -> { t 'links.cancel' }
      link_to 'javascript:history.back()', html_options, &block
    end

    # @param model_class [Class]
    # @param url_params [Hash]
    # @return [String] index page path
    def index_path(model_class, url_params: {})
      hash = { resources: to_resources_name(model_class), action: :index }.merge url_params.to_h
      current_engine.try(:resources_path, hash) || url_for(hash)
    end

    # @param model_class [Class]
    # @param url_params [Hash]
    # @return [String] new page path
    def new_path(model_class, url_params: {})
      hash = { resources: to_resources_name(model_class), action: :new }.merge url_params.to_h
      current_engine.try(:new_resource_path, hash) || url_for(hash)
    end

    # @param resource [Object]
    # @param is_resource [Boolean]
    # @param url_params [Hash]
    # @return [String] show page path
    def show_path(resource, is_resource: false, url_params: {})
      decorated = decorate resource
      return unless is_resource || decorated.primary_key_value

      hash = HashUtils.presence(
        { resources: decorated.resources_name, action: :show, id: decorated.primary_key_value }.merge(url_params.to_h)
      )

      current_engine.try(:resource_path, hash) || url_for(hash)
    end

    # @param resource [Object]
    # @param is_resource [Boolean]
    # @param url_params [Hash]
    # @return [String] edit page path
    def edit_path(resource, is_resource: false, url_params: {})
      decorated = decorate resource
      return unless is_resource || decorated.primary_key_value

      hash = HashUtils.presence(
        { resources: decorated.resources_name, action: :edit, id: decorated.primary_key_value }.merge(url_params.to_h)
      )

      current_engine.try(:edit_resource_path, hash) || url_for(hash)
    end
  end
end
