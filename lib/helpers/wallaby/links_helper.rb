module Wallaby
  # Links helper
  module LinksHelper
    # Return link to index page for a given model class
    # @param model_class [Class]
    # @param options [Hash]
    # @option options [String] :url url/path for the link
    # @param url_params [ActionController::Parameters, Hash]
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String] anchor link to index page for a given model class
    # @return [nil] if user's not authorized
    def index_link(model_class, options: {}, url_params: {}, html_options: {}, &block)
      return if unauthorized? :index, model_class
      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block,
        block: -> { to_model_label model_class }
      )

      url_params = request.query_parameters.merge(url_params) if url_params.delete(:with_query)
      url = options[:url] || index_path(model_class, url_params: url_params)
      link_to url, html_options, &block
    end

    # Return link to create page for a given model class
    # @param model_class [Class]
    # @param options [Hash]
    # @option options [String] :url url/path for the link
    # @param url_params [ActionController::Parameters, Hash]
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String, nil] anchor element
    # @return [nil] if user's not authorized
    def new_link(model_class, options: {}, url_params: {}, html_options: {}, &block)
      return if unauthorized? :new, model_class
      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block,
        class: 'resource__create',
        block: -> { t 'links.new', model: to_model_label(model_class) }
      )

      url = options[:url] || new_path(model_class, url_params: url_params)
      link_to url, html_options, &block
    end

    # Return link to show page for a given model class.
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param options [Hash]
    # @option options [String] :url url/path for the link
    # @option options [Boolean] :readonly readonly and therefore output the label
    # @option options [Boolean] :is_resource to tell {#show_path} if it is a resource
    # @param url_params [ActionController::Parameters, Hash]
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String] anchor element / text
    # @return [nil] if user's not authorized
    def show_link(resource, options: {}, url_params: {}, html_options: {}, &block)
      # NOTE: to_s is a must
      # if a block is returning integer (e.g. `{ 1 }`)
      # `link_to` will render blank text note inside hyper link
      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block,
        block: -> { decorate(resource).to_label.to_s }
      )

      default = options[:readonly] && block.call || nil
      return default if unauthorized? :show, extract(resource)

      url = options[:url] || show_path(resource, is_resource: options[:is_resource], url_params: url_params)
      link_to url, html_options, &block
    end

    # Return link to edit page for a given model class.
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param options [Hash]
    # @option options [String] :url url/path for the link
    # @option options [Boolean] :readonly readonly and therefore output the label
    # @option options [Boolean] :is_resource to tell {#edit_path} if it is a resource
    # @param url_params [ActionController::Parameters, Hash]
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String] anchor element / text
    # @return [nil] if user's not authorized
    def edit_link(resource, options: {}, url_params: {}, html_options: {}, &block)
      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block,
        class: 'resource__update',
        block: -> { "#{t 'links.edit'} #{decorate(resource).to_label}" }
      )

      default = options[:readonly] && block.call || nil
      return default if unauthorized? :edit, extract(resource)

      url = options[:url] || edit_path(resource, is_resource: options[:is_resource], url_params: url_params)
      link_to url, html_options, &block
    end

    # Return link to delete action for a given model class.
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param options [Hash]
    # @option options [String] :url url/path for the link
    # @option options [Boolean] :is_resource to tell {#edit_path} if it is a resource
    # @param url_params [ActionController::Parameters, Hash]
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String, nil] anchor element
    # @return [nil] if user's not authorized
    def delete_link(resource, options: {}, url_params: {}, html_options: {}, &block)
      return if unauthorized? :destroy, extract(resource)

      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block, class: 'resource__destroy', block: -> { t 'links.delete' }
      )

      html_options[:method] ||= :delete
      (html_options[:data] ||= {})[:confirm] ||= t 'links.confirm.delete'

      url = options[:url] || show_path(resource, is_resource: options[:is_resource], url_params: url_params)
      link_to url, html_options, &block
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
      hash = ParamsUtils.presence(
        { action: :index },
        default_path_params(resources: to_resources_name(model_class)),
        url_params.to_h
      )
      current_engine.try(:resources_path, hash) || url_for(hash)
    end

    # @param model_class [Class]
    # @param url_params [Hash]
    # @return [String] new page path
    def new_path(model_class, url_params: {})
      hash = ParamsUtils.presence(
        { action: :new },
        default_path_params(resources: to_resources_name(model_class)),
        url_params.to_h
      )
      current_engine.try(:new_resource_path, hash) || url_for(hash)
    end

    # @param resource [Object]
    # @param is_resource [Boolean]
    # @param url_params [Hash]
    # @return [String] show page path
    def show_path(resource, is_resource: false, url_params: {})
      decorated = decorate resource
      return unless is_resource || decorated.primary_key_value

      hash = ParamsUtils.presence(
        { action: :show, id: decorated.primary_key_value },
        default_path_params(resources: decorated.resources_name),
        url_params.to_h
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

      hash = ParamsUtils.presence(
        { action: :edit, id: decorated.primary_key_value },
        default_path_params(resources: decorated.resources_name),
        url_params.to_h
      )

      current_engine.try(:edit_resource_path, hash) || url_for(hash)
    end

    # @return [Hash] default path params
    def default_path_params(resources: nil)
      { script_name: request.env[SCRIPT_NAME] }.tap do |default|
        default[:resources] = resources if current_engine || resources
        default[:only_path] = true unless default.key?(:only_path)
      end
    end
  end
end
