module Wallaby
  # Application helper
  module ApplicationHelper
    include ConfigurationHelper

    # Override `actionview/lib/action_view/routing_url_for.rb#url_for`
    # to handle the url_for properly for wallaby engine when options contains
    # values of both `:resources` and `:action`
    # @param options [String, Hash]
    # @return [String] url
    def url_for(options = nil)
      # possible Hash or Parameters
      if options.respond_to?(:to_h) \
        && options[:resources].present? && options[:action].present?
        UrlFor.handle wallaby_engine, options
      else
        super options
      end
    end

    # Add turbolinks options when it's enabled
    # @see ActionView::Helpers::AssetTagHelper#stylesheet_link_tag
    # @param sources [Array<String>] source name under `app/assets/stylesheets`
    # @return [String] a list of stylesheet link tags
    def stylesheet_link_tag(*sources)
      default_options =
        if Wallaby.configuration.features.turbolinks_enabled
          { 'data-turbolinks-track' => true }
        else
          {}
        end
      options = default_options.merge!(sources.extract_options!.stringify_keys)
      super(*sources, options)
    end

    # Add turbolinks options when it's enabled
    # @see ActionView::Helpers::AssetTagHelper#javascript_include_tag
    # @param sources [Array<String>] source name under `app/assets/javascripts`
    # @return [String] a list of javascript script tags
    def javascript_include_tag(*sources)
      default_options =
        if Wallaby.configuration.features.turbolinks_enabled
          { 'data-turbolinks-track' => true, 'data-turbolinks-eval' => false }
        else
          {}
        end
      options = default_options.merge!(sources.extract_options!.stringify_keys)
      super(*sources, options)
    end
  end
end
