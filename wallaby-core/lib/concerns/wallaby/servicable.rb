# frozen_string_literal: true

module Wallaby
  # Servicer related attributes
  module Servicable
    # Model servicer for current modal class.
    # @return [ModelServicer] model servicer
    # @see ServicerFinder#execute
    # @since wallaby-5.2.0
    def current_servicer
      @current_servicer ||=
        ServicerFinder.new(
          script_name: script_name,
          model_class: current_model_class,
          current_controller_class: wallaby_controller
        ).execute.try do |klass|
          Logger.debug %(Current servicer: #{klass}), sourcing: false
          klass.new current_model_class, current_authorizer, current_model_decorator
        end
    end
  end
end
