module Wallaby
  # Decorator related attributes
  module Decoratable
    # Configurable attribute
    module ClassMethods
      # @!attribute [w] resource_decorator
      def resource_decorator=(resource_decorator)
        ModuleUtils.inheritance_check resource_decorator, application_decorator
        @resource_decorator = resource_decorator
      end

      # @!attribute [r] resource_decorator
      # Resource decorator will be used for its metadata info and decoration methods.
      #
      # If Wallaby doesn't get it right, please specify the **resource_decorator**.
      # @example To set resource decorator
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.resource_decorator = ProductDecorator
      #   end
      # @raise [ArgumentError] when **resource_decorator** doesn't inherit from **application_decorator**
      # @see Wallaby::ResourceDecorator
      # @return [Class] resource decorator
      # @since 5.2.0
      attr_reader :resource_decorator

      # @!attribute [w] application_decorator
      # @raise [ArgumentError] when **resource_decorator** doesn't inherit from **application_decorator**
      def application_decorator=(application_decorator)
        ModuleUtils.inheritance_check resource_decorator, application_decorator
        @application_decorator = application_decorator
      end

      # @!attribute [r] application_decorator
      # The **application_decorator** is as the base class of {#resource_decorator}.
      # @example To set application decorator:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_decorator = AnotherApplicationDecorator
      #   end
      # @since 5.2.0
      # @see Wallaby::ResourceDecorator
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
