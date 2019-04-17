module Wallaby
  # Application helper
  module ApplicationHelper
    include ConfigurationHelper
    include Engineable
    include SharedHelpers

    # Override the origin view_renderer to provide support for cell rendering
    # @!attribute [r] view_renderer
    def view_renderer
      return @view_renderer if @view_renderer.is_a? CustomRenderer
      @view_renderer = CustomRenderer.new @view_renderer.lookup_context
    end

    # Override `actionview/lib/action_view/routing_url_for.rb#url_for` too handle URL for wallaby engine
    # @param options [String, Hash]
    # @param engine_name [String, nil]
    # @return [String] URL string
    def url_for(options = nil, engine_name = current_engine_name)
      options ||= {}
      return super(options) unless options.is_a?(Hash) || options.is_a?(ActionController::Parameters)

      url = EnginePathBuilder.handle(
        engine_name: engine_name, parameters: options, default_url_options: default_url_options
      )
      url ||= main_app.root_path default_url_options.merge(options) if options[:action] == 'home'
      url || super(ModuleUtils.try_to(options, :permit!) || options)
    end

    # It's required by {#url_for}
    # @return [Hash] default URL options
    def default_url_options
      defined?(super) ? super : controller_to_get(:default_url_options)
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

    # Delegate {#try_to} to ModuleUtils
    # @see Wallaby::ModuleUtils.try_to
    def try_to(subject, method_id, *args, &block)
      ModuleUtils.try_to subject, method_id, *args, &block
    end
  end
end
