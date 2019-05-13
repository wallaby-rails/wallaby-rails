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
      # @return [Class] resource decorator
      # @raise [ArgumentError] when **resource_decorator** doesn't inherit from **application_decorator**
      # @see Wallaby::ResourceDecorator
      # @since 5.2.0
      attr_reader :resource_decorator

      # @!attribute [w] application_decorator
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
      # @raise [ArgumentError] when **resource_decorator** doesn't inherit from **application_decorator**
      # @return [Class] application decorator
      # @see Wallaby::ResourceDecorator
      # @since 5.2.0
      def application_decorator
        @application_decorator ||= ModuleUtils.try_to superclass, :application_decorator
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
        current_decorator.try(:model_decorator) || \
        Map.model_decorator_map(current_model_class, controller_to_get(:application_decorator))
    end

    # Get current resource decorator. It comes from
    #
    # - {Wallaby::Decoratable::ClassMethods#resource_decorator resource_decorator}
    # - otherwise, {Wallaby::Decoratable::ClassMethods#application_decorator application_decorator}
    # @return [Wallaby::ResourceDecorator] current resource decorator for this request
    def current_decorator
      @current_decorator ||=
        (controller_to_get(:resource_decorator) || \
        Map.resource_decorator_map(current_model_class, controller_to_get(:application_decorator))).tap do |decorator|
          Rails.logger.info %(  - Current decorator: #{decorator})
        end
    end

    # Get current fields metadata for current action name.
    # @return [Hash] current fields metadata
    def current_fields
      @current_fields ||=
        ModuleUtils.try_to current_model_decorator, :"#{FORM_ACTIONS[action_name] || action_name}_fields"
    end

    # Wrap resource(s) with decorator(s).
    # @param resource [Object, Enumerable]
    # @return [Wallaby::ResourceDecorator, Enumerable<Wallaby::ResourceDecorator>] decorator(s)
    def decorate(resource)
      return resource if resource.is_a? ResourceDecorator
      return resource.map { |item| decorate item } if resource.respond_to? :map
      decorator = Map.resource_decorator_map resource.class, controller_to_get(:application_decorator)
      decorator ? decorator.new(resource) : resource
    end

    # @param resource [Object, Wallaby::ResourceDecorator]
    # @return [Object] the unwrapped resource object
    def extract(resource)
      return resource.resource if resource.is_a? ResourceDecorator
      resource
    end
  end
end
