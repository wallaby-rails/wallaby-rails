module Wallaby
  # Wallaby application helper
  module ApplicationHelper
    include ConfigurationHelper
    include Engineable
    include SharedHelpers

    # @!method try_to(subject, method_id, *args, &block)
    #   (see Wallaby::ModuleUtils.try_to)
    #   @see Wallaby::ModuleUtils.try_to
    delegate :try_to, to: ModuleUtils

    # Override the origin view_renderer to provide support for cell rendering
    # @!attribute [r] view_renderer
    #   @see Wallaby::CustomRenderer
    def view_renderer
      return @view_renderer if @view_renderer.is_a? CustomRenderer
      @view_renderer = CustomRenderer.new @view_renderer.lookup_context
    end

    # Override origin method to handle URL for Wallaby engine.
    #
    # As Wallaby's routes are declared in a
    # {https://guides.rubyonrails.org/routing.html#routing-to-rack-applications Rack application} style, this will
    # lead to **ActionController::RoutingError** exception when using ordinary **url_for**
    # (e.g. `url_for action: :index`).
    #
    # This will handle the URLs for:
    #
    # - Wallaby engine, e.g. `mount Wallaby::Engine => '/admin'`
    # - Nested resource(s), e.g. `scope(path: '/nested', as: :nested) { wresources :products }`
    # @param options [String, Hash, ActionController::Parameters]
    # @option options [Boolean]
    #   :with_query to include `request.query_parameters` values for url generation.
    # @return [String] URL string
    # @see Wallaby::EngineUrlFor.handle
    # @see Wallaby::CurrentUrlFor.handle
    # @see https://api.rubyonrails.org/classes/ActionView/RoutingUrlFor.html#method-i-url_for
    #   ActionView::RoutingUrlFor#url_for
    def url_for(options = nil)
      options ||= {}
      return super(options) unless options.is_a?(Hash)

      options = request.query_parameters.merge(options) if options.delete(:with_query)
      EngineUrlFor.handle(engine: current_engine, parameters: options, script_name: request.env[SCRIPT_NAME]) \
        || CurrentUrlFor.handle(context: self, parameters: options) || super(options)
    end

    # Override origin method to add turbolinks tracking when it's enabled
    # @param sources [Array<String>]
    # @return [String] stylesheet link tags HTML
    def stylesheet_link_tag(*sources)
      default_options =
        features.turbolinks_enabled ? { 'data-turbolinks-track' => true } : {}
      options = default_options.merge!(sources.extract_options!.stringify_keys)
      super(*sources, options)
    end

    # Override origin method to add turbolinks tracking when it's enabled
    # @param sources [Array<String>]
    # @return [String] javascript script tags HTML
    def javascript_include_tag(*sources)
      default_options =
        features.turbolinks_enabled ? { 'data-turbolinks-track' => true, 'data-turbolinks-eval' => false } : {}
      options = default_options.merge!(sources.extract_options!.stringify_keys)
      super(*sources, options)
    end
  end
end
