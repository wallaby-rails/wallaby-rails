# frozen_string_literal: true

module Wallaby
  # Model Decorator interface, designed to hold and maintain metadata for all fields from the data source (database/api)
  # @see {ResourceDecorator} for more information on how to customize metadata
  class ModelDecorator
    include Fieldable

    MISSING_METHODS_RELATED_TO_FIELDS =
      /\A(?<prefix>[a-zA-Z]\w*_)(?<method_partial>fields=?|field_names=?|metadata_of|label_of|type_of)\Z/.freeze

    # Initialize with model class
    # @param model_class [Class]
    def initialize(model_class)
      @model_class = model_class
    end

    # @!attribute [r] model_class
    # @return [Class]
    attr_reader :model_class

    # @see AllFields
    # @!attribute [r] all_fields
    def all_fields
      AllFields.new self
    end

    # @!attribute [r] fields
    # @note to be implemented in subclasses.
    # Origin fields metadata.
    #
    # Initially, {#index_fields}, {#show_fields} and {#form_fields} are copies of it.
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def fields
      raise NotImplemented
    end

    # @!attribute [w] model_class
    def fields=(fields)
      @fields = fields.with_indifferent_access
    end

    # @!attribute [r] index_fields
    # @note to be implemented in subclasses.
    # Fields metadata for `index` page.
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def index_fields
      raise NotImplemented
    end

    # @!attribute [r] show_fields
    # @note to be implemented in subclasses.
    # Fields metadata for `show` page.
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def show_fields
      raise NotImplemented
    end

    # @!attribute [r] form_fields
    # @note to be implemented in subclasses.
    # Fields metadata for form (`new`/`edit`) page.
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def form_fields
      raise NotImplemented
    end

    # @!attribute [r] form_field_names
    # A list of field names for form (`new`/`edit`) page
    # @return [Array<String, Symbol>]
    def form_field_names
      @form_field_names ||= form_fields.keys - [primary_key.to_s]
    end

    # @!attribute [r] filters
    # @note to be implemented in subclasses.
    # Filter metadata for index page.
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def filters
      @filters ||= ::ActiveSupport::HashWithIndifferentAccess.new
    end

    # @note to be implemented in subclasses.
    # Validation error for given resource
    # @param _resource [Object]
    # @return [ActiveModel::Errors, Hash]
    def form_active_errors(_resource)
      raise NotImplemented
    end

    # @!attribute [w] primary_key
    attr_writer :primary_key

    # @!attribute [r] primary_key
    # @note to be implemented in subclasses.
    # @return [String] primary key name
    def primary_key
      raise NotImplemented
    end

    # @note to be implemented in subclasses.
    # To guess the title for a resource.
    #
    # This title will be used on the following places:
    #
    # - page title on show page
    # - in the response for autocomplete association field
    # - title of show link for a resource
    # @param _resource [Object]
    # @return [String] title of current resource
    def guess_title(_resource)
      raise NotImplemented
    end

    # @return [String]
    # @see Map.resources_name_map
    def resources_name
      Map.resources_name_map model_class
    end

    # Delegate missing methods to {Fieldable} if possible
    def method_missing(method_id, *args, &block)
      method_name = method_id.to_s
      return super unless method_name.match?(MISSING_METHODS_RELATED_TO_FIELDS)

      matched = MISSING_METHODS_RELATED_TO_FIELDS.match(method_name)
      try("prefix_#{matched[:method_partial]}", *args, matched[:prefix], &block)
    end

    # Check if method looks like: `_fields`, `_field_names` that can be processed by {Fieldable}
    def respond_to_missing?(method_id, _include_private)
      method_name = method_id.to_s
      method_name.match?(MISSING_METHODS_RELATED_TO_FIELDS) || super
    end

    protected

    # Move primary key to the front for given field names.
    # @param field_names [Array<String, Symbol>] field names
    # @param primary_key [String, Symbol] primary key name
    # @return [Array<String, Symbol>]
    # a new list of field names that primary key goes first
    def reposition(field_names, primary_key = self.primary_key)
      return field_names if primary_key.blank?

      field_names.unshift(primary_key.to_s).uniq
    end

    # Ensure the type is present for given field name
    # @param type [String, Symbol, nil]
    # @return [String, Symbol] type
    # @raise [ArgumentError] when type is nil
    def ensure_type_is_present(field_name, type, prefix = '')
      type || raise(::ArgumentError, <<~INSTRUCTION
        The type for field `#{field_name}` is missing in metadata `#{prefix}_fields`.
        The possible causes are:

        1. Check type's value from metadata `#{prefix}_fields[:#{field_name}][:type]`.
          If it is missing, specify the type as below:

          #{prefix}fields[:#{field_name}][:type] = 'string'

        2. If metadata `#{prefix}_fields` is blank, maybe table hasn't be created yet
          or there is some error in the decorator class declaration.
      INSTRUCTION
      )
    end
  end
end
