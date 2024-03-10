# frozen_string_literal: true

module Wallaby
  # Links helper
  module LinksHelper
    # Return link to index page for a given model class
    # @param model_class [Class]
    # @param options [Hash]
    # @option options [String] :url url/path for the link
    # @param url_params [Hash, ActionController::Parameters]
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String] anchor link to index page for a given model class
    # @return [nil] if user's not authorized
    def index_link(model_class, options: {}, url_params: {}, html_options: {}, &block)
      return if unauthorized?(:index, model_class)

      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block,
        block: -> { to_model_label model_class }
      )

      url = options[:url] || index_path(model_class, url_params: url_params)
      link_to url, html_options, &block
    end

    # Return link to create page for a given model class
    # @param model_class [Class]
    # @param options [Hash]
    # @option options [String] :url url/path for the link
    # @param url_params [Hash, ActionController::Parameters]
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String, nil] anchor element
    # @return [nil] if user's not authorized
    def new_link(model_class, options: {}, url_params: {}, html_options: {}, &block)
      return if unauthorized?(:new, model_class) || decorator_of(model_class).readonly?

      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block,
        class: 'resource__create',
        block: -> { wt 'links.new', model: to_model_label(model_class) }
      )

      url = options[:url] || new_path(model_class, url_params: url_params)
      link_to url, html_options, &block
    end

    # Return link to show page for a given model class.
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param options [Hash]
    # @option options [String] :url url/path for the link
    # @option options [Boolean] :readonly readonly and therefore output the label
    # @option options [Boolean] :is_resource to tell {Urlable#show_path} if it is a resource
    # @param url_params [Hash, ActionController::Parameters]
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

      default = (options[:readonly] && block.call) || nil
      return default if unauthorized?(:show, extract(resource))

      url = options[:url] || show_path(resource.itself, url_params: url_params)
      link_to url, html_options, &block
    end

    # Return link to edit page for a given model class.
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param options [Hash]
    # @option options [String] :url url/path for the link
    # @option options [Boolean] :readonly readonly and therefore output the label
    # @option options [Boolean] :is_resource to tell {Urlable#edit_path} if it is a resource
    # @param url_params [Hash, ActionController::Parameters]
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
        block: -> { "#{wt 'links.edit'} #{decorate(resource).to_label}" }
      )

      default = (options[:readonly] && block.call) || nil
      return default if unauthorized?(:edit, extract(resource)) || resource.try(:readonly?)

      url = options[:url] || edit_path(resource.itself, url_params: url_params)
      link_to url, html_options, &block
    end

    # Return link to delete action for a given model class.
    # @param resource [Object, Wallaby::ResourceDecorator] model class
    # @param options [Hash]
    # @option options [String] :url url/path for the link
    # @option options [Boolean] :is_resource to tell {Urlable#edit_path} if it is a resource
    # @param url_params [Hash, ActionController::Parameters]
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String, nil] anchor element
    # @return [nil] if user's not authorized
    def delete_link(resource, options: {}, url_params: {}, html_options: {}, &block)
      return if unauthorized?(:destroy, extract(resource)) || resource.try(:readonly?)

      html_options, block = LinkOptionsNormalizer.normalize(
        html_options, block, class: 'resource__destroy', block: -> { wt 'links.delete' }
      )

      html_options[:method] ||= :delete
      (html_options[:data] ||= {})[:confirm] ||= wt 'links.confirm.delete'

      url = options[:url] || show_path(resource.itself, url_params: url_params)
      link_to url, html_options, &block
    end

    # Return link to cancel action
    # @param html_options [Hash] (see
    #   {https://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#method-i-link_to
    #   ActionView::Helpers::UrlHelper#link_to})
    # @yield block to return the link label
    # @return [String] anchor link of cancel action
    def cancel_link(html_options: {}, &block)
      block ||= -> { wt 'links.cancel' }
      link_to 'javascript:history.back()', html_options, &block
    end
  end
end
