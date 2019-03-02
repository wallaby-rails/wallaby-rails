module Wallaby
  # Engine related helper methods for both controller and view
  module Engineable
    # Configurable attribute
    module ClassMethods
      # @!attribute [w] engine_name
      attr_writer :engine_name

      # @!attribute [r] engine_name
      # The engine name will be used to handle URLs.
      #
      # So when to set this engine name? When Wallaby doesn't know what is the correct engine helper to use.
      # @example To set an engine name:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.engine_name = 'admin_engine'
      #   end
      # @return [String, Symbol, nil] engine name
      # @since 5.2.0
      def engine_name
        @engine_name ||= ModuleUtils.try_to superclass, :engine_name
      end
    end

    # This engine helper is used to access URL helpers of Wallaby engine.
    #
    # Considering **Wallaby** is mounted at the following paths:
    #
    # ```
    # mount Wallaby::Engine, at: '/admin'
    # mount Wallaby::Engine, at: '/inner', as: :inner_engine, defaults: { resources_controller: InnerController }
    # ```
    #
    # If `/inner` is current script name, `current_engine` is same as `inner_engine`.
    # Then it's possible to access URL helpers like this:
    #
    # ```
    # current_engine.resources_path resources: 'products'
    # ```
    # @return [ActionDispatch::Routing::RoutesProxy] engine for current request
    def current_engine
      @current_engine ||= ModuleUtils.try_to self, current_engine_name
    end

    # Find out the engine name under current script name.
    #
    # Considering **Wallaby** is mounted at the following paths:
    #
    # ```
    # mount Wallaby::Engine, at: '/admin'
    # mount Wallaby::Engine, at: '/inner', as: :inner_engine, defaults: { resources_controller: InnerController }
    # ```
    #
    # If `/inner` is current script name, then `current_engine_name` returns `'inner_engine'`.
    # @return [String] engine name for current request
    def current_engine_name
      @current_engine_name ||= controller_to_get(__callee__, :engine_name) || EngineNameFinder.find(request.env)
    end
  end
end
