module Wallaby
  # Resource Decorator base class
  class AbstractResourceDecorator
    extend Abstractable::ClassMethods
    class << self
      attr_writer :model_class

      # Guess the model class from class name
      # @return [Class]
      def model_class
        return unless self < ResourceDecorator
        return if abstract || self == Wallaby.configuration.mapping.resource_decorator
        @model_class || Map.model_class_map(name.gsub('Decorator', EMPTY_STRING))
      end

      attr_writer :application_decorator

      def application_decorator
        @application_decorator ||=
          ancestors.find do |parent|
            parent <= ResourceDecorator && !(parent.model_class rescue false)
          end
      end

      # Get the model decorator for the model class
      # It should be the same as #model_decorator
      # @return [Wallaby::ModelDecorator]
      def model_decorator
        return unless self < ResourceDecorator
        Map.model_decorator_map model_class, application_decorator
      end

      delegation_methods =
        ModelDecorator.instance_methods \
          - ::Object.instance_methods - %i(model_class)
      delegate(*delegation_methods, to: :model_decorator, allow_nil: true)
    end

    attr_reader :resource, :model_decorator

    # @param resource [Object] resource object
    def initialize(resource)
      @resource = resource
      @model_decorator =
        self.class.model_decorator || Map.model_decorator_map(model_class, self.class.application_decorator)
    end

    # @return [Class] resource's class
    def model_class
      @resource.class
    end

    # Guess the title for given resource
    # It falls back to primary key value when no text field is found
    # `.to_s` at the end is to ensure String is returned that won't cause any
    # issue when `#to_label` is used in a link_to block. Coz integer is ignored.
    # @return [String]
    def to_label
      (@model_decorator.guess_title(@resource) || primary_key_value).to_s
    end

    # Return the validation errors
    # @return [Hash, Array]
    def errors
      @model_decorator.form_active_errors(@resource)
    end

    # @return [Object] primary key value
    def primary_key_value
      @resource.public_send primary_key
    end

    delegation_methods =
      ModelDecorator.instance_methods \
        - ::Object.instance_methods - %i(model_class)
    delegate(*delegation_methods, to: :model_decorator)
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
