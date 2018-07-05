module Wallaby
  # All current helper methods that will be shared between controller and views
  module EngineHelper
    # @return [] current engine
    def current_engine
      @current_engine ||= respond_to?(current_engine_name) ? public_send(current_engine_name) : nil
    end

    def current_engine_name
      @current_engine_name ||= EngineUtils.engine_name_from request.env
    end
  end
end
