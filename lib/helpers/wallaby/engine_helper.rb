module Wallaby
  # It contains helper methods related to Rails engine. And it's used by controller and views
  module EngineHelper
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
      @current_engine_name ||= EngineNameFinder.find request.env
    end
  end
end
