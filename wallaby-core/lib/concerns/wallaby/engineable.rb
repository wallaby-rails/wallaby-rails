# frozen_string_literal: true

module Wallaby
  # {Engine} related helper methods to be included for both controller and view.
  module Engineable
    # This helper method returns the current {Engine} routing proxy.
    # For example, if {Wallaby} is mounted at different paths at the same time:
    #
    #     mount Wallaby::Engine, at: '/admin'
    #     mount Wallaby::Engine, at: '/inner', as: :inner_engine,
    #       defaults: { resources_controller: InnerController }
    #
    # If `/inner` is current request path, it returns `inner_engine` engine proxy.
    # @return [ActionDispatch::Routing::RoutesProxy] engine proxy for current request
    def current_engine
      @current_engine ||= try current_engine_name
    end

    # Find out the {Engine} routing proxy name for the current request, it comes from either:
    #
    # - Current controller's {Configurable::ClassMethods#engine_name engine_name}
    # - Judge from the current request path (which contains the script and path info)
    # @return [String] engine name for current request
    # @see EngineNameFinder.execute
    def current_engine_name
      @current_engine_name ||= wallaby_controller.engine_name || EngineNameFinder.execute(request.path)
    end

    # @return [ActionDispatch::Journey::Route] engine route for current request
    def current_engine_route
      return if current_engine_name.blank?

      Rails.application.routes.named_routes[current_engine_name]
    end

    # @note This script name prefix is required for Rails
    #   {https://api.rubyonrails.org/classes/ActionView/RoutingUrlFor.html#method-i-url_for #url_for}
    #   to generate the correct URL.
    # @return [String] current engine's script name
    def script_name
      current_engine_route.try { |route| route.path.spec.to_s }
    end
  end
end
