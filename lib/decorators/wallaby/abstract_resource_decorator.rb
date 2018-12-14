module Wallaby
  # Resource Decorator base class
  class AbstractResourceDecorator
    extend Abstractable::ClassMethods

    DELEGATE_METHODS = ModelDecorator.public_instance_methods - ::Object.public_instance_methods - %i(model_class)

    class << self
      # @!attribute [w] model_class
      attr_writer :model_class

      # @!attribute [r] model_class
      # Return the assoicated model class.
      #
      # If model class is not set, Wallaby will try to get it from current class.
      # For instance, if current class is **ProductDecorator**, then Wallaby will return model class **Product**.
      #
      # However, if current class is **Admin::ProductDecorator**, it's needed to configure the model class as in the
      # example
      # @example To set model class
      #   class Admin::ProductDecorator < Admin::ApplicationDecorator
      #     self.model_class = Product
      #   end
      # @return [Class] assoicated model class
      def model_class
        return unless self < ResourceDecorator
        return if abstract || self == Wallaby.configuration.mapping.resource_decorator
        @model_class ||= Map.model_class_map(name.gsub('Decorator', EMPTY_STRING))
      end

      # @!attribute [w] application_decorator
      def application_decorator=(application_decorator)
        ModuleUtils.inheritance_check self, application_decorator
        @application_decorator = application_decorator
      end

      # @note This attribute have to be the same as the one defined in the controller in order to make things working.
      #   see {Wallaby::Decoratable::ClassMethods#application_decorator}
      # @!attribute [r] application_decorator
      # Return the assoicated application decorator class.
      #
      # If application decorator class is not set, Wallaby will try to get it from current class's ancestors.
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
      #     abstract!
      #   end
      #
      #   class ProductDecorator < CoreDecorator
      #     self.application_decorator = Admin::ApplicationDecorator
      #   end
      # @return [Class] assoicated application decorator class.
      # @raise [ArgumentError] when itself doesn't inherit from given **application_decorator**
      # @since 5.2.0
      def application_decorator
        @application_decorator ||= ancestors.find { |parent| parent < ResourceDecorator && !parent.model_class }
      end

      # Fetch model decorator from cached map using keys {.model_class} and {.application_decorator}.
      #
      # The idea is to use model decorator instance to store metadata for index/show/form actions.
      # @param model_class [Class] model class
      # @return [Wallaby::ModelDecorator] model decorator
      def model_decorator(model_class = self.model_class)
        return unless self < ResourceDecorator || model_class
        Map.model_decorator_map model_class, application_decorator
      end

      delegate(*DELEGATE_METHODS, to: :model_decorator, allow_nil: true)
    end

    attr_reader :resource, :model_decorator

    def initialize(resource)
      @resource = resource
      @model_decorator = self.class.model_decorator || self.class.model_decorator(model_class)
    end

    # @return [Class] resource's class
    def model_class
      @resource.class
    end

    # Guess the title for given resource.
    #
    # It falls back to primary key value when no text field is found.
    # @return [String] a label
    def to_label
      # `.to_s` at the end is to ensure String is returned that won't cause any
      # issue when `#to_label` is used in a link_to block. Coz integer is ignored.
      (@model_decorator.guess_title(@resource) || primary_key_value).to_s
    end

    # @return [Hash, Array] validation/result errors
    def errors
      @model_decorator.form_active_errors(@resource)
    end

    # @return [Object] primary key value
    def primary_key_value
      @resource.public_send primary_key
    end

    delegate(*DELEGATE_METHODS, to: :model_decorator)
    delegate :to_s, :to_param, to: :resource

    # We delegate missing methods to resource
    # @param method_id [String,Symbol]
    # @param args [Array]
    def method_missing(method_id, *args)
      return super unless @resource.respond_to? method_id
      @resource.public_send method_id, *args
    end

    # @param method_id [String,Symbol]
    # @param _include_private [Boolean]
    def respond_to_missing?(method_id, _include_private)
      @resource.respond_to?(method_id) || super
    end
  end
end
