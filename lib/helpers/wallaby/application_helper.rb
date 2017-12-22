module Wallaby
  # Application helper
  module ApplicationHelper
    # Override `actionview/lib/action_view/routing_url_for.rb#url_for`
    # to handle the url_for properly for wallaby engine
    def url_for(options = nil)
      # possible Hash or Parameters
      if options.respond_to?(:to_h) \
        && options[:resources].present? && options[:action].present?
        UrlFor.handle wallaby_engine, options
      else
        super options
      end
    end

    # TODO: remove this with turbolinks
    def stylesheet_link_tag(*sources)
      default_options = { 'data-turbolinks-track' => true }
      options = default_options.merge!(sources.extract_options!.stringify_keys)
      super(*sources, options)
    end

    # TODO: remove this with turbolinks
    def javascript_include_tag(*sources)
      default_options =
        { 'data-turbolinks-track' => true, 'data-turbolinks-eval' => false }
      options = default_options.merge!(sources.extract_options!.stringify_keys)
      super(*sources, options)
    end
  end
end
