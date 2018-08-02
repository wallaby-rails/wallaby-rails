module Wallaby
  # Decorator related attributes
  module Decoratable
    # Configurable attribute
    module ClassMethods
      # @!attribute resource_decorator
      # @example To set resource decorator
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.resource_decorator = ProductDecorator
      #   end
      # @return [Class] resource decorator
      # @since 5.2.0
      attr_accessor :resource_decorator

      # @!attribute [w] application_decorator
      attr_writer :application_decorator

      # @!attribute [r] application_decorator
      # The `application_decorator` is as the base class of {#resource_decorator}. It
      # @example To set application decorator:
      #   class Admin::ApplicationDecorator < Wallaby::ResourceDecorator
      #   end
      #   class AnotherApplicationDecorator < Wallaby::ResourceDecorator
      #   end
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_decorator = AnotherApplicationDecorator
      #   end
      # @since 5.2.0
      # @return [Class] application decorator
      def application_decorator
        @application_decorator ||= Utils.try_to superclass, :application_decorator
      end
    end

    # Get current model decorator. It comes from
    #
    # - model decorator for {Wallaby::Decoratable::ClassMethods#resource_decorator resource_decorator}
    # - otherwise, model decorator for {Wallaby::Decoratable::ClassMethods#application_decorator application_decorator}
    #
    # Model decorator stores the information of **metadata** and **field_names** for **index**/**show**/**form** action.
    # @return [Wallaby::ModelDecorator] current model decorator for this request
    def current_model_decorator
      @current_model_decorator ||=
        controller_to_get(__callee__, :resource_decorator).try(:model_decorator) \
          || Map.model_decorator_map(current_model_class, controller_to_get(:application_decorator))
    end
  end
end
