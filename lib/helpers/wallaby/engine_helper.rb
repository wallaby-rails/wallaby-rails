module Wallaby
  # All current helper methods that will be shared between controller and views
  module EngineHelper
    # @return [] current engine
    def current_engine
      @current_engine ||= begin
        engine_name = EngineUtils.engine_name_from request.env
        respond_to?(engine_name) ? public_send(engine_name) : nil
      end
    end
  end
end
