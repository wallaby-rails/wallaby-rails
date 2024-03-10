# frozen_string_literal: true

module Wallaby
  # Decorator base class. It's designed to be used as the decorator (AKA presenter/view object)
  # for the associated model instance (which means it should be used in the views only).
  #
  # And it holds the following field metadata information for associated model class:
  #
  # - {#fields} - all other `*_fields` methods origin from it. and it's frozen.
  # - {#field_names} - all other `*_field_names` methods origin from it. and it's frozen.
  # - {#index_fields} - field metdata used on index page
  # - {#index_field_names} - field name list used on index page
  # - {#show_fields} - field metdata used on show page
  # - {#show_field_names} - field name list used on show page
  # - {#form_fields} - field metdata used on new/create/edit/update page
  # - {#form_field_names} - field name list used on new/create/edit/update page
  #
  # For better practice, please create an application decorator class (see example)
  # to better control the functions shared between different decorators.
  # @example Create an application class for Admin Interface usage
  #   class Admin::ApplicationDecorator < Wallaby::ResourceDecorator
  #     base_class!
  #   end
  class ResourceDecorator
    extend Baseable::ClassMethods
    base_class!

    # @!attribute fields
    #   (see Wallaby::ModelDecorator#fields)

    # @!attribute field_names
    #   (see Wallaby::ModelDecorator#field_names)

    # @!attribute index_fields
    #   (see Wallaby::ModelDecorator#index_fields)

    # @!attribute index_field_names
    #   (see Wallaby::ModelDecorator#index_field_names)

    # @!attribute show_fields
    #   (see Wallaby::ModelDecorator#show_fields)

    # @!attribute show_field_names
    #   (see Wallaby::ModelDecorator#show_field_names)

    # @!attribute form_fields
    #   (see Wallaby::ModelDecorator#form_fields)

    # @!attribute form_field_names
    #   (see Wallaby::ModelDecorator#form_field_names)

    DELEGATE_METHODS =
      ModelDecorator.public_instance_methods(false) + Fieldable.public_instance_methods(false) - %i[model_class]

    class << self
      # @!attribute fields
      #   (see Wallaby::ModelDecorator#fields)

      # @!attribute field_names
      #   (see Wallaby::ModelDecorator#field_names)

      # @!attribute index_fields
      #   (see Wallaby::ModelDecorator#index_fields)

      # @!attribute index_field_names
      #   (see Wallaby::ModelDecorator#index_field_names)

      # @!attribute show_fields
      #   (see Wallaby::ModelDecorator#show_fields)

      # @!attribute show_field_names
      #   (see Wallaby::ModelDecorator#show_field_names)

      # @!attribute form_fields
      #   (see Wallaby::ModelDecorator#form_fields)

      # @!attribute form_field_names
      #   (see Wallaby::ModelDecorator#form_field_names)

      delegate(*DELEGATE_METHODS, to: :model_decorator, allow_nil: true)

      # Return associated {ModelDecorator model decorator}. It is the instance that pull out all the metadata
      # information from the associated model.
      # @param model_class [Class]
      # @return [ModelDecorator]
      # @return [nil] if itself is a base class or the given model_class is blank
      def model_decorator(model_class = self.model_class)
        return if model_class.blank?

        Map.model_decorator_map(model_class, base_class)
      end

      # @!attribute [w] h
      attr_writer :h

      # @!attribute [r] h
      # @return [ActionView::Base] {ResourcesController}'s helpers
      def h
        @h ||= superclass.try(:h) || ResourcesController.helpers
      end

      # @!attribute [w] readonly
      attr_writer :readonly

      def readonly?
        @readonly
      end

      # Delegate missing method to {.model_decorator}
      def method_missing(method_id, *args, &block)
        return if ModelDecorator::MISSING_METHODS_RELATED_TO_FIELDS.match?(method_id.to_s) && model_decorator.blank?
        return super unless model_decorator.try(:respond_to?, method_id)

        model_decorator.try(method_id, *args, &block)
      end

      # Delegate missing method check to {.model_decorator}
      def respond_to_missing?(method_id, _include_private)
        model_decorator.try(:respond_to?, method_id) || super
      end
    end

    # @!attribute [r] resource
    # @return [Object]
    attr_reader :resource

    # @!attribute [r] model_decorator
    # @return [ModelDecorator]
    attr_reader :model_decorator

    # @return [ActionView::Base] {ResourcesController}'s helpers
    # @see .h
    def h
      self.class.h
    end

    delegate(*DELEGATE_METHODS, to: :model_decorator)
    # NOTE: this delegation is to make Rails URL helper methods working properly with decorator instance
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

      resource.try field_name
    end

    # Guess the title for given resource.
    #
    # It falls back to primary key value when no text field is found.
    # @return [String] a label
    def to_label
      # NOTE: `.to_s` at the end is to ensure String is returned.
      # There is an issue when {#to_label} returns an integer value, and it is used in a #link_to block,
      # the #link_to will generate empty link text when integer value is given in the block.
      (model_decorator.guess_title(resource) || primary_key_value).to_s
    end

    # @return [Hash, Array] validation/result errors
    def errors
      model_decorator.form_active_errors(resource)
    end

    # @return [Object] primary key value
    def primary_key_value
      return if primary_key.blank?

      resource.try primary_key
    end

    # @note this method is for the Rails URL helper methods to recognize non-ActiveModel models
    # @return [ActiveModel::Name]
    def model_name
      resource.try(:model_name) || ActiveModel::Name.new(model_class)
    end

    # @see https://github.com/rails/rails/compare/v7.0.2.4..7-0-stable#diff-44b94eca66c7497711821a8e6bcdfde4684bb7b8efa15e64da6532449f03ef0bR441
    # @note This overwritten method is a response to the above change
    def to_model
      self
    end

    # @note this method is for the Rails form helper methods to recognize non-ActiveModel models
    # @return [nil] if no primary key
    # @return [Array<String>] primary key
    def to_key
      key = resource.try primary_key
      key ? [key] : nil
    end

    # @return [true, false] if resource responds to method `.readonly?`
    # @return [false] otherwise
    def readonly?
      resource.try(:readonly?) || self.class.try(:readonly?)
    end

    # Delegate missing method to {#resource}
    def method_missing(method_id, *args, &block)
      if resource.respond_to?(method_id)
        resource.try(method_id, *args, &block)
      elsif model_decorator.respond_to?(method_id)
        model_decorator.try(method_id, *args, &block)
      else
        super
      end
    end

    # Delegate missing method check to {#resource}
    def respond_to_missing?(method_id, _include_private)
      [resource, model_decorator].any? { |v| v.respond_to?(method_id) } || super
    end
  end
end
