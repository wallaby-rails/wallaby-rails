module Wallaby
  # Model Decorator interface, designed to maintain metadata for all fields from the data source (database/api)
  # @see Wallaby::ResourceDecorator for more information on how to customize metadata
  class ModelDecorator
    include Fieldable

    # Initialize with model class
    # @param model_class [Class]
    def initialize(model_class)
      @model_class = model_class
    end

    # @!attribute [r] model_class
    # @return [Class]
    attr_reader :model_class

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

    # @!attribute [w] index_fields
    def index_fields=(fields)
      @index_fields = fields.with_indifferent_access
    end

    # @!attribute [w] index_field_names
    attr_writer :index_field_names

    # @!attribute [r] index_field_names
    # A list of field names for `index` page
    # @return [Array<String, Symbol>]
    def index_field_names
      @index_field_names ||= reposition index_fields.keys, primary_key
    end

    # @!attribute [r] show_fields
    # @note to be implemented in subclasses.
    # Fields metadata for `show` page.
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def show_fields
      raise NotImplemented
    end

    # @!attribute [w] show_fields
    def show_fields=(fields)
      @show_fields = fields.with_indifferent_access
    end

    # @!attribute [w] show_field_names
    attr_writer :show_field_names

    # @!attribute [r] show_field_names
    # A list of field names for `show` page
    # @return [Array<String, Symbol>]
    def show_field_names
      @show_field_names ||= reposition show_fields.keys, primary_key
    end

    # @!attribute [r] form_fields
    # @note to be implemented in subclasses.
    # Fields metadata for form (`new`/`edit`) page.
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def form_fields
      raise NotImplemented
    end

    # @!attribute [w] form_fields
    def form_fields=(fields)
      @form_fields = fields.with_indifferent_access
    end

    # @!attribute [w] form_field_names
    attr_writer :form_field_names

    # @!attribute [r] form_field_names
    # A list of field names for form (`new`/`edit`) page
    # @return [Array<String, Symbol>]
    def form_field_names
      @form_field_names ||= reposition form_fields.keys, primary_key
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
    # @see Wallaby::Map.resources_name_map
    def resources_name
      Map.resources_name_map model_class
    end

    protected

    # Move primary key to the front for given field names.
    # @param field_names [Array<String, Symbol>] field names
    # @param primary_key [String, Symbol] primary key name
    # @return [Array<String, Symbol>]
    # a new list of field names that primary key goes first
    def reposition(field_names, primary_key)
      field_names.unshift(primary_key.to_s).uniq
    end

    # Validate presence of a type for given field name
    # @param type [String, Symbol, nil]
    # @return [String, Symbol] type
    # @raise [ArgumentError] when type is nil
    def validate_presence_of(field_name, type)
      type || raise(::ArgumentError, I18n.t('errors.invalid.type_required', field_name: field_name))
    end
  end
end
