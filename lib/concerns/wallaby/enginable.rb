module Wallaby
  # This is a collection of the helper methods that overrides the rails methods
  module Enginable
    # Class method for Enginable concern
    module ClassMethods
      # @!attribute [w] engine_name
      attr_writer :engine_name

      # @!attribute [r] engine_name
      def engine_name
        @engine_name ||= Utils.try_to superclass, :engine_name
      end
    end

    # @note This method will be shared in controller and view context.
    # Find out the engine name under current script name.
    #
    # Considering `Wallaby` is mounted at the following paths:
    #
    # ```
    # mount Wallaby::Engine, at: '/admin'
    # mount Wallaby::Engine, at: '/inner', as: :inner_engine, defaults: { resources_controller: InnerController }
    # ```
    #
    # and `/inner` is current script name, then `current_engine_name` is `'inner_engine'`
    # @return [String] engine name for current request
    def current_engine_name
      @current_engine_name ||=
        if is_a? ::ActionController::Base then Utils.try_to self.class, :engine_name
        else Utils.try_to controller, :current_engine_name
        end || EngineNameFinder.find(request.env) || EMPTY_STRING
    end

    # This is mainly used by {Wallaby::LinksHelper}.
    #
    # Considering `Wallaby` is mounted at the following paths:
    #
    # ```
    # mount Wallaby::Engine, at: '/admin'
    # mount Wallaby::Engine, at: '/inner', as: :inner_engine, defaults: { resources_controller: InnerController }
    # ```
    #
    # and `/inner` is current script name, then `current_engine` is `inner_engine`
    # @return [ActionDispatch::Routing::RoutesProxy] engine for current request
    def current_engine
      @current_engine ||= Utils.try_to self, current_engine_name
    end
  end
end
