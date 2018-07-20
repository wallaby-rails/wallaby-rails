module Wallaby
  # Application helper
  module ApplicationHelper
    include ConfigurationHelper
    include Enginable

    # Override `actionview/lib/action_view/routing_url_for.rb#url_for` too handle URL for wallaby engine
    # @param options [String, Hash]
    # @param engine_name [String, nil]
    # @return [String] url
    def url_for(options = nil, engine_name = current_engine_name)
      options ||= {}
      return super(options) unless options.is_a?(Hash) || options.is_a?(ActionController::Parameters)

      url = EnginePathBuilder.handle(
        context: self, engine_name: engine_name, parameters: options, default_url_options: default_url_options
      )
      url ||= main_app.root_path default_url_options.merge(options) if options[:action] == 'home'
      url || super(options)
    end

    # Add turbolinks options when it's enabled
    # @see ActionView::Helpers::AssetTagHelper#stylesheet_link_tag
    # @param sources [Array<String>] source name under `app/assets/stylesheets`
    # @return [String] a list of stylesheet link tags
    def stylesheet_link_tag(*sources)
      default_options =
        if features.turbolinks_enabled then { 'data-turbolinks-track' => true }
        else {}
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
        if features.turbolinks_enabled then { 'data-turbolinks-track' => true, 'data-turbolinks-eval' => false }
        else {}
        end
      options = default_options.merge!(sources.extract_options!.stringify_keys)
      super(*sources, options)
    end
  end
end
