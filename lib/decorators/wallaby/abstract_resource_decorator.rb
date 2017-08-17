module Wallaby
  # Resource Decorator base class
  class AbstractResourceDecorator
    class << self
      def model_class
        return unless self < ::Wallaby::ResourceDecorator
        @model_class ||= begin
          model_name = name.gsub('Decorator', EMPTY_STRING)
          Map.model_class_map model_name
        end
      end

      def model_decorator
        return unless self < ::Wallaby::ResourceDecorator
        @model_decorator ||= Map.model_decorator_map model_class
      end

      def decorate(resource)
        return resource if resource.is_a? ResourceDecorator
        new resource
      end

      class_methods =
        ModelDecorator.instance_methods \
          - ::Object.instance_methods - %i(model_class)
      delegate(*class_methods, to: :model_decorator, allow_nil: true)
    end

    attr_reader :resource, :model_decorator

    def initialize(resource)
      @resource = resource
      @model_decorator =
        Map.model_decorator_map(model_class) \
          || NilModelDecorator.new(model_class)
    end

    def method_missing(method_id, *args)
      return super unless @resource.respond_to? method_id
      @resource.public_send method_id, *args
    end

    def respond_to_missing?(method_id, _include_private)
      @resource.respond_to?(method_id) || super
    end

    delegate :to_s, :to_param, :to_params, to: :resource
    implemented_methods =
      %i(
        index_fields index_field_names
        show_fields show_field_names
        form_fields form_field_names
      )
    instance_methods =
      ModelDecorator.instance_methods \
        - implemented_methods \
        - ::Object.instance_methods
    delegate(*instance_methods, to: :model_decorator)

    def model_class
      @resource.class
    end

    def to_label
      (@model_decorator.guess_title(@resource) || primary_key_value).to_s
    end

    def errors
      @model_decorator.form_active_errors(@resource)
    end

    def primary_key_value
      @resource.public_send primary_key
    end

    [EMPTY_STRING, 'index_', 'show_', 'form_'].each do |prefix|
      class_eval <<-RUBY
        def #{prefix}fields
          @#{prefix}fields ||= @model_decorator.#{prefix}fields.dup.freeze
        end

        def #{prefix}field_names
          @#{prefix}field_names ||= @model_decorator.#{prefix}field_names.dup.freeze
        end
      RUBY
    end
  end
end
