module Wallaby
  # Decorator related attributes
  module Decoratable
    # Configurable attribute
    module ClassMethods
      # @!attribute model_decorator
      # @example To set model decorator
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.model_decorator = ProductDecorator
      #   end
      # @since 5.2.0
      attr_accessor :model_decorator

      # @!attribute [w] application_decorator
      attr_writer :application_decorator

      # @!attribute [r] application_decorator
      # The `application_decorator` is as the base class of `model_decorator`
      # @example To set application decorator:
      #   class Admin::ApplicationDecorator < Wallaby::ResourceDecorator
      #   end
      #   class AnotherApplicationDecorator < Wallaby::ResourceDecorator
      #   end
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_decorator = AnotherApplicationDecorator
      #   end
      # @since 5.2.0
      # @return [String, nil] engine name
      def application_decorator
        @application_decorator ||= Utils.try_to superclass, :application_decorator
      end
    end

    # Get current model decorator. It comes from
    #
    # - class attribute `model_decorator`
    # - otherwise, application decorator
    #
    # Model decorator is normally used to get the **metadata**/**field_names** for **index**/**show**/**form**
    # @return [String] engine name for current request
    def current_model_decorator
      @current_model_decorator ||=
        controller_to_get(__callee__, :model_decorator) \
          || Map.model_decorator_map(current_model_class, controller_to_get(:application_decorator))
    end
  end
end
