module Wallaby
  # Resource Decorator base class, designed for decorator pattern.
  # @see Wallaby::ModelDecorator
  class ResourceDecorator
    extend Baseable::ClassMethods

    DELEGATE_METHODS =
      ModelDecorator.public_instance_methods(false) + Fieldable.public_instance_methods(false) - %i(model_class)

    class << self
      delegate(*DELEGATE_METHODS, to: :model_decorator, allow_nil: true)

      # @!attribute [w] model_class
      attr_writer :model_class

      # @!attribute [r] model_class
      # Return associated model class, e.g. return **Product** for **ProductDecorator**.
      #
      # If Wallaby can't recognise the model class for Decorator, it's required to be configured as below example:
      # @example To configure model class
      #   class Admin::ProductDecorator < Admin::ApplicationDecorator
      #     self.model_class = Product
      #   end
      # @example To configure model class for version below 5.2.0
      #   class Admin::ProductDecorator < Admin::ApplicationDecorator
      #     def self.model_class
      #       Product
      #     end
      #   end
      # @return [Class] assoicated model class
      # @return [nil] if current class is marked as base class
      # @return [nil] if current class is the same as the value of {Wallaby::Configuration::Mapping#resource_decorator}
      # @return [nil] if current class is {Wallaby::ResourceDecorator}
      # @return [nil] if assoicated model class is not found
      def model_class
        return unless self < ResourceDecorator
        return if base_class? || self == Wallaby.configuration.mapping.resource_decorator
        @model_class ||= Map.model_class_map(name.gsub(/(^#{namespace}::)|(Decorator$)/, EMPTY_STRING))
      end

      # @!attribute [w] application_decorator
      def application_decorator=(application_decorator)
        ModuleUtils.inheritance_check self, application_decorator
        @application_decorator = application_decorator
      end

      # @note This attribute have to be the same as the one defined in the controller in order to make things working.
      #   see {Wallaby::Decoratable::ClassMethods#application_decorator}
      # @!attribute [r] application_decorator
      # Assoicated base class.
      #
      # Wallaby will try to get the application decorator class from current class's ancestors chain.
      # For instance, if current class is **ProductDecorator**, and it inherits from **CoreDecorator**,
      # then Wallaby will return application decorator class **CoreDecorator**.
      #
      # However, there is a chance that Wallaby doesn't get it right.
      # For instance, if **CoreDecorator** in the above example inherits from **Admin::ApplicationDecorator**, and
      # the controller that needs **ProductDecorator** has set its **application_decorator** to
      # **Admin::ApplicationDecorator**, then it's needed to configure **application_decorator** as the example
      # describes
      # @example To set application decorator class
      #   class ProductController < Admin::ApplicationController
      #     self.application_decorator = Admin::ApplicationDecorator
      #   end
      #
      #   class CoreDecorator < Admin::ApplicationDecorator
      #     base_class!
      #   end
      #
      #   class ProductDecorator < CoreDecorator
      #     self.application_decorator = Admin::ApplicationDecorator
      #   end
      # @return [Class] assoicated base class.
      # @return [nil] if assoicated base class is not found from its ancestors chain
      # @raise [ArgumentError] when current class doesn't inherit from given value
      # @since 5.2.0
      def application_decorator
        @application_decorator ||= ancestors.find { |parent| parent < ResourceDecorator && !parent.model_class }
      end

      # Return associated model decorator.
      #
      # Fetch model decorator instance from cached map using keys {.model_class} and {.application_decorator}
      # so that model decorator can be used in its sub classes declaration/scope.
      # @param model_class [Class]
      # @return [Wallaby::ModelDecorator]
      def model_decorator(model_class = self.model_class)
        return unless self < ResourceDecorator || model_class
        Map.model_decorator_map model_class, application_decorator
      end

      # @!attribute [w] h
      attr_writer :h

      # @!attribute [r] h
      # @return [ActionView::Base]
      #   {Wallaby::Configuration::Mapping#resources_controller resources controller}'s helpers
      def h
        @h ||= Wallaby.configuration.mapping.resources_controller.helpers
      end
    end

    # @!attribute [r] resource
    # @return [Object]
    attr_reader :resource

    # @!attribute [r] model_decorator
    # @return [Wallaby::ModelDecorator]
    attr_reader :model_decorator

    # @return [ActionView::Base]
    #   {Wallaby::Configuration::Mapping#resources_controller resources controller}'s helpers
    # @see .h
    def h
      self.class.h
    end

    delegate(*DELEGATE_METHODS, to: :model_decorator)
    # NOTE: this delegation is to make url helper method working properly with resource decorator instance
    delegate :to_s, :to_param, to: :resource

    # @param resource [Object]
    def initialize(resource)
      @resource = resource
      @model_decorator = self.class.model_decorator(model_class)
    end

    # @return [Class] resource's class
    def model_class
      resource.class
    end

    # @param field_name [String, Symbol]
    # @return [Object] value of given field name
    def value_of(field_name)
      return unless field_name
      resource.public_send field_name
    end

    # Guess the title for given resource.
    #
    # It falls back to primary key value when no text field is found.
    # @return [String] a label
    def to_label
      # NOTE: `.to_s` at the end is to ensure String is returned that won't cause any
      # issue when `#to_label` is used in a link_to block. Coz integer is ignored.
      (model_decorator.guess_title(resource) || primary_key_value).to_s
    end

    # @return [Hash, Array] validation/result errors
    def errors
      model_decorator.form_active_errors(resource)
    end

    # @return [Object] primary key value
    def primary_key_value
      resource.public_send primary_key
    end

    # @return [ActiveModel::Name]
    def model_name
      ModuleUtils.try_to(resource, :model_name) || ActiveModel::Name.new(model_class)
    end

    # @return [nil] if no primary key
    # @return [Array<String>] primary key
    def to_key
      key = ModuleUtils.try_to(resource, primary_key)
      key ? [key] : nil
    end

    # Delegate missing method to {#resource}
    def method_missing(method_id, *args, &block)
      return super unless resource.respond_to? method_id
      resource.public_send method_id, *args, &block
    end

    # Delegate missing method check to context
    def respond_to_missing?(method_id, _include_private)
      resource.respond_to?(method_id) || super
    end
  end
end
